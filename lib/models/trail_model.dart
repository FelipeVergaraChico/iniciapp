enum TrailType {
  foundation, // Trilhas de Formação
  professional, // Trilhas Profissionais
}

enum TrailCategory {
  // Foundation
  functionalLiteracy,
  textInterpretation,
  logicalReasoning,
  appliedMath,
  
  // Professional
  professionalWriting,
  assertiveCommunication,
  customerService,
  ethics,
  behavioralPosture,
  prioritization,
  problemSolving,
  conflictManagement,
}

class TrailModel {
  final String id;
  final String title;
  final String description;
  final TrailType type;
  final TrailCategory category;
  final String iconPath;
  final int totalLessons;
  final int estimatedHours;
  final List<String> lessonIds;
  final int requiredLevel;

  TrailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.iconPath,
    required this.totalLessons,
    required this.estimatedHours,
    required this.lessonIds,
    this.requiredLevel = 1,
  });

  factory TrailModel.fromJson(Map<String, dynamic> json) {
    return TrailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: TrailType.values.firstWhere(
        (e) => e.toString() == 'TrailType.${json['type']}',
      ),
      category: TrailCategory.values.firstWhere(
        (e) => e.toString() == 'TrailCategory.${json['category']}',
      ),
      iconPath: json['iconPath'] as String,
      totalLessons: json['totalLessons'] as int,
      estimatedHours: json['estimatedHours'] as int,
      lessonIds: List<String>.from(json['lessonIds'] as List),
      requiredLevel: json['requiredLevel'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'category': category.toString().split('.').last,
      'iconPath': iconPath,
      'totalLessons': totalLessons,
      'estimatedHours': estimatedHours,
      'lessonIds': lessonIds,
      'requiredLevel': requiredLevel,
    };
  }
}
