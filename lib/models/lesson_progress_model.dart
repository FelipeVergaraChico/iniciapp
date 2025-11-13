class LessonProgress {
  final String lessonId;
  final String trailId;
  final bool isCompleted;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime? completedAt;
  final Map<String, String> userAnswers;

  LessonProgress({
    required this.lessonId,
    required this.trailId,
    required this.isCompleted,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    this.completedAt,
    required this.userAnswers,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] as String,
      trailId: json['trailId'] as String,
      isCompleted: json['isCompleted'] as bool,
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      userAnswers: Map<String, String>.from(json['userAnswers'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'trailId': trailId,
      'isCompleted': isCompleted,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'completedAt': completedAt?.toIso8601String(),
      'userAnswers': userAnswers,
    };
  }

  LessonProgress copyWith({
    String? lessonId,
    String? trailId,
    bool? isCompleted,
    int? score,
    int? totalQuestions,
    int? correctAnswers,
    DateTime? completedAt,
    Map<String, String>? userAnswers,
  }) {
    return LessonProgress(
      lessonId: lessonId ?? this.lessonId,
      trailId: trailId ?? this.trailId,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      completedAt: completedAt ?? this.completedAt,
      userAnswers: userAnswers ?? this.userAnswers,
    );
  }
}

class TrailProgress {
  final String trailId;
  final int completedLessons;
  final int totalLessons;
  final int earnedPoints;
  final DateTime? lastAccessedAt;

  TrailProgress({
    required this.trailId,
    required this.completedLessons,
    required this.totalLessons,
    required this.earnedPoints,
    this.lastAccessedAt,
  });

  double get progress {
    if (totalLessons == 0) return 0.0;
    return completedLessons / totalLessons;
  }

  bool get isCompleted => completedLessons == totalLessons;

  factory TrailProgress.fromJson(Map<String, dynamic> json) {
    return TrailProgress(
      trailId: json['trailId'] as String,
      completedLessons: json['completedLessons'] as int,
      totalLessons: json['totalLessons'] as int,
      earnedPoints: json['earnedPoints'] as int,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trailId': trailId,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'earnedPoints': earnedPoints,
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
    };
  }
}
