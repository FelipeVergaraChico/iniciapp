class ProgressModel {
  final String userId;
  final String trailId;
  final String? lessonId;
  final int completedLessons;
  final int totalLessons;
  final double progressPercentage;
  final int pointsEarned;
  final DateTime startedAt;
  final DateTime? completedAt;
  final Map<String, LessonProgress> lessonsProgress;

  ProgressModel({
    required this.userId,
    required this.trailId,
    this.lessonId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercentage,
    required this.pointsEarned,
    required this.startedAt,
    this.completedAt,
    Map<String, LessonProgress>? lessonsProgress,
  }) : lessonsProgress = lessonsProgress ?? {};

  bool get isCompleted => completedLessons == totalLessons;

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      userId: json['userId'] as String,
      trailId: json['trailId'] as String,
      lessonId: json['lessonId'] as String?,
      completedLessons: json['completedLessons'] as int,
      totalLessons: json['totalLessons'] as int,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      pointsEarned: json['pointsEarned'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      lessonsProgress: (json['lessonsProgress'] as Map<String, dynamic>?)
              ?.map((key, value) =>
                  MapEntry(key, LessonProgress.fromJson(value))) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'trailId': trailId,
      'lessonId': lessonId,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'progressPercentage': progressPercentage,
      'pointsEarned': pointsEarned,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'lessonsProgress':
          lessonsProgress.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class LessonProgress {
  final String lessonId;
  final bool isCompleted;
  final int attemptCount;
  final int correctAnswers;
  final int totalQuestions;
  final int pointsEarned;
  final int timeSpentMinutes;
  final DateTime startedAt;
  final DateTime? completedAt;

  LessonProgress({
    required this.lessonId,
    required this.isCompleted,
    this.attemptCount = 0,
    this.correctAnswers = 0,
    this.totalQuestions = 0,
    this.pointsEarned = 0,
    this.timeSpentMinutes = 0,
    required this.startedAt,
    this.completedAt,
  });

  double get accuracy =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] as String,
      isCompleted: json['isCompleted'] as bool,
      attemptCount: json['attemptCount'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      pointsEarned: json['pointsEarned'] as int? ?? 0,
      timeSpentMinutes: json['timeSpentMinutes'] as int? ?? 0,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'isCompleted': isCompleted,
      'attemptCount': attemptCount,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'pointsEarned': pointsEarned,
      'timeSpentMinutes': timeSpentMinutes,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
