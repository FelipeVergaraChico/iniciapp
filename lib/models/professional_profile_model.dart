/// Modelo para análise e perfil profissional do usuário
class ProfessionalProfile {
  final String userId;
  final String suggestedArea; // tecnologia, logística, atendimento, administrativo
  final Map<String, double> skillScores; // habilidade -> score (0-100)
  final Map<String, int> trailPerformance; // trailId -> média de acertos
  final DateTime lastAnalyzedAt;
  final bool dataShared; // Consentimento LGPD

  ProfessionalProfile({
    required this.userId,
    required this.suggestedArea,
    required this.skillScores,
    required this.trailPerformance,
    required this.lastAnalyzedAt,
    this.dataShared = false,
  });

  factory ProfessionalProfile.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfile(
      userId: json['userId'] as String,
      suggestedArea: json['suggestedArea'] as String,
      skillScores: Map<String, double>.from(json['skillScores'] as Map),
      trailPerformance: Map<String, int>.from(json['trailPerformance'] as Map),
      lastAnalyzedAt: DateTime.parse(json['lastAnalyzedAt'] as String),
      dataShared: json['dataShared'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'suggestedArea': suggestedArea,
      'skillScores': skillScores,
      'trailPerformance': trailPerformance,
      'lastAnalyzedAt': lastAnalyzedAt.toIso8601String(),
      'dataShared': dataShared,
    };
  }

  ProfessionalProfile copyWith({
    String? userId,
    String? suggestedArea,
    Map<String, double>? skillScores,
    Map<String, int>? trailPerformance,
    DateTime? lastAnalyzedAt,
    bool? dataShared,
  }) {
    return ProfessionalProfile(
      userId: userId ?? this.userId,
      suggestedArea: suggestedArea ?? this.suggestedArea,
      skillScores: skillScores ?? this.skillScores,
      trailPerformance: trailPerformance ?? this.trailPerformance,
      lastAnalyzedAt: lastAnalyzedAt ?? this.lastAnalyzedAt,
      dataShared: dataShared ?? this.dataShared,
    );
  }

  // Retorna a habilidade principal (maior score)
  String get topSkill {
    if (skillScores.isEmpty) return 'Não avaliado';
    return skillScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // Retorna score médio geral
  double get averageScore {
    if (skillScores.isEmpty) return 0.0;
    return skillScores.values.reduce((a, b) => a + b) / skillScores.length;
  }
}

/// Perfil resumido de candidato para empresas
class CandidateProfile {
  final String userId;
  final String name;
  final int age;
  final String suggestedArea;
  final double matchScore; // 0-100
  final Map<String, double> topSkills; // top 5 skills
  final int completedTrails;
  final int totalXP;
  final DateTime lastActive;

  CandidateProfile({
    required this.userId,
    required this.name,
    required this.age,
    required this.suggestedArea,
    required this.matchScore,
    required this.topSkills,
    required this.completedTrails,
    required this.totalXP,
    required this.lastActive,
  });

  factory CandidateProfile.fromJson(Map<String, dynamic> json) {
    return CandidateProfile(
      userId: json['userId'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      suggestedArea: json['suggestedArea'] as String,
      matchScore: (json['matchScore'] as num).toDouble(),
      topSkills: Map<String, double>.from(json['topSkills'] as Map),
      completedTrails: json['completedTrails'] as int,
      totalXP: json['totalXP'] as int,
      lastActive: DateTime.parse(json['lastActive'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'suggestedArea': suggestedArea,
      'matchScore': matchScore,
      'topSkills': topSkills,
      'completedTrails': completedTrails,
      'totalXP': totalXP,
      'lastActive': lastActive.toIso8601String(),
    };
  }
}

/// Áreas profissionais disponíveis
enum ProfessionalArea {
  technology('Tecnologia', 'Desenvolvimento, TI, Suporte Técnico'),
  logistics('Logística', 'Armazenamento, Transporte, Estoque'),
  customerService('Atendimento', 'SAC, Vendas, Relacionamento'),
  administrative('Administrativo', 'Gestão, Processos, Documentação'),
  operations('Operações', 'Produção, Manutenção, Qualidade');

  final String title;
  final String description;
  const ProfessionalArea(this.title, this.description);
}

/// Mapeamento de trilhas para áreas profissionais
class TrailAreaMapping {
  static const Map<String, List<String>> trailToAreas = {
    'alfabetizacao_funcional': ['administrative', 'customerService', 'logistics'],
    'matematica_basica': ['logistics', 'operations', 'administrative'],
    'tecnologia_digital': ['technology'],
    'comunicacao_efetiva': ['customerService', 'administrative'],
    'logica_resolucao': ['technology', 'operations', 'logistics'],
  };

  static const Map<String, Map<String, double>> trailSkills = {
    'alfabetizacao_funcional': {
      'Leitura e Interpretação': 1.0,
      'Comunicação Escrita': 0.8,
      'Atenção aos Detalhes': 0.6,
    },
    'matematica_basica': {
      'Raciocínio Lógico': 1.0,
      'Cálculos Básicos': 0.9,
      'Resolução de Problemas': 0.7,
    },
    'tecnologia_digital': {
      'Ferramentas Digitais': 1.0,
      'Adaptabilidade Tecnológica': 0.8,
      'Aprendizado Rápido': 0.6,
    },
    'comunicacao_efetiva': {
      'Comunicação Verbal': 1.0,
      'Empatia': 0.8,
      'Trabalho em Equipe': 0.7,
    },
    'logica_resolucao': {
      'Pensamento Crítico': 1.0,
      'Resolução de Problemas': 0.9,
      'Organização': 0.6,
    },
  };
}
