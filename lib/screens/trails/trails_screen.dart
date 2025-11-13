import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/trail_model.dart';
import '../../data/alfabetizacao_funcional_data.dart';
import '../../providers/trail_progress_provider.dart';
import 'trail_detail_screen.dart';

class TrailsScreen extends StatelessWidget {
  const TrailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trilhas de Aprendizado'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: AppColors.surface,
              child: const TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(
                    icon: Icon(Icons.auto_stories),
                    text: 'Formação',
                  ),
                  Tab(
                    icon: Icon(Icons.business_center),
                    text: 'Profissional',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTrailsList(context, TrailType.foundation),
                  _buildTrailsList(context, TrailType.professional),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailsList(BuildContext context, TrailType type) {
    // Mock data for demonstration
    final trails = _getMockTrails(type);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trails.length,
      itemBuilder: (context, index) {
        return _buildTrailCard(context, trails[index]);
      },
    );
  }

  Widget _buildTrailCard(BuildContext context, TrailModel trail) {
    final progressProvider = context.watch<TrailProgressProvider>();
    final progress = progressProvider.getTrailProgressPercentage(trail.id);
    final completedLessons = progressProvider.getCompletedLessonsCount(
      trail.id,
    );
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _openTrail(context, trail);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(trail.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(trail.category),
                      color: _getCategoryColor(trail.category),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trail.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${trail.estimatedHours}h',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.book,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${trail.totalLessons} lições',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (trail.requiredLevel > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Nv ${trail.requiredLevel}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                trail.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getCategoryColor(trail.category),
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                progress > 0
                    ? '$completedLessons/${trail.totalLessons} lições • ${(progress * 100).toInt()}% concluído'
                    : 'Nenhuma lição concluída',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTrail(BuildContext context, TrailModel trail) {
    // For now, only Alfabetização Funcional is implemented
    if (trail.category == TrailCategory.functionalLiteracy) {
      final trailData = AlfabetizacaoFuncionalData.getTrail();
      final lessons = AlfabetizacaoFuncionalData.getLessons();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TrailDetailScreen(trail: trailData, lessons: lessons),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta trilha ainda está em desenvolvimento'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  Color _getCategoryColor(TrailCategory category) {
    switch (category) {
      case TrailCategory.functionalLiteracy:
      case TrailCategory.textInterpretation:
        return AppColors.primary;
      case TrailCategory.logicalReasoning:
      case TrailCategory.appliedMath:
        return AppColors.info;
      case TrailCategory.professionalWriting:
      case TrailCategory.assertiveCommunication:
        return AppColors.secondary;
      case TrailCategory.customerService:
      case TrailCategory.ethics:
        return AppColors.success;
      case TrailCategory.behavioralPosture:
      case TrailCategory.prioritization:
        return AppColors.accent;
      case TrailCategory.problemSolving:
      case TrailCategory.conflictManagement:
        return AppColors.warning;
    }
  }

  IconData _getCategoryIcon(TrailCategory category) {
    switch (category) {
      case TrailCategory.functionalLiteracy:
        return Icons.translate;
      case TrailCategory.textInterpretation:
        return Icons.menu_book;
      case TrailCategory.logicalReasoning:
        return Icons.psychology;
      case TrailCategory.appliedMath:
        return Icons.calculate;
      case TrailCategory.professionalWriting:
        return Icons.edit_note;
      case TrailCategory.assertiveCommunication:
        return Icons.chat_bubble_outline;
      case TrailCategory.customerService:
        return Icons.support_agent;
      case TrailCategory.ethics:
        return Icons.balance;
      case TrailCategory.behavioralPosture:
        return Icons.self_improvement;
      case TrailCategory.prioritization:
        return Icons.list_alt;
      case TrailCategory.problemSolving:
        return Icons.lightbulb_outline;
      case TrailCategory.conflictManagement:
        return Icons.group_work;
    }
  }

  List<TrailModel> _getMockTrails(TrailType type) {
    if (type == TrailType.foundation) {
      return [
        TrailModel(
          id: 'alfabetizacao_funcional',
          title: 'Alfabetização Funcional',
          description:
              'Compreensão prática do mundo real através da leitura e escrita aplicada ao cotidiano profissional.',
          type: TrailType.foundation,
          category: TrailCategory.functionalLiteracy,
          iconPath: '',
          totalLessons: 10,
          estimatedHours: 8,
          lessonIds: [],
          requiredLevel: 1,
        ),
        TrailModel(
          id: '2',
          title: 'Interpretação de Texto',
          description:
              'Desenvolva habilidades de leitura crítica e compreensão de diferentes tipos de textos.',
          type: TrailType.foundation,
          category: TrailCategory.textInterpretation,
          iconPath: '',
          totalLessons: 12,
          estimatedHours: 6,
          lessonIds: [],
          requiredLevel: 1,
        ),
        TrailModel(
          id: '3',
          title: 'Raciocínio Lógico',
          description:
              'Aprimore sua capacidade de pensar logicamente e resolver problemas complexos.',
          type: TrailType.foundation,
          category: TrailCategory.logicalReasoning,
          iconPath: '',
          totalLessons: 18,
          estimatedHours: 10,
          lessonIds: [],
          requiredLevel: 2,
        ),
        TrailModel(
          id: '4',
          title: 'Matemática Aplicada',
          description:
              'Matemática prática para o dia a dia profissional: cálculos, percentuais e análise de dados.',
          type: TrailType.foundation,
          category: TrailCategory.appliedMath,
          iconPath: '',
          totalLessons: 20,
          estimatedHours: 12,
          lessonIds: [],
          requiredLevel: 2,
        ),
      ];
    } else {
      return [
        TrailModel(
          id: '5',
          title: 'Escrita Profissional',
          description:
              'Aprenda a se comunicar efetivamente por e-mail e mensagens corporativas.',
          type: TrailType.professional,
          category: TrailCategory.professionalWriting,
          iconPath: '',
          totalLessons: 10,
          estimatedHours: 5,
          lessonIds: [],
          requiredLevel: 1,
        ),
        TrailModel(
          id: '6',
          title: 'Comunicação Assertiva',
          description:
              'Desenvolva habilidades de comunicação clara e respeitosa no ambiente profissional.',
          type: TrailType.professional,
          category: TrailCategory.assertiveCommunication,
          iconPath: '',
          totalLessons: 14,
          estimatedHours: 7,
          lessonIds: [],
          requiredLevel: 1,
        ),
        TrailModel(
          id: '7',
          title: 'Atendimento ao Cliente',
          description:
              'Técnicas e práticas para oferecer um atendimento de excelência.',
          type: TrailType.professional,
          category: TrailCategory.customerService,
          iconPath: '',
          totalLessons: 16,
          estimatedHours: 8,
          lessonIds: [],
          requiredLevel: 2,
        ),
        TrailModel(
          id: '8',
          title: 'Ética Profissional',
          description:
              'Compreenda e aplique princípios éticos no ambiente de trabalho.',
          type: TrailType.professional,
          category: TrailCategory.ethics,
          iconPath: '',
          totalLessons: 8,
          estimatedHours: 4,
          lessonIds: [],
          requiredLevel: 1,
        ),
        TrailModel(
          id: '9',
          title: 'Postura Comportamental',
          description:
              'Desenvolva comportamentos adequados para o ambiente corporativo.',
          type: TrailType.professional,
          category: TrailCategory.behavioralPosture,
          iconPath: '',
          totalLessons: 12,
          estimatedHours: 6,
          lessonIds: [],
          requiredLevel: 2,
        ),
        TrailModel(
          id: '10',
          title: 'Resolução de Problemas',
          description:
              'Aprenda metodologias para identificar e resolver problemas de forma eficaz.',
          type: TrailType.professional,
          category: TrailCategory.problemSolving,
          iconPath: '',
          totalLessons: 15,
          estimatedHours: 8,
          lessonIds: [],
          requiredLevel: 3,
        ),
      ];
    }
  }
}
