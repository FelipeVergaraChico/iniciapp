import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/daily_challenge_provider.dart';
import 'providers/ranking_provider.dart';
import 'providers/trail_progress_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/trails/trails_screen.dart';
import 'screens/jobs/jobs_screen.dart';
import 'screens/challenges/daily_challenge_screen.dart';
import 'screens/level_up/level_up_screen.dart';
import 'screens/ranking/ranking_screen.dart';
import 'models/user_model.dart';

void main() {
  runApp(const IniciApp());
}

class IniciApp extends StatelessWidget {
  const IniciApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => DailyChallengeProvider()..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
        ChangeNotifierProvider(
          create: (_) => TrailProgressProvider()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'IniciApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Inicializa o usuário após a construção do frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUser();
      _setupLevelUpListener();
      _checkStreak();
    });
  }

  void _checkStreak() {
    final userProvider = context.read<UserProvider>();
    final challengeProvider = context.read<DailyChallengeProvider>();

    // Verifica se precisa resetar o streak por inatividade
    challengeProvider.checkAndResetStreak(userProvider);
  }

  void _initializeUser() {
    // TODO: Load user from storage
    // For now, create a mock user
    final userProvider = context.read<UserProvider>();
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
  }

  void _setupLevelUpListener() {
    final userProvider = context.read<UserProvider>();
    userProvider.onLevelUp = (newLevel) {
      _showLevelUpScreen(newLevel);
    };
  }

  void _showLevelUpScreen(int newLevel) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: LevelUpScreen(newLevel: newLevel),
          );
        },
      ),
    );
  }

  void _navigateToDailyChallenge() async {
    final dayNumber = _getCurrentDayNumber();
    final userProvider = context.read<UserProvider>();
    
    // Navega para o desafio
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyChallengeScreen(dayNumber: dayNumber),
      ),
    );
    
    // Quando volta, verifica se há level up pendente
    userProvider.checkPendingLevelUp();
  }

  int _getCurrentDayNumber() {
    final now = DateTime.now();
    final daysSinceEpoch = now.difference(DateTime(2024, 1, 1)).inDays;
    return (daysSinceEpoch % 5) + 1; // Cicla entre dias 1-5
  }

  Widget _screenFor(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          onNavigateTab: (i) {
            if (i == -1) {
              // -1 indica navegação para desafio diário
              _navigateToDailyChallenge();
            } else {
              setState(() => _currentIndex = i);
            }
          },
        );
      case 1:
        return const TrailsScreen();
      case 2:
        return const RankingScreen();
      case 3:
        return const JobsScreen();
      case 4:
        return const Center(child: Text('Perfil - Em breve'));
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: _screenFor(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Trilhas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Vagas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
