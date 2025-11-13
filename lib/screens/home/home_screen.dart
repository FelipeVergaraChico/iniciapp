import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../widgets/level_progress_card.dart';
import '../../widgets/streak_card.dart';
import '../../widgets/daily_challenge_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onNavigateTab});

  // Callback para navegar entre as abas do BottomNavigationBar
  final ValueChanged<int>? onNavigateTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildProgressCards(context),
              const SizedBox(height: 24),
              _buildDailyChallenge(),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildRecentActivity(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final userName = user?.name ?? 'Usuário';
    final userInitial = userName.isNotEmpty
        ? userName.substring(0, 1).toUpperCase()
        : 'U';

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary,
          child: Text(
            userInitial,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $userName!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Continue sua jornada de aprendizado',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Navigate to notifications
          },
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildProgressCards(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: LevelProgressCard()),
        SizedBox(width: 12),
        Expanded(child: StreakCard()),
      ],
    );
  }

  Widget _buildDailyChallenge() {
    return DailyChallengeCard(
      onStart: () {
        // -1 indica navegação para a tela de desafio diário
        onNavigateTab?.call(-1);
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acesso Rápido', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildQuickActionCard(
              context,
              icon: Icons.school_outlined,
              label: 'Trilhas',
              color: AppColors.primary,
              onTap: () {
                onNavigateTab?.call(1);
              },
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.emoji_events_outlined,
              label: 'Ranking',
              color: AppColors.secondary,
              onTap: () {
                onNavigateTab?.call(2);
              },
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.work_outline,
              label: 'Vagas',
              color: AppColors.accent,
              onTap: () {
                onNavigateTab?.call(3);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final streak = user?.currentStreak ?? 0;
    final streakText = streak == 1 ? 'dia' : 'dias';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Atividades Recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildActivityItem(
                  icon: Icons.check_circle,
                  title: 'Lição Concluída',
                  subtitle: 'Alfabetização Funcional - Lição 3',
                  time: 'Há 2 horas',
                  color: AppColors.success,
                ),
                const Divider(),
                _buildActivityItem(
                  icon: Icons.star,
                  title: 'Novo Nível Alcançado',
                  subtitle: 'Você agora é Aprendiz!',
                  time: 'Ontem',
                  color: AppColors.secondary,
                ),
                const Divider(),
                _buildActivityItem(
                  icon: Icons.local_fire_department,
                  title: 'Sequência Mantida',
                  subtitle: '$streak $streakText consecutivos',
                  time: 'Hoje',
                  color: AppColors.accent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }
}
