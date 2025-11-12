import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/user_provider.dart';

class LevelProgressCard extends StatelessWidget {
  const LevelProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;
    final level = user?.level ?? 1;
    final currentLevelXP = userProvider.currentLevelXP;
    final xpForNextLevel = userProvider.xpForNextLevel;
    final progress = userProvider.levelProgress;

    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Nível',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$level',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.secondary,
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$currentLevelXP/$xpForNextLevel XP',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
