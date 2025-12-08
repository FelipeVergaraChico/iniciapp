import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/professional_profile_model.dart';
import '../models/lesson_progress_model.dart';

class ProfessionalProfileProvider extends ChangeNotifier {
  ProfessionalProfile? _profile;
  bool _hasShownConsentDialog = false;
  static const _profileKey = 'professional_profile_v1';
  static const _consentKey = 'consent_shown_v1';

  ProfessionalProfile? get profile => _profile;
  bool get hasShownConsentDialog => _hasShownConsentDialog;
  bool get hasDataShared => _profile?.dataShared ?? false;

  // Inicializa e carrega dados salvos
  Future<void> initialize() async {
    await _loadProfile();
    await _loadConsentFlag();
  }

  // Analisa progresso das trilhas e gera perfil profissional
  Future<void> analyzeProfile(
    String userId,
    List<LessonProgress> completedLessons,
    Map<String, TrailProgress> trailProgress,
  ) async {
    if (completedLessons.isEmpty) {
      // Perfil inicial sem dados
      _profile = ProfessionalProfile(
        userId: userId,
        suggestedArea: 'Não avaliado',
        skillScores: {},
        trailPerformance: {},
        lastAnalyzedAt: DateTime.now(),
        dataShared: _profile?.dataShared ?? false,
      );
      await _persist();
      notifyListeners();
      return;
    }

    // Calcula performance por trilha (% de acertos)
    final Map<String, int> trailPerf = {};
    final Map<String, List<int>> trailScores = {};

    for (var lesson in completedLessons) {
      if (!trailScores.containsKey(lesson.trailId)) {
        trailScores[lesson.trailId] = [];
      }
      if (lesson.totalQuestions > 0) {
        final percentage = ((lesson.correctAnswers / lesson.totalQuestions) * 100).round();
        trailScores[lesson.trailId]!.add(percentage);
      }
    }

    // Média por trilha
    trailScores.forEach((trailId, scores) {
      if (scores.isNotEmpty) {
        trailPerf[trailId] = (scores.reduce((a, b) => a + b) / scores.length).round();
      }
    });

    // Calcula scores de habilidades baseado nas trilhas completadas
    final Map<String, double> skillScores = {};
    trailPerf.forEach((trailId, performance) {
      final skills = TrailAreaMapping.trailSkills[trailId];
      if (skills != null) {
        skills.forEach((skill, weight) {
          final contribution = performance * weight;
          skillScores[skill] = (skillScores[skill] ?? 0.0) + contribution;
        });
      }
    });

    // Normaliza scores (divide pelo número de trilhas que contribuem)
    final Map<String, int> skillCount = {};
    for (var trailId in trailPerf.keys) {
      final skills = TrailAreaMapping.trailSkills[trailId];
      if (skills != null) {
        for (var skill in skills.keys) {
          skillCount[skill] = (skillCount[skill] ?? 0) + 1;
        }
      }
    }
    skillScores.forEach((skill, score) {
      skillScores[skill] = score / (skillCount[skill] ?? 1);
    });

    // Determina área sugerida baseado nas trilhas e performance
    final String suggestedArea = _determineSuggestedArea(trailPerf);

    _profile = ProfessionalProfile(
      userId: userId,
      suggestedArea: suggestedArea,
      skillScores: skillScores,
      trailPerformance: trailPerf,
      lastAnalyzedAt: DateTime.now(),
      dataShared: _profile?.dataShared ?? false,
    );

    await _persist();
    notifyListeners();
  }

  String _determineSuggestedArea(Map<String, int> trailPerformance) {
    if (trailPerformance.isEmpty) return 'Não avaliado';

    // Pontuação por área
    final Map<String, double> areaScores = {};

    trailPerformance.forEach((trailId, performance) {
      final areas = TrailAreaMapping.trailToAreas[trailId] ?? [];
      for (var area in areas) {
        areaScores[area] = (areaScores[area] ?? 0.0) + performance;
      }
    });

    if (areaScores.isEmpty) return 'Não avaliado';

    // Retorna a área com maior pontuação
    final topArea = areaScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Mapeia para nome legível
    switch (topArea) {
      case 'technology':
        return 'Tecnologia';
      case 'logistics':
        return 'Logística';
      case 'customerService':
        return 'Atendimento';
      case 'administrative':
        return 'Administrativo';
      case 'operations':
        return 'Operações';
      default:
        return 'Não avaliado';
    }
  }

  // Atualiza consentimento de compartilhamento
  Future<void> updateDataSharing(bool consent) async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(dataShared: consent);
    await _persist();
    notifyListeners();
  }

  // Marca que o dialog de consentimento já foi mostrado
  Future<void> markConsentDialogShown() async {
    _hasShownConsentDialog = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, true);
  }

  // Gera perfil de candidato para visualização empresarial
  CandidateProfile? getCandidateProfile(
    String name,
    int age,
    int totalXP,
    int completedTrails,
    DateTime lastActive,
  ) {
    if (_profile == null || !_profile!.dataShared) return null;

    // Top 5 skills
    final sortedSkills = _profile!.skillScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topSkills = Map.fromEntries(
      sortedSkills.take(5),
    );

    return CandidateProfile(
      userId: _profile!.userId,
      name: name,
      age: age,
      suggestedArea: _profile!.suggestedArea,
      matchScore: _profile!.averageScore,
      topSkills: topSkills,
      completedTrails: completedTrails,
      totalXP: totalXP,
      lastActive: lastActive,
    );
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_profileKey);
    if (jsonStr != null) {
      try {
        final map = json.decode(jsonStr) as Map<String, dynamic>;
        _profile = ProfessionalProfile.fromJson(map);
      } catch (_) {
        // Ignora erros
      }
    }
  }

  Future<void> _loadConsentFlag() async {
    final prefs = await SharedPreferences.getInstance();
    _hasShownConsentDialog = prefs.getBool(_consentKey) ?? false;
  }

  Future<void> _persist() async {
    if (_profile == null) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(_profile!.toJson());
    await prefs.setString(_profileKey, jsonStr);
  }
}
