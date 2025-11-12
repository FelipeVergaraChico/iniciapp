import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/job_model.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  JobCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vagas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: _buildJobsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip('Todas', null),
          const SizedBox(width: 8),
          _buildCategoryChip('Administração', JobCategory.administration),
          const SizedBox(width: 8),
          _buildCategoryChip('Vendas', JobCategory.sales),
          const SizedBox(width: 8),
          _buildCategoryChip('Atendimento', JobCategory.customerService),
          const SizedBox(width: 8),
          _buildCategoryChip('Tecnologia', JobCategory.technology),
          const SizedBox(width: 8),
          _buildCategoryChip('Logística', JobCategory.logistics),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, JobCategory? category) {
    final isSelected = _selectedCategory == category;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildJobsList() {
    final jobs = _getMockJobs();
    final filteredJobs = _selectedCategory == null
        ? jobs
        : jobs.where((job) => job.category == _selectedCategory).toList();

    if (filteredJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma vaga encontrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tente outro filtro',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) {
        return _buildJobCard(filteredJobs[index]);
      },
    );
  }

  Widget _buildJobCard(JobModel job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to job details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Abrindo vaga: ${job.title}')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.companyName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getMatchColor(85).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '85%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getMatchColor(85),
                          ),
                        ),
                        Text(
                          'Match',
                          style: TextStyle(
                            fontSize: 10,
                            color: _getMatchColor(85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: Icons.location_on,
                    label: job.location,
                  ),
                  if (job.isRemote)
                    _buildInfoChip(
                      icon: Icons.home_work,
                      label: 'Remoto',
                    ),
                  if (job.salaryRange != null)
                    _buildInfoChip(
                      icon: Icons.attach_money,
                      label: job.salaryRange!,
                    ),
                  _buildInfoChip(
                    icon: Icons.work_outline,
                    label: _getExperienceLevelLabel(job.experienceLevel),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Save job
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      child: const Text('Salvar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Apply for job
                      },
                      child: const Text('Candidatar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
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
      ),
    );
  }

  Color _getMatchColor(int matchPercentage) {
    if (matchPercentage >= 80) return AppColors.success;
    if (matchPercentage >= 60) return AppColors.secondary;
    return AppColors.warning;
  }

  String _getExperienceLevelLabel(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.none:
        return 'Sem experiência';
      case ExperienceLevel.basic:
        return 'Básico';
      case ExperienceLevel.intermediate:
        return 'Intermediário';
    }
  }

  void _showFilterDialog() {
    // TODO: Implement filter dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtros em desenvolvimento')),
    );
  }

  List<JobModel> _getMockJobs() {
    return [
      JobModel(
        id: '1',
        companyId: 'comp1',
        companyName: 'Tech Solutions',
        title: 'Assistente Administrativo',
        description:
            'Buscamos profissional organizado para atuar com rotinas administrativas, gestão de documentos e atendimento interno.',
        category: JobCategory.administration,
        experienceLevel: ExperienceLevel.none,
        location: 'São Paulo, SP',
        isRemote: false,
        salaryRange: 'R\$ 1.500 - R\$ 2.000',
        requiredSkills: ['Organização', 'Comunicação', 'Excel Básico'],
        requiredTrails: ['functionalLiteracy', 'professionalWriting'],
        minimumLevel: 1,
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
        expiresAt: DateTime.now().add(const Duration(days: 28)),
      ),
      JobModel(
        id: '2',
        companyId: 'comp2',
        companyName: 'Varejo Premium',
        title: 'Vendedor',
        description:
            'Oportunidade para atuar com vendas em loja física. Oferecemos treinamento completo.',
        category: JobCategory.sales,
        experienceLevel: ExperienceLevel.none,
        location: 'Rio de Janeiro, RJ',
        isRemote: false,
        salaryRange: 'R\$ 1.800 + Comissões',
        requiredSkills: ['Comunicação', 'Proatividade', 'Vendas'],
        requiredTrails: ['assertiveCommunication', 'customerService'],
        minimumLevel: 1,
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
        expiresAt: DateTime.now().add(const Duration(days: 29)),
      ),
      JobModel(
        id: '3',
        companyId: 'comp3',
        companyName: 'Central de Atendimento',
        title: 'Atendente de SAC',
        description:
            'Vaga para atendimento ao cliente via telefone e chat. Horário flexível disponível.',
        category: JobCategory.customerService,
        experienceLevel: ExperienceLevel.basic,
        location: 'Remoto',
        isRemote: true,
        salaryRange: 'R\$ 1.600 - R\$ 2.200',
        requiredSkills: ['Atendimento', 'Comunicação', 'Empatia'],
        requiredTrails: ['customerService', 'conflictManagement'],
        minimumLevel: 2,
        postedAt: DateTime.now().subtract(const Duration(hours: 12)),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      ),
    ];
  }
}
