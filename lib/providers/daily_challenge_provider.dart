import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_challenge_model.dart';
import '../data/daily_challenges_data.dart';

class DailyChallengeProvider extends ChangeNotifier {
  DailyChallenge? _currentChallenge;
  ChallengeProgress? _currentProgress;
  int _currentQuestionIndex = 0;
  final Map<int, ChallengeProgress> _completedChallenges =
      {}; // day -> progress
  DateTime? _lastCompletionDate;

  DailyChallenge? get currentChallenge => _currentChallenge;
  ChallengeProgress? get currentProgress => _currentProgress;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, ChallengeProgress> get completedChallenges => _completedChallenges;

  ChallengeQuestion? get currentQuestion {
    if (_currentChallenge == null || 
        _currentQuestionIndex >= _currentChallenge!.questions.length) {
      return null;
    }
    return _currentChallenge!.questions[_currentQuestionIndex];
  }

  bool get hasNextQuestion {
    if (_currentChallenge == null) return false;
    return _currentQuestionIndex < _currentChallenge!.questions.length - 1;
  }

  bool get isChallengeComplete {
    if (_currentProgress == null || _currentChallenge == null) return false;
    return _currentProgress!.totalAnswered == _currentChallenge!.totalQuestions;
  }

  int get totalPointsEarned => _currentProgress?.pointsEarned ?? 0;

  // Inicia um desafio
  void startChallenge(int dayNumber) {
    _currentChallenge = DailyChallengesData.getChallengeForDay(dayNumber);
    
    // Verifica se já existe progresso para este dia
    if (_completedChallenges.containsKey(dayNumber)) {
      _currentProgress = _completedChallenges[dayNumber];
      // Se já completou, não permite reiniciar
      if (_currentProgress!.isCompleted) {
        _currentQuestionIndex = 0;
        notifyListeners();
        return;
      }
      // Se não completou, continua de onde parou
      _currentQuestionIndex = _currentProgress!.totalAnswered;
    } else {
      // Novo desafio
      _currentProgress = ChallengeProgress(
        challengeId: _currentChallenge!.id,
        dayNumber: dayNumber,
        startedAt: DateTime.now(),
      );
      _currentQuestionIndex = 0;
    }
    
    notifyListeners();
  }

  // Responde uma questão
  void answerQuestion(String answer) {
    if (_currentChallenge == null || 
        _currentProgress == null || 
        currentQuestion == null) {
      return;
    }

    final question = currentQuestion!;
    final isCorrect = question.isCorrect(answer);
    
    // Atualiza respostas e resultados
    final updatedAnswers = Map<String, String>.from(_currentProgress!.userAnswers);
    updatedAnswers[question.id] = answer;
    
    final updatedResults = Map<String, bool>.from(_currentProgress!.results);
    updatedResults[question.id] = isCorrect;
    
    // Calcula pontos
    int points = _currentProgress!.pointsEarned;
    if (isCorrect) {
      points += question.points;
    }
    
    _currentProgress = _currentProgress!.copyWith(
      userAnswers: updatedAnswers,
      results: updatedResults,
      pointsEarned: points,
    );
    
    // Salva o progresso no histórico (mesmo que não completado)
    _completedChallenges[_currentProgress!.dayNumber] = _currentProgress!;
    
    notifyListeners();
  }

  // Avança para próxima questão
  void nextQuestion() {
    if (hasNextQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  // Completa o desafio
  Future<void> completeChallenge(dynamic userProvider) async {
    if (_currentProgress == null || _currentChallenge == null) return;
    
    int finalPoints = _currentProgress!.pointsEarned;
    
    // Se completou todas corretamente, adiciona bônus
    if (_currentProgress!.correctAnswers == _currentChallenge!.totalQuestions) {
      finalPoints += _currentChallenge!.bonusPoints;
    }
    
    _currentProgress = _currentProgress!.copyWith(
      completedAt: DateTime.now(),
      isCompleted: true,
      pointsEarned: finalPoints,
    );
    
    // Salva no histórico
    _completedChallenges[_currentChallenge!.dayNumber] = _currentProgress!;
    
    // Gerencia o streak
    if (shouldResetStreak) {
      // Se deveria ter resetado, reseta primeiro
      userProvider.resetStreak();
      print('🔄 Streak resetado por inatividade');
    }

    if (completedYesterday || userProvider.currentUser?.currentStreak == 0) {
      // Se completou ontem ou é o primeiro dia, incrementa
      userProvider.incrementStreak();
      print(
        '🔥 Streak incrementado: ${userProvider.currentUser?.currentStreak}',
      );
    }
    // Se já completou hoje, não faz nada

    // Marca como completado hoje
    await markChallengeCompleted();
    
    notifyListeners();
  }

  // Reinicia o desafio
  void resetChallenge() {
    if (_currentChallenge == null) return;
    
    _currentProgress = ChallengeProgress(
      challengeId: _currentChallenge!.id,
      dayNumber: _currentChallenge!.dayNumber,
      startedAt: DateTime.now(),
    );
    _currentQuestionIndex = 0;
    
    notifyListeners();
  }

  // Verifica se um dia já foi completado
  bool isDayCompleted(int dayNumber) {
    return _completedChallenges.containsKey(dayNumber) &&
           _completedChallenges[dayNumber]!.isCompleted;
  }

  // Verifica se um dia foi iniciado mas não completado
  bool isDayInProgress(int dayNumber) {
    return _completedChallenges.containsKey(dayNumber) &&
           !_completedChallenges[dayNumber]!.isCompleted &&
           _completedChallenges[dayNumber]!.totalAnswered > 0;
  }

  // Pega o progresso de um dia específico
  ChallengeProgress? getProgressForDay(int dayNumber) {
    return _completedChallenges[dayNumber];
  }

  // Limpa o estado atual
  void clearCurrentChallenge() {
    _currentChallenge = null;
    _currentProgress = null;
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  // Calcula total de pontos ganhos em todos os desafios
  int get totalPointsAllChallenges {
    return _completedChallenges.values
        .fold(0, (sum, progress) => sum + progress.pointsEarned);
  }

  // Número de desafios completados
  int get completedChallengesCount {
    return _completedChallenges.values
        .where((progress) => progress.isCompleted)
        .length;
  }

  // Inicializa e carrega dados salvos
  Future<void> initialize() async {
    await _loadLastCompletionDate();
  }

  // Verifica e reseta streak se necessário (chamar no início do app)
  void checkAndResetStreak(dynamic userProvider) {
    if (shouldResetStreak && userProvider.currentUser?.currentStreak != 0) {
      userProvider.resetStreak();
      print('🔄 Streak resetado automaticamente por inatividade');
    }
  }

  // Carrega a última data de conclusão
  Future<void> _loadLastCompletionDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString('last_challenge_completion');
    if (dateString != null) {
      _lastCompletionDate = DateTime.parse(dateString);
    }
  }

  // Salva a data de conclusão
  Future<void> _saveLastCompletionDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_challenge_completion', date.toIso8601String());
    _lastCompletionDate = date;
  }

  // Verifica se completou o desafio hoje
  bool get completedToday {
    if (_lastCompletionDate == null) return false;
    final now = DateTime.now();
    return _lastCompletionDate!.year == now.year &&
        _lastCompletionDate!.month == now.month &&
        _lastCompletionDate!.day == now.day;
  }

  // Verifica se completou ontem
  bool get completedYesterday {
    if (_lastCompletionDate == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _lastCompletionDate!.year == yesterday.year &&
        _lastCompletionDate!.month == yesterday.month &&
        _lastCompletionDate!.day == yesterday.day;
  }

  // Verifica se deve resetar a sequência
  bool get shouldResetStreak {
    if (_lastCompletionDate == null) return false;
    final now = DateTime.now();
    final difference = now.difference(_lastCompletionDate!);
    // Se passou mais de 1 dia, reseta
    return difference.inDays > 1;
  }

  // Marca desafio como completado e atualiza streak
  Future<void> markChallengeCompleted() async {
    await _saveLastCompletionDate(DateTime.now());
    notifyListeners();
  }
}
