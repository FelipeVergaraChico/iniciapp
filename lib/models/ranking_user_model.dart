class RankingUser {
  final String id;
  final String name;
  final String avatarUrl;
  final int level;
  final int totalPoints;
  final int position;
  final bool isCurrentUser;

  RankingUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.level,
    required this.totalPoints,
    required this.position,
    this.isCurrentUser = false,
  });

  RankingUser copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? level,
    int? totalPoints,
    int? position,
    bool? isCurrentUser,
  }) {
    return RankingUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      totalPoints: totalPoints ?? this.totalPoints,
      position: position ?? this.position,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
