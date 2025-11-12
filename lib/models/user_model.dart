class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final int level;
  final int totalPoints;
  final int currentStreak;
  final DateTime createdAt;
  final DateTime lastAccessAt;
  final Map<String, dynamic> skillsProfile;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.level = 1,
    this.totalPoints = 0,
    this.currentStreak = 0,
    required this.createdAt,
    required this.lastAccessAt,
    Map<String, dynamic>? skillsProfile,
  }) : skillsProfile = skillsProfile ?? {};

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      level: json['level'] as int? ?? 1,
      totalPoints: json['totalPoints'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAccessAt: DateTime.parse(json['lastAccessAt'] as String),
      skillsProfile: json['skillsProfile'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'level': level,
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'createdAt': createdAt.toIso8601String(),
      'lastAccessAt': lastAccessAt.toIso8601String(),
      'skillsProfile': skillsProfile,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    int? level,
    int? totalPoints,
    int? currentStreak,
    DateTime? createdAt,
    DateTime? lastAccessAt,
    Map<String, dynamic>? skillsProfile,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      level: level ?? this.level,
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      createdAt: createdAt ?? this.createdAt,
      lastAccessAt: lastAccessAt ?? this.lastAccessAt,
      skillsProfile: skillsProfile ?? this.skillsProfile,
    );
  }
}
