enum LessonType {
  theory,
  practice,
  quiz,
  challenge,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
}

class LessonModel {
  final String id;
  final String trailId;
  final String title;
  final String description;
  final LessonType type;
  final DifficultyLevel difficulty;
  final int pointsReward;
  final int estimatedMinutes;
  final List<ContentBlock> contentBlocks;
  final List<Question>? questions;
  final int order;

  LessonModel({
    required this.id,
    required this.trailId,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.pointsReward,
    required this.estimatedMinutes,
    required this.contentBlocks,
    this.questions,
    required this.order,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      trailId: json['trailId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: LessonType.values.firstWhere(
        (e) => e.toString() == 'LessonType.${json['type']}',
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.toString() == 'DifficultyLevel.${json['difficulty']}',
      ),
      pointsReward: json['pointsReward'] as int,
      estimatedMinutes: json['estimatedMinutes'] as int,
      contentBlocks: (json['contentBlocks'] as List)
          .map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trailId': trailId,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'pointsReward': pointsReward,
      'estimatedMinutes': estimatedMinutes,
      'contentBlocks': contentBlocks.map((e) => e.toJson()).toList(),
      'questions': questions?.map((e) => e.toJson()).toList(),
      'order': order,
    };
  }
}

class ContentBlock {
  final String type; // text, image, video, example
  final String content;
  final Map<String, dynamic>? metadata;

  ContentBlock({
    required this.type,
    required this.content,
    this.metadata,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: json['type'] as String,
      content: json['content'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'metadata': metadata,
    };
  }
}

class Question {
  final String id;
  final String text;
  final List<Answer> answers;
  final String correctAnswerId;
  final String explanation;
  final int points;

  Question({
    required this.id,
    required this.text,
    required this.answers,
    required this.correctAnswerId,
    required this.explanation,
    required this.points,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      answers: (json['answers'] as List)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctAnswerId: json['correctAnswerId'] as String,
      explanation: json['explanation'] as String,
      points: json['points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'answers': answers.map((e) => e.toJson()).toList(),
      'correctAnswerId': correctAnswerId,
      'explanation': explanation,
      'points': points,
    };
  }
}

class Answer {
  final String id;
  final String text;

  Answer({
    required this.id,
    required this.text,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}
