import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/lesson_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/trail_progress_provider.dart';

class LessonScreen extends StatefulWidget {
  final LessonModel lesson;

  const LessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<String, String> _userAnswers = {};
  bool _isAlreadyCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  void _loadProgress() {
    final progressProvider = context.read<TrailProgressProvider>();
    final savedProgress = progressProvider.getLessonProgress(widget.lesson.id);
    
    if (savedProgress != null && savedProgress.isCompleted) {
      setState(() {
        _isAlreadyCompleted = true;
        _userAnswers.addAll(savedProgress.userAnswers);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalPages {
    return widget.lesson.contentBlocks.length +
        (widget.lesson.questions?.length ?? 0);
  }

  bool get _isLastPage => _currentPage == _totalPages - 1;

  bool get _isContentBlock {
    return _currentPage < widget.lesson.contentBlocks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentPage + 1}/$_totalPages',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentPage + 1) / _totalPages,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),

          // Completed Badge
          if (_isAlreadyCompleted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: AppColors.info.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.info,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Lição já concluída - Revisão (sem XP adicional)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _totalPages,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                if (index < widget.lesson.contentBlocks.length) {
                  return _buildContentPage(
                      widget.lesson.contentBlocks[index]);
                } else {
                  final questionIndex =
                      index - widget.lesson.contentBlocks.length;
                  return _buildQuestionPage(
                      widget.lesson.questions![questionIndex]);
                }
              },
            ),
          ),

          // Navigation Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _canProceed() ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isLastPage ? 'Concluir Lição' : 'Próximo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPage(ContentBlock block) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.type == 'text')
            MarkdownBody(
              data: block.content,
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  height: 1.3,
                ),
                h2: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                h3: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                p: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                listBullet: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                strong: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                blockSpacing: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(Question question) {
    final selectedAnswerId = _userAnswers[question.id];
    final hasAnswered = selectedAnswerId != null;
    final isCorrect = hasAnswered && selectedAnswerId == question.correctAnswerId;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.quiz,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    question.text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Answers
          ...question.answers.map((answer) {
            final isSelected = selectedAnswerId == answer.id;
            final isCorrectAnswer = answer.id == question.correctAnswerId;
            final showCorrect = hasAnswered && isCorrectAnswer;
            final showWrong = hasAnswered && isSelected && !isCorrect;

            Color borderColor = AppColors.divider;
            Color backgroundColor = Colors.transparent;

            if (showCorrect) {
              borderColor = AppColors.success;
              backgroundColor = AppColors.success.withOpacity(0.1);
            } else if (showWrong) {
              borderColor = AppColors.error;
              backgroundColor = AppColors.error.withOpacity(0.1);
            } else if (isSelected) {
              borderColor = AppColors.primary;
              backgroundColor = AppColors.primary.withOpacity(0.05);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: hasAnswered ? null : () => _selectAnswer(question.id, answer.id),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor,
                            width: 2,
                          ),
                          color: isSelected ? borderColor : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          answer.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (showCorrect)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 24,
                        ),
                      if (showWrong)
                        const Icon(
                          Icons.cancel,
                          color: AppColors.error,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          // Feedback
          if (hasAnswered) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCorrect ? AppColors.success : AppColors.error,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? AppColors.success : AppColors.error,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isCorrect ? 'Correto!' : 'Ops!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? AppColors.success : AppColors.error,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+${question.points} XP',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.explanation,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _selectAnswer(String questionId, String answerId) {
    setState(() {
      _userAnswers[questionId] = answerId;
    });
  }

  bool _canProceed() {
    if (_isContentBlock) {
      return true;
    }

    // Para questões, precisa ter respondido
    final questionIndex = _currentPage - widget.lesson.contentBlocks.length;
    if (questionIndex >= 0 && widget.lesson.questions != null) {
      final question = widget.lesson.questions![questionIndex];
      return _userAnswers.containsKey(question.id);
    }

    return false;
  }

  void _handleNext() {
    if (_isLastPage) {
      _completeLesson();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeLesson() {
    // Calculate score
    int correctAnswers = 0;
    int totalQuestions = widget.lesson.questions?.length ?? 0;
    int totalPoints = 0;

    if (widget.lesson.questions != null) {
      for (final question in widget.lesson.questions!) {
        final userAnswer = _userAnswers[question.id];
        if (userAnswer == question.correctAnswerId) {
          correctAnswers++;
          totalPoints += question.points;
        }
      }
    }

    final progressProvider = Provider.of<TrailProgressProvider>(context, listen: false);
    
    // Verifica se já foi completada antes
    final wasAlreadyCompleted = _isAlreadyCompleted;

    // Salva o progresso (independente se já foi completada)
    progressProvider.completeLesson(
      lessonId: widget.lesson.id,
      trailId: widget.lesson.trailId,
      totalLessons: 10, // TODO: passar dinamicamente
      score: totalPoints,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      userAnswers: _userAnswers,
    );

    // Award XP apenas se não foi completada antes
    if (!wasAlreadyCompleted) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.addPoints(totalPoints);
    }

    // Show completion dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                wasAlreadyCompleted ? Icons.check_circle_outline : Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              wasAlreadyCompleted ? 'Lição Revisada!' : 'Lição Concluída!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            if (totalQuestions > 0)
              Text(
                'Você acertou $correctAnswers de $totalQuestions questões',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 8),
            if (!wasAlreadyCompleted)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.stars,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+$totalPoints XP',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.info),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Já concluída (sem XP adicional)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to trail
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
