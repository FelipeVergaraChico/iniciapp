import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson_progress_model.dart';

class TrailProgressProvider extends ChangeNotifier {
  final Map<String, LessonProgress> _lessonProgress = {};
  final Map<String, TrailProgress> _trailProgress = {};
  bool _isLoaded = false;

  Map<String, LessonProgress> get lessonProgress => _lessonProgress;
  Map<String, TrailProgress> get trailProgress => _trailProgress;

  // Inicializa o provider carregando dados salvos
  Future<void> initialize() async {
    if (_isLoaded) return;
    await _loadProgress();
    _isLoaded = true;
  }

  // Verifica se uma lição foi concluída
  bool isLessonCompleted(String lessonId) {
    return _lessonProgress[lessonId]?.isCompleted ?? false;
  }

  // Obtém o progresso de uma lição
  LessonProgress? getLessonProgress(String lessonId) {
    return _lessonProgress[lessonId];
  }

  // Obtém o progresso de uma trilha
  TrailProgress? getTrailProgress(String trailId) {
    return _trailProgress[trailId];
  }

  // Marca uma lição como concluída
  Future<void> completeLesson({
    required String lessonId,
    required String trailId,
    required int totalLessons,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required Map<String, String> userAnswers,
  }) async {
    // Salva progresso da lição
    _lessonProgress[lessonId] = LessonProgress(
      lessonId: lessonId,
      trailId: trailId,
      isCompleted: true,
      score: score,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      completedAt: DateTime.now(),
      userAnswers: userAnswers,
    );

    // Atualiza progresso da trilha - conta apenas lições desta trilha
    final completedCount = _lessonProgress.values
        .where((progress) => 
            progress.isCompleted && 
            progress.trailId == trailId)
        .length;

    final totalPoints = _lessonProgress.values
        .where((progress) => 
            progress.isCompleted && 
            progress.trailId == trailId)
        .fold(0, (sum, progress) => sum + progress.score);

    _trailProgress[trailId] = TrailProgress(
      trailId: trailId,
      completedLessons: completedCount,
      totalLessons: totalLessons,
      earnedPoints: totalPoints,
      lastAccessedAt: DateTime.now(),
    );

    // Debug log
    if (kDebugMode) {
      print('🎯 Trail Progress Updated: $trailId');
      print('   Completed: $completedCount/$totalLessons');
      print('   Progress: ${(completedCount / totalLessons * 100).toStringAsFixed(1)}%');
    }

    await _saveProgress();
    notifyListeners();
  }

  // Salva o progresso no SharedPreferences
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Salva progresso das lições
    final lessonsJson = _lessonProgress.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    await prefs.setString('lessons_progress', jsonEncode(lessonsJson));

    // Salva progresso das trilhas
    final trailsJson = _trailProgress.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    await prefs.setString('trails_progress', jsonEncode(trailsJson));
  }

  // Carrega o progresso do SharedPreferences
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Carrega progresso das lições
    final lessonsString = prefs.getString('lessons_progress');
    if (lessonsString != null) {
      final Map<String, dynamic> lessonsJson = jsonDecode(lessonsString);
      _lessonProgress.clear();
      lessonsJson.forEach((key, value) {
        _lessonProgress[key] = LessonProgress.fromJson(value);
      });
    }

    // Carrega progresso das trilhas
    final trailsString = prefs.getString('trails_progress');
    if (trailsString != null) {
      final Map<String, dynamic> trailsJson = jsonDecode(trailsString);
      _trailProgress.clear();
      trailsJson.forEach((key, value) {
        _trailProgress[key] = TrailProgress.fromJson(value);
      });
    }

    notifyListeners();
  }

  // Reseta o progresso de uma lição (para testes)
  Future<void> resetLessonProgress(String lessonId) async {
    _lessonProgress.remove(lessonId);
    await _saveProgress();
    notifyListeners();
  }

  // Reseta todo o progresso (para testes)
  Future<void> resetAllProgress() async {
    _lessonProgress.clear();
    _trailProgress.clear();
    await _saveProgress();
    notifyListeners();
  }

  // Calcula progresso percentual de uma trilha
  double getTrailProgressPercentage(String trailId) {
    final progress = _trailProgress[trailId];
    return progress?.progress ?? 0.0;
  }

  // Retorna número de lições concluídas de uma trilha
  int getCompletedLessonsCount(String trailId) {
    final progress = _trailProgress[trailId];
    return progress?.completedLessons ?? 0;
  }
}
