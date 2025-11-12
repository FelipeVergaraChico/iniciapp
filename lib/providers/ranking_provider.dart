import 'package:flutter/foundation.dart';
import '../models/ranking_user_model.dart';
import '../models/user_model.dart';

class RankingProvider extends ChangeNotifier {
  List<RankingUser> _rankingUsers = [];
  
  List<RankingUser> get rankingUsers => _rankingUsers;
  
  // Usuários fictícios para o leaderboard
  final List<Map<String, dynamic>> _mockUsers = [
    {'name': 'Ana Silva', 'points': 850},
    {'name': 'Carlos Mendes', 'points': 720},
    {'name': 'Beatriz Costa', 'points': 680},
    {'name': 'Diego Santos', 'points': 620},
    {'name': 'Elena Rodrigues', 'points': 580},
    {'name': 'Fernando Lima', 'points': 540},
    {'name': 'Gabriela Alves', 'points': 490},
    {'name': 'Henrique Souza', 'points': 450},
    {'name': 'Isabela Martins', 'points': 410},
    {'name': 'João Pereira', 'points': 380},
    {'name': 'Karina Oliveira', 'points': 340},
    {'name': 'Leonardo Ferreira', 'points': 310},
    {'name': 'Mariana Gomes', 'points': 280},
    {'name': 'Nicolas Araújo', 'points': 250},
    {'name': 'Olivia Barbosa', 'points': 220},
    {'name': 'Pedro Castro', 'points': 190},
    {'name': 'Quésia Rocha', 'points': 165},
    {'name': 'Rafael Dias', 'points': 140},
    {'name': 'Sofia Ribeiro', 'points': 115},
    {'name': 'Thiago Cardoso', 'points': 95},
    {'name': 'Ursula Moreira', 'points': 75},
    {'name': 'Vitor Nascimento', 'points': 55},
    {'name': 'Wesley Campos', 'points': 40},
    {'name': 'Yasmin Freitas', 'points': 25},
    {'name': 'Zeca Duarte', 'points': 10},
  ];
  
  void updateRanking(UserModel? currentUser) {
    if (currentUser == null) return;
    
    // Cria lista com usuários fictícios
    List<RankingUser> allUsers = _mockUsers.asMap().entries.map((entry) {
      final index = entry.key;
      final user = entry.value;
      return RankingUser(
        id: 'mock_$index',
        name: user['name'] as String,
        avatarUrl: '',
        level: ((user['points'] as int) / 100).floor() + 1,
        totalPoints: user['points'] as int,
        position: 0, // Será calculado depois
        isCurrentUser: false,
      );
    }).toList();
    
    // Adiciona o usuário atual
    final currentRankingUser = RankingUser(
      id: currentUser.id,
      name: currentUser.name,
      avatarUrl: '',
      level: currentUser.level,
      totalPoints: currentUser.totalPoints,
      position: 0,
      isCurrentUser: true,
    );
    
    allUsers.add(currentRankingUser);
    
    // Ordena por pontos (decrescente)
    allUsers.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    
    // Atribui posições
    _rankingUsers = allUsers.asMap().entries.map((entry) {
      return entry.value.copyWith(position: entry.key + 1);
    }).toList();
    
    notifyListeners();
  }
  
  RankingUser? getCurrentUserRanking() {
    try {
      return _rankingUsers.firstWhere((user) => user.isCurrentUser);
    } catch (e) {
      return null;
    }
  }
  
  List<RankingUser> getTopUsers({int limit = 10}) {
    return _rankingUsers.take(limit).toList();
  }
  
  // Retorna usuários ao redor do usuário atual
  List<RankingUser> getUsersAroundCurrent({int range = 2}) {
    final currentUser = getCurrentUserRanking();
    if (currentUser == null) return [];
    
    final position = currentUser.position;
    final startIndex = (position - 1 - range).clamp(0, _rankingUsers.length - 1);
    final endIndex = (position + range).clamp(0, _rankingUsers.length);
    
    return _rankingUsers.sublist(startIndex, endIndex);
  }
}
