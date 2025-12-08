import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import 'company_dashboard_screen.dart';
import 'job_posting_screen.dart';

class CompanyHomeScreen extends StatelessWidget {
  const CompanyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final companyName = user?.name ?? 'Empresa';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, companyName),
              const SizedBox(height: 24),
              _buildQuickStats(),
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

  Widget _buildHeader(BuildContext context, String companyName) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.business,
            size: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                companyName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Painel de Gestão de Talentos',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            _showCompanyMenu(context);
          },
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Vagas Ativas',
            value: '8',
            icon: Icons.work_outline,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Candidatos',
            value: '47',
            icon: Icons.people_outline,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Matches',
            value: '23',
            icon: Icons.verified_outlined,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ações Rápidas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              context,
              title: 'Nova Vaga',
              subtitle: 'Publicar oportunidade',
              icon: Icons.add_circle_outline,
              color: AppColors.success,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JobPostingScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              context,
              title: 'Candidatos',
              subtitle: 'Ver perfis',
              icon: Icons.people,
              color: AppColors.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyDashboardScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              context,
              title: 'Vagas Ativas',
              subtitle: 'Gerenciar publicações',
              icon: Icons.work,
              color: Colors.orange,
              onTap: () {
                // TODO: Tela de gerenciamento de vagas
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em breve: Gerenciar Vagas')),
                );
              },
            ),
            _buildActionCard(
              context,
              title: 'Relatórios',
              subtitle: 'Analytics e insights',
              icon: Icons.analytics,
              color: Colors.purple,
              onTap: () {
                // TODO: Tela de relatórios
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em breve: Relatórios')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
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
            _buildActivityItem(
              icon: Icons.person_add,
              title: 'Novo candidato compatível',
              subtitle: 'Ana Silva - 92% de match',
              time: 'Há 2 horas',
              color: AppColors.success,
            ),
            const Divider(),
            _buildActivityItem(
              icon: Icons.work,
              title: 'Vaga publicada',
              subtitle: 'Assistente Administrativo',
              time: 'Ontem',
              color: AppColors.primary,
            ),
            const Divider(),
            _buildActivityItem(
              icon: Icons.mail,
              title: 'Proposta enviada',
              subtitle: 'Carlos Santos aceitou',
              time: 'Há 3 dias',
              color: AppColors.secondary,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showCompanyMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações da Empresa'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em breve: Configurações')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ajuda e Suporte'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em breve: Suporte')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Limpa o usuário empresa e volta para usuário candidato padrão
    final userProvider = context.read<UserProvider>();
    userProvider.logout();
    
    // Recria o usuário candidato padrão
    userProvider.setUser(
      UserModel(
        id: '1',
        name: 'João Silva',
        email: 'joao@example.com',
        age: 18,
        level: 1,
        totalPoints: 0,
        currentStreak: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastAccessAt: DateTime.now(),
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout realizado com sucesso')),
    );
  }
}
