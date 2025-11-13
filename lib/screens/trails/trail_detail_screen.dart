import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/lesson_model.dart';
import '../../models/trail_model.dart';
import '../../providers/trail_progress_provider.dart';
import 'lesson_screen.dart';

class TrailDetailScreen extends StatelessWidget {
  final TrailModel trail;
  final List<LessonModel> lessons;

  const TrailDetailScreen({
    super.key,
    required this.trail,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trail.title),
      ),
      body: Column(
        children: [
          // Trail Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getCategoryColor(trail.category),
                  _getCategoryColor(trail.category).withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getCategoryIcon(trail.category),
                        size: 32,
                        color: _getCategoryColor(trail.category),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trail.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${trail.totalLessons} lições • ${trail.estimatedHours}h',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  trail.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.stars,
                      label: '${_calculateTotalPoints()} XP',
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.emoji_events,
                      label: 'Badge ao completar',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lessons List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return _buildLessonCard(context, lesson, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, LessonModel lesson, int index) {
    final progressProvider = context.watch<TrailProgressProvider>();
    final isCompleted = progressProvider.isLessonCompleted(lesson.id);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonScreen(lesson: lesson),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Lesson Number or Check Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success
                      : _getCategoryColor(trail.category).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(trail.category),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Lesson Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _getLessonTypeIcon(lesson.type),
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getLessonTypeLabel(lesson.type),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.estimatedMinutes} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.stars,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.pointsReward} XP',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Difficulty Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(lesson.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getDifficultyColor(lesson.difficulty),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getDifficultyLabel(lesson.difficulty),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(lesson.difficulty),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateTotalPoints() {
    return lessons.fold(0, (sum, lesson) => sum + lesson.pointsReward);
  }

  IconData _getLessonTypeIcon(LessonType type) {
    switch (type) {
      case LessonType.theory:
        return Icons.menu_book;
      case LessonType.practice:
        return Icons.edit_note;
      case LessonType.quiz:
        return Icons.quiz;
      case LessonType.challenge:
        return Icons.emoji_events;
    }
  }

  String _getLessonTypeLabel(LessonType type) {
    switch (type) {
      case LessonType.theory:
        return 'Teoria';
      case LessonType.practice:
        return 'Prática';
      case LessonType.quiz:
        return 'Quiz';
      case LessonType.challenge:
        return 'Desafio';
    }
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return AppColors.success;
      case DifficultyLevel.medium:
        return AppColors.warning;
      case DifficultyLevel.hard:
        return AppColors.error;
    }
  }

  String _getDifficultyLabel(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'FÁCIL';
      case DifficultyLevel.medium:
        return 'MÉDIO';
      case DifficultyLevel.hard:
        return 'DIFÍCIL';
    }
  }

  Color _getCategoryColor(TrailCategory category) {
    switch (category) {
      case TrailCategory.functionalLiteracy:
      case TrailCategory.textInterpretation:
        return AppColors.primary;
      case TrailCategory.logicalReasoning:
      case TrailCategory.appliedMath:
        return AppColors.info;
      case TrailCategory.professionalWriting:
      case TrailCategory.assertiveCommunication:
        return AppColors.secondary;
      case TrailCategory.customerService:
      case TrailCategory.ethics:
        return AppColors.success;
      case TrailCategory.behavioralPosture:
      case TrailCategory.prioritization:
        return AppColors.accent;
      case TrailCategory.problemSolving:
      case TrailCategory.conflictManagement:
        return AppColors.warning;
    }
  }

  IconData _getCategoryIcon(TrailCategory category) {
    switch (category) {
      case TrailCategory.functionalLiteracy:
        return Icons.translate;
      case TrailCategory.textInterpretation:
        return Icons.menu_book;
      case TrailCategory.logicalReasoning:
        return Icons.psychology;
      case TrailCategory.appliedMath:
        return Icons.calculate;
      case TrailCategory.professionalWriting:
        return Icons.edit_note;
      case TrailCategory.assertiveCommunication:
        return Icons.chat_bubble_outline;
      case TrailCategory.customerService:
        return Icons.support_agent;
      case TrailCategory.ethics:
        return Icons.balance;
      case TrailCategory.behavioralPosture:
        return Icons.self_improvement;
      case TrailCategory.prioritization:
        return Icons.list_alt;
      case TrailCategory.problemSolving:
        return Icons.lightbulb_outline;
      case TrailCategory.conflictManagement:
        return Icons.group_work;
    }
  }
}
