import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/ranking_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/ranking_user_model.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Atualiza o ranking quando a tela é carregada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final rankingProvider = context.read<RankingProvider>();
      rankingProvider.updateRanking(userProvider.currentUser);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildUserPositionCard(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTopRankingTab(),
                  _buildAroundMeTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.emoji_events, color: AppColors.gold, size: 32),
              SizedBox(width: 12),
              Text(
                'Ranking',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Compete com outros aprendizes!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPositionCard() {
    return Consumer<RankingProvider>(
      builder: (context, rankingProvider, _) {
        final currentUser = rankingProvider.getCurrentUserRanking();
        
        if (currentUser == null) {
          return const SizedBox.shrink();
        }
        
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.gold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '#${currentUser.position}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sua Posição',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentUser.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Nível ${currentUser.level}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${currentUser.totalPoints} XP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Top 10'),
          Tab(text: 'Ao Meu Redor'),
        ],
      ),
    );
  }

  Widget _buildTopRankingTab() {
    return Consumer<RankingProvider>(
      builder: (context, rankingProvider, _) {
        final topUsers = rankingProvider.getTopUsers(limit: 10);
        
        if (topUsers.isEmpty) {
          return const Center(
            child: Text('Nenhum usuário no ranking ainda'),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topUsers.length,
          itemBuilder: (context, index) {
            final user = topUsers[index];
            return _buildRankingCard(user);
          },
        );
      },
    );
  }

  Widget _buildAroundMeTab() {
    return Consumer<RankingProvider>(
      builder: (context, rankingProvider, _) {
        final aroundUsers = rankingProvider.getUsersAroundCurrent(range: 3);
        
        if (aroundUsers.isEmpty) {
          return const Center(
            child: Text('Nenhum usuário próximo'),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: aroundUsers.length,
          itemBuilder: (context, index) {
            final user = aroundUsers[index];
            return _buildRankingCard(user);
          },
        );
      },
    );
  }

  Widget _buildRankingCard(RankingUser user) {
    Color positionColor;
    IconData? medalIcon;
    
    if (user.position == 1) {
      positionColor = AppColors.gold;
      medalIcon = Icons.emoji_events;
    } else if (user.position == 2) {
      positionColor = AppColors.silver;
      medalIcon = Icons.emoji_events;
    } else if (user.position == 3) {
      positionColor = AppColors.bronze;
      medalIcon = Icons.emoji_events;
    } else {
      positionColor = AppColors.textSecondary;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: user.isCurrentUser 
            ? AppColors.secondary.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: user.isCurrentUser 
              ? AppColors.secondary 
              : AppColors.divider,
          width: user.isCurrentUser ? 2 : 1,
        ),
        boxShadow: user.isCurrentUser
            ? [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Posição
          SizedBox(
            width: 40,
            child: medalIcon != null
                ? Icon(medalIcon, color: positionColor, size: 32)
                : Text(
                    '#${user.position}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: positionColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          
          const SizedBox(width: 12),
          
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            child: Text(
              user.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Nome e nível
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: user.isCurrentUser 
                              ? FontWeight.bold 
                              : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user.isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'VOCÊ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Nível ${user.level}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Pontos
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.totalPoints}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
