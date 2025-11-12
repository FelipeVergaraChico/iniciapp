class AppConstants {
  // App Info
  static const String appName = 'IniciApp';
  static const String appVersion = '1.0.0';
  
  // Age Range
  static const int minAge = 14;
  static const int maxAge = 25;
  
  // Gamification
  static const int pointsPerLesson = 10;
  static const int pointsPerDailyChallenge = 20;
  static const int streakBonusPoints = 5;
  static const int levelUpThreshold = 100;
  
  // Levels
  static const List<String> levelTitles = [
    'Iniciante',
    'Aprendiz',
    'Praticante',
    'Competente',
    'Proficiente',
    'Expert',
    'Mestre',
  ];
  
  // Badges
  static const List<String> badgeCategories = [
    'Alfabetização Funcional',
    'Comunicação',
    'Raciocínio Lógico',
    'Matemática Aplicada',
    'Postura Profissional',
    'Resolução de Problemas',
  ];
  
  // Database
  static const String dbName = 'iniciapp.db';
  static const int dbVersion = 1;
  
  // Storage Keys
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserLevel = 'user_level';
  static const String keyUserPoints = 'user_points';
  static const String keyLastAccess = 'last_access';
  static const String keyCurrentStreak = 'current_streak';
}
