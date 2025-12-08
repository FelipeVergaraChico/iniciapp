import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  Function(int newLevel)? onLevelUp;
  int? _pendingLevelUp; // Armazena o novo nível pendente
  static const _storageKey = 'user_profile_v1';

  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;
  
  int? get pendingLevelUp => _pendingLevelUp;

  void setUser(UserModel user) {
    _currentUser = user;
    _persist();
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _currentUser = user;
    _persist();
    notifyListeners();
  }

  void addPoints(int points) {
    if (_currentUser == null) return;
    
    _currentUser = _currentUser!.copyWith(
      totalPoints: _currentUser!.totalPoints + points,
    );
    
    // Check for level up
    _checkLevelUp();
    _persist();
    notifyListeners();
  }

  void incrementStreak() {
    if (_currentUser == null) return;
    
    _currentUser = _currentUser!.copyWith(
      currentStreak: _currentUser!.currentStreak + 1,
    );
    _persist();
    notifyListeners();
  }

  void resetStreak() {
    if (_currentUser == null) return;
    
    _currentUser = _currentUser!.copyWith(
      currentStreak: 0,
    );
    _persist();
    notifyListeners();
  }

  void _checkLevelUp() {
    if (_currentUser == null) return;
    
    const int pointsPerLevel = 100;
    final int newLevel = (_currentUser!.totalPoints / pointsPerLevel).floor() + 1;
    
    if (newLevel > _currentUser!.level) {
      _currentUser = _currentUser!.copyWith(level: newLevel);
      
      // Dispara callback de level up se disponível
      if (onLevelUp != null) {
        onLevelUp!(newLevel);
      } else {
        // Se não tem callback, armazena como pendente
        _pendingLevelUp = newLevel;
      }
    }
  }
  
  // Dispara o level up pendente (se houver)
  void checkPendingLevelUp() {
    if (_pendingLevelUp != null && onLevelUp != null) {
      final level = _pendingLevelUp!;
      _pendingLevelUp = null;
      onLevelUp!(level);
    }
  }
  
  // Limpa o level up pendente sem disparar
  void clearPendingLevelUp() {
    _pendingLevelUp = null;
  }
  
  // Retorna XP necessário para o próximo nível
  int get xpForNextLevel {
    if (_currentUser == null) return 100;
    return (_currentUser!.level) * 100;
  }
  
  // Retorna XP atual no nível
  int get currentLevelXP {
    if (_currentUser == null) return 0;
    return _currentUser!.totalPoints - ((_currentUser!.level - 1) * 100);
  }
  
  // Retorna progresso percentual no nível atual (0.0 a 1.0)
  double get levelProgress {
    if (_currentUser == null) return 0;
    return currentLevelXP / 100;
  }

  void updateSkillsProfile(String skill, dynamic value) {
    if (_currentUser == null) return;
    
    final updatedSkills = Map<String, dynamic>.from(_currentUser!.skillsProfile);
    updatedSkills[skill] = value;
    
    _currentUser = _currentUser!.copyWith(skillsProfile: updatedSkills);
    _persist();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _persist();
    notifyListeners();
  }

  // Carrega usuário do storage (chamar no boot)
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr != null) {
      try {
        final map = json.decode(jsonStr) as Map<String, dynamic>;
        _currentUser = UserModel.fromJson(map);
      } catch (_) {
        // Ignora erros de parsing e mantém null
      }
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser == null) {
      await prefs.remove(_storageKey);
    } else {
      final jsonStr = json.encode(_currentUser!.toJson());
      await prefs.setString(_storageKey, jsonStr);
    }
  }
}
