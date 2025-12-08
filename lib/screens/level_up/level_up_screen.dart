import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/app_colors.dart';

class LevelUpScreen extends StatefulWidget {
  final int newLevel;
  final VoidCallback? onClose;

  const LevelUpScreen({
    super.key,
    required this.newLevel,
    this.onClose,
  });

  @override
  State<LevelUpScreen> createState() => _LevelUpScreenState();
}

class _LevelUpScreenState extends State<LevelUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    
    // Animação de escala e fade
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    
    // Confetti
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    
    // Inicia animações
    _animationController.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.2,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accent,
                AppColors.gold,
                AppColors.success,
              ],
            ),
          ),
          
          // Conteúdo
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  margin: const EdgeInsets.all(40),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícone de estrela
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondary,
                              AppColors.gold,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.stars,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Título
                      const Text(
                        'Parabéns!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Mensagem
                      const Text(
                        'Você subiu de nível!',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Nível
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'NÍVEL',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${widget.newLevel}',
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Mensagem motivacional
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.emoji_events,
                              color: AppColors.gold,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                'Continue assim e alcance novos patamares!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Botão
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onClose?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
