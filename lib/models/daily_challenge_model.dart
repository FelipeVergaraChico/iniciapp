enum QuestionType {
  multipleChoice,
  numericInput,
  textInput,
}

enum DifficultyTag {
  basic,    // Básico - 🟢
  medium,   // Mediano - 🟣
}

class ChallengeQuestion {
  final String id;
  final String text;
  final QuestionType type;
  final DifficultyTag difficulty;
  final int points;
  final String? context; // Texto adicional/cenário antes da pergunta
  
  // Para múltipla escolha
  final List<String>? options;
  final String? correctOption; // Letra da resposta correta (a, b, c)
  
  // Para input numérico/texto
  final String? correctAnswer;
  
  final String explanation;
  final String? skillTag; // Ex: "Comunicação ética e empática"

  ChallengeQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.difficulty,
    required this.points,
    this.context,
    this.options,
    this.correctOption,
    this.correctAnswer,
    required this.explanation,
    this.skillTag,
  });

  bool isCorrect(String userAnswer) {
    if (type == QuestionType.multipleChoice) {
      // Aceita tanto a letra ('a', 'b', 'c') quanto o texto completo da opção
      final normalizedAnswer = userAnswer.trim().toLowerCase();
      final normalizedCorrect = correctOption?.toLowerCase() ?? '';
      
      // Se resposta é só uma letra, compara direto
      if (normalizedAnswer.length == 1) {
        return normalizedAnswer == normalizedCorrect;
      }
      
      // Se resposta é o texto completo, extrai a letra do início
      // Ex: "a) Texto..." ou "a) \"Texto...\""
      final letterMatch = RegExp(r'^([a-z])\)').firstMatch(normalizedAnswer);
      if (letterMatch != null) {
        return letterMatch.group(1) == normalizedCorrect;
      }
      
      // Fallback: compara o texto completo
      return normalizedAnswer == normalizedCorrect;
    } else {
      // Para numérico e texto, comparação direta
      return userAnswer.trim().toLowerCase() == 
             correctAnswer?.trim().toLowerCase();
    }
  }

  String get difficultyEmoji {
    switch (difficulty) {
      case DifficultyTag.basic:
        return '🟢';
      case DifficultyTag.medium:
        return '🟣';
    }
  }
}

class DailyChallenge {
  final String id;
  final int dayNumber;
  final String title;
  final String description;
  final List<ChallengeQuestion> questions;
  final int bonusPoints; // Bônus por completar todas

  DailyChallenge({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.description,
    required this.questions,
    this.bonusPoints = 0,
  });

  int get totalPoints {
    return questions.fold(0, (sum, q) => sum + q.points) + bonusPoints;
  }

  int get totalQuestions => questions.length;
}

class ChallengeProgress {
  final String challengeId;
  final int dayNumber;
  final Map<String, String> userAnswers; // questionId -> userAnswer
  final Map<String, bool> results; // questionId -> isCorrect
  final int pointsEarned;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;

  ChallengeProgress({
    required this.challengeId,
    required this.dayNumber,
    Map<String, String>? userAnswers,
    Map<String, bool>? results,
    this.pointsEarned = 0,
    required this.startedAt,
    this.completedAt,
    this.isCompleted = false,
  })  : userAnswers = userAnswers ?? {},
        results = results ?? {};

  ChallengeProgress copyWith({
    String? challengeId,
    int? dayNumber,
    Map<String, String>? userAnswers,
    Map<String, bool>? results,
    int? pointsEarned,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return ChallengeProgress(
      challengeId: challengeId ?? this.challengeId,
      dayNumber: dayNumber ?? this.dayNumber,
      userAnswers: userAnswers ?? this.userAnswers,
      results: results ?? this.results,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  int get correctAnswers {
    return results.values.where((correct) => correct).length;
  }

  int get totalAnswered => userAnswers.length;

  double get accuracy {
    if (totalAnswered == 0) return 0.0;
    return (correctAnswers / totalAnswered) * 100;
  }
}
