import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/development_resources_provider.dart';
import '../../providers/professional_profile_provider.dart';
import '../../models/development_resource_model.dart';

class DevelopmentResourcesScreen extends StatefulWidget {
  const DevelopmentResourcesScreen({super.key});

  @override
  State<DevelopmentResourcesScreen> createState() =>
      _DevelopmentResourcesScreenState();
}

class _DevelopmentResourcesScreenState
    extends State<DevelopmentResourcesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile =
          context.read<ProfessionalProfileProvider>().profile;
      context.read<DevelopmentResourcesProvider>().loadRecommendations(profile);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendações de Desenvolvimento'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildSearchBar(),
        ),
      ),
      body: Column(
        children: [
          _buildTypeFilter(),
          Expanded(child: _buildResourcesList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar cursos, palestras, eventos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<DevelopmentResourcesProvider>()
                        .setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          context.read<DevelopmentResourcesProvider>().setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildTypeFilter() {
    final provider = context.watch<DevelopmentResourcesProvider>();
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip('Todos', null, provider.selectedType == null),
          const SizedBox(width: 8),
          ...DevelopmentResourceType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                type.label,
                type,
                provider.selectedType == type,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, DevelopmentResourceType? type, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        context.read<DevelopmentResourcesProvider>().setTypeFilter(type);
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildResourcesList() {
    final resources = context.watch<DevelopmentResourcesProvider>().resources;

    if (resources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Nenhuma recomendação encontrada',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        return _buildResourceCard(resources[index]);
      },
    );
  }

  Widget _buildResourceCard(DevelopmentResource resource) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de patrocinado
          if (resource.isSponsored)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.amber[100],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 14, color: Colors.amber[800]),
                  const SizedBox(width: 4),
                  Text(
                    'Patrocinado por ${resource.sponsorName ?? resource.institution}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[900],
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipo e Match Score
                Row(
                  children: [
                    Text(
                      '${resource.iconEmoji} ${resource.type.label}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getMatchColor(resource.matchScore),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${resource.matchScore.toInt()}% Match',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Título
                Text(
                  resource.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Instituição
                Text(
                  resource.institution,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // Info rápida
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(Icons.devices, resource.format.label),
                    _buildInfoChip(Icons.schedule, resource.duration),
                    _buildInfoChip(
                      resource.cost == 'Gratuito'
                          ? Icons.check_circle
                          : Icons.attach_money,
                      resource.cost,
                    ),
                    if (resource.location != null)
                      _buildInfoChip(Icons.location_on, resource.location!),
                    if (resource.startDate != null)
                      _buildInfoChip(
                        Icons.calendar_today,
                        _formatDate(resource.startDate!),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Descrição
                Text(
                  resource.description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Competências
                const Text(
                  'Competências desenvolvidas:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: resource.skills.map((skill) {
                    return Chip(
                      label: Text(skill),
                      labelStyle: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                      backgroundColor: AppColors.primaryLight,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // Porque foi recomendado
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          resource.recommendationReason,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Botão de ação
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleEnrollment(resource),
                    icon: Icon(
                      resource.type == DevelopmentResourceType.course
                          ? Icons.school
                          : resource.type == DevelopmentResourceType.event
                              ? Icons.event
                              : Icons.arrow_forward,
                    ),
                    label: Text(_getButtonLabel(resource.type)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getMatchColor(double score) {
    if (score >= 90) return AppColors.success;
    if (score >= 80) return AppColors.secondary;
    if (score >= 70) return Colors.orange;
    return Colors.grey;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Amanhã';
    if (diff < 7) return 'Em $diff dias';
    if (diff < 30) return 'Em ${(diff / 7).ceil()} semanas';
    
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getButtonLabel(DevelopmentResourceType type) {
    switch (type) {
      case DevelopmentResourceType.course:
        return 'Acessar Curso';
      case DevelopmentResourceType.workshop:
        return 'Inscrever-se';
      case DevelopmentResourceType.lecture:
        return 'Participar';
      case DevelopmentResourceType.event:
        return 'Ver Detalhes';
      case DevelopmentResourceType.practicalActivity:
        return 'Iniciar Atividade';
    }
  }

  void _handleEnrollment(DevelopmentResource resource) {
    final provider = context.read<DevelopmentResourcesProvider>();
    
    // Tracking
    provider.trackResourceClick(resource.id);

    if (resource.linkUrl != null) {
      _launchUrl(resource.linkUrl!);
      provider.trackEnrollment(resource.id);
    } else {
      // Mostra detalhes ou formulário de inscrição
      _showEnrollmentDialog(resource);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link')),
        );
      }
    }
  }

  void _showEnrollmentDialog(DevelopmentResource resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Inscrição: ${resource.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Instituição: ${resource.institution}'),
            const SizedBox(height: 8),
            Text('Formato: ${resource.format.label}'),
            const SizedBox(height: 8),
            Text('Duração: ${resource.duration}'),
            const SizedBox(height: 8),
            Text('Custo: ${resource.cost}'),
            if (resource.location != null) ...[
              const SizedBox(height: 8),
              Text('Local: ${resource.location}'),
            ],
            const SizedBox(height: 16),
            const Text(
              'Entre em contato com a instituição para se inscrever.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<DevelopmentResourcesProvider>()
                  .trackEnrollment(resource.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Interesse registrado! Entraremos em contato.'),
                ),
              );
            },
            child: const Text('Tenho Interesse'),
          ),
        ],
      ),
    );
  }
}
