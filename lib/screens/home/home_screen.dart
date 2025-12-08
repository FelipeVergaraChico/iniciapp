import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../widgets/level_progress_card.dart';
import '../../widgets/streak_card.dart';
import '../../widgets/daily_challenge_card.dart';
import '../profile/profile_screen.dart';
import '../company/company_dashboard_screen.dart';
import '../company/company_login_screen.dart';
import '../development/development_resources_screen.dart';

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
              _buildFeaturedCourses(context),
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
        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
          },
          child: CircleAvatar(
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
        PopupMenuButton(
          icon: const Icon(Icons.business),
          tooltip: 'Área Empresarial',
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'login',
              child: Row(
                children: [
                  Icon(Icons.login),
                  SizedBox(width: 8),
                  Text('Login Empresarial'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'dashboard',
              child: Row(
                children: [
                  Icon(Icons.dashboard),
                  SizedBox(width: 8),
                  Text('Dashboard (Demo)'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'login') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompanyLoginScreen()),
              );
            } else if (value == 'dashboard') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CompanyDashboardScreen(),
                ),
              );
            }
          },
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
            _buildQuickActionCard(
              context,
              icon: Icons.auto_stories_outlined,
              label: 'Cursos',
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DevelopmentResourcesScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.event_outlined,
              label: 'Eventos',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DevelopmentResourcesScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionCard(
              context,
              icon: Icons.business_outlined,
              label: 'Empresas',
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyDashboardScreen(),
                  ),
                );
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

  Widget _buildFeaturedCourses(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DevelopmentResourcesScreen(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[600]!, Colors.deepPurple[800]!],
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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recomendações para Você',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Cursos, workshops e eventos',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'NOVO',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Descubra oportunidades de desenvolvimento profissional personalizadas para você!',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFeatureBadge('📚 8+ Cursos'),
                    const SizedBox(width: 8),
                    _buildFeatureBadge('🎯 Alta relevância'),
                    const SizedBox(width: 8),
                    _buildFeatureBadge('💰 Grátis'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
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
