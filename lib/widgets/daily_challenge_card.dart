import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/daily_challenge_provider.dart';
import '../data/daily_challenges_data.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key, this.onStart});

  final VoidCallback? onStart;

  int _getCurrentDayNumber() {
    final now = DateTime.now();
    final daysSinceEpoch = now.difference(DateTime(2024, 1, 1)).inDays;
    return (daysSinceEpoch % 5) + 1; // Cicla entre dias 1-5
  }

  @override
  Widget build(BuildContext context) {
    final dayNumber = _getCurrentDayNumber();
    final challenge = DailyChallengesData.getChallengeForDay(dayNumber);
    final provider = context.watch<DailyChallengeProvider>();
    final isCompleted = provider.isDayCompleted(dayNumber);
    final isInProgress = provider.isDayInProgress(dayNumber);
    final progress = provider.getProgressForDay(dayNumber);
    
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isCompleted
                ? [
                    AppColors.success.withOpacity(0.2),
                    AppColors.success.withOpacity(0.1),
                  ]
                : [
                    AppColors.secondary.withOpacity(0.2),
                    AppColors.accent.withOpacity(0.1),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.success : AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_circle : Icons.flash_on,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Desafio Diário - Dia $dayNumber',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          isCompleted
                              ? '+${progress?.pointsEarned ?? 0} XP conquistados! 🎉'
                              : 'Ganhe até ${challenge.totalPoints} XP',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isCompleted ? AppColors.success : AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                challenge.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              if (isInProgress)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.hourglass_bottom,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${progress?.totalAnswered ?? 0}/${challenge.totalQuestions} concluídas',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  '${challenge.totalQuestions} questões',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              if (!isCompleted) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInProgress ? AppColors.warning : AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isInProgress ? 'Retomar Desafio' : 'Começar Agora'),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.stars,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Desafio completo! Volte amanhã para um novo.',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
