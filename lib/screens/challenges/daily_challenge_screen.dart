import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/daily_challenge_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/daily_challenge_model.dart';

class DailyChallengeScreen extends StatefulWidget {
  final int dayNumber;

  const DailyChallengeScreen({
    super.key,
    required this.dayNumber,
  });

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  final TextEditingController _answerController = TextEditingController();
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyChallengeProvider>().startChallenge(widget.dayNumber);
      _loadPreviousAnswer();
    });
  }

  void _loadPreviousAnswer() {
    final provider = context.read<DailyChallengeProvider>();
    final question = provider.currentQuestion;
    
    if (question == null) return;
    
    // Se já foi respondida, carrega a resposta anterior
    final previousAnswer = provider.currentProgress?.userAnswers[question.id];
    if (previousAnswer != null) {
      setState(() {
        if (question.type == QuestionType.multipleChoice) {
          _selectedOption = previousAnswer;
        } else {
          _answerController.text = previousAnswer;
        }
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    final provider = context.read<DailyChallengeProvider>();
    final question = provider.currentQuestion;
    
    if (question == null) return;
    
    // Verifica se já foi respondida
    if (provider.currentProgress?.userAnswers.containsKey(question.id) ?? false) {
      // Já respondida, apenas avança
      _nextQuestionOrComplete();
      return;
    }
    
    String? answer;
    if (question.type == QuestionType.multipleChoice) {
      answer = _selectedOption;
    } else {
      answer = _answerController.text.trim();
    }
    
    if (answer == null || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione ou digite uma resposta')),
      );
      return;
    }
    
    provider.answerQuestion(answer);
    
    // Mostra resultado
    _showResultDialog(question.isCorrect(answer), question);
  }

  void _showResultDialog(bool isCorrect, ChallengeQuestion question) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? AppColors.success : AppColors.error,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              isCorrect ? 'Correto!' : 'Ops!',
              style: TextStyle(
                color: isCorrect ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isCorrect)
              Text(
                '+${question.points} XP',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              question.explanation,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextQuestionOrComplete();
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _nextQuestionOrComplete() async {
    final provider = context.read<DailyChallengeProvider>();
    final userProvider = context.read<UserProvider>();
    
    if (provider.hasNextQuestion) {
      // Próxima questão
      provider.nextQuestion();
      setState(() {
        _selectedOption = null;
        _answerController.clear();
      });
      // Carrega resposta anterior se existir
      _loadPreviousAnswer();
    } else {
      // Completar desafio
      await provider.completeChallenge(userProvider);
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final provider = context.read<DailyChallengeProvider>();
    final userProvider = context.read<UserProvider>();
    final points = provider.totalPointsEarned;
    final accuracy = provider.currentProgress?.accuracy ?? 0;
    
    // Guarda o callback original e desabilita temporariamente
    final originalCallback = userProvider.onLevelUp;
    userProvider.onLevelUp = null;
    
    // Adiciona pontos ao usuário (sem disparar level up)
    userProvider.addPoints(points);
    
    // Restaura o callback
    userProvider.onLevelUp = originalCallback;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.stars, color: AppColors.gold, size: 32),
            SizedBox(width: 12),
            Text('Desafio Completo!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '$points XP',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aproveitamento: ${accuracy.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (accuracy >= 80)
              const Text(
                '🎉 Excelente trabalho!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            else if (accuracy >= 60)
              const Text(
                '👍 Bom trabalho!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            else
              const Text(
                '💪 Continue praticando!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha dialog
              Navigator.pop(context); // Volta para home
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Consumer<DailyChallengeProvider>(
          builder: (context, provider, _) {
            return Text(
              provider.currentChallenge?.title ?? 'Desafio Diário',
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        elevation: 0,
      ),
      body: Consumer<DailyChallengeProvider>(
        builder: (context, provider, _) {
          final challenge = provider.currentChallenge;
          final question = provider.currentQuestion;
          
          if (challenge == null || question == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Column(
            children: [
              // Progress bar
              Container(
                height: 8,
                color: AppColors.background,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (provider.currentQuestionIndex + 1) / 
                               challenge.totalQuestions,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question number and points
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Questão ${provider.currentQuestionIndex + 1} de ${challenge.totalQuestions}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.stars,
                                  size: 16,
                                  color: AppColors.gold,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${question.points} XP',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Difficulty tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: question.difficulty == DifficultyTag.basic
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          question.difficulty == DifficultyTag.basic
                              ? '🟢 Básico'
                              : '🟣 Mediano',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: question.difficulty == DifficultyTag.basic
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Question context (if exists)
                      if (question.context != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            question.context!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      
                      // Question text
                      Text(
                        question.text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Answer input based on question type
                      if (question.type == QuestionType.multipleChoice)
                        _buildMultipleChoice(question)
                      else if (question.type == QuestionType.numericInput)
                        _buildNumericInput()
                      else
                        _buildTextInput(),
                      
                      const SizedBox(height: 24),
                      
                      // Skill tag (if exists)
                      if (question.skillTag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                size: 16,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Habilidade: ${question.skillTag}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Submit button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.currentProgress?.userAnswers.containsKey(question.id) ?? false
                          ? AppColors.success
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      provider.currentProgress?.userAnswers.containsKey(question.id) ?? false
                          ? 'Próxima Questão'
                          : 'Confirmar Resposta',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMultipleChoice(ChallengeQuestion question) {
    return Column(
      children: question.options!.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final optionLetter = String.fromCharCode(65 + index); // A, B, C, D
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedOption = option;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedOption == option
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedOption == option
                      ? AppColors.primary
                      : AppColors.divider,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _selectedOption == option
                          ? AppColors.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedOption == option
                            ? AppColors.primary
                            : AppColors.divider,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        optionLetter,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedOption == option
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 15,
                        color: _selectedOption == option
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: _selectedOption == option
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumericInput() {
    return TextField(
      controller: _answerController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Digite sua resposta numérica',
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildTextInput() {
    return TextField(
      controller: _answerController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Digite sua resposta',
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
