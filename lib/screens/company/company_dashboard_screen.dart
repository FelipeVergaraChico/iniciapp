import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/professional_profile_model.dart';
import '../../models/company_model.dart';
import 'job_posting_screen.dart';
import 'candidate_match_analysis_screen.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  String _selectedArea = 'Todos';
  String _sortBy = 'matchScore'; // matchScore, totalXP, completedTrails

  @override
  Widget build(BuildContext context) {
    // Mock de candidatos (em produção, viria de um provider/API)
    final candidates = _getMockCandidates();
    
    // Filtra por área
    var filteredCandidates = _selectedArea == 'Todos'
        ? candidates
        : candidates.where((c) => c.suggestedArea == _selectedArea).toList();
    
    // Ordena
    filteredCandidates.sort((a, b) {
      switch (_sortBy) {
        case 'totalXP':
          return b.totalXP.compareTo(a.totalXP);
        case 'completedTrails':
          return b.completedTrails.compareTo(a.completedTrails);
        default:
          return b.matchScore.compareTo(a.matchScore);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Empresarial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nova Vaga',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobPostingScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStats(candidates),
          _buildFilters(),
          Expanded(
            child: filteredCandidates.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCandidates.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildCompatibilityBanner();
                      }
                      return _buildCandidateCard(filteredCandidates[index - 1]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(List<CandidateProfile> candidates) {
    final byArea = <String, int>{};
    for (var c in candidates) {
      byArea[c.suggestedArea] = (byArea[c.suggestedArea] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primaryLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${candidates.length} candidatos disponíveis',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: byArea.entries.map((entry) {
              return Chip(
                label: Text('${entry.key}: ${entry.value}'),
                backgroundColor: Colors.white,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _selectedArea,
              decoration: const InputDecoration(
                labelText: 'Área',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: ['Todos', 'Tecnologia', 'Logística', 'Atendimento', 'Administrativo', 'Operações']
                  .map((area) => DropdownMenuItem(value: area, child: Text(area)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedArea = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _sortBy,
              decoration: const InputDecoration(
                labelText: 'Ordenar por',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'matchScore', child: Text('Match')),
                DropdownMenuItem(value: 'totalXP', child: Text('XP')),
                DropdownMenuItem(value: 'completedTrails', child: Text('Trilhas')),
              ],
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Análise de Compatibilidade com IA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Descubra a compatibilidade dos candidatos com suas vagas através de gráficos detalhados',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(CandidateProfile candidate) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showCandidateDetails(candidate),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      candidate.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          candidate.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${candidate.age} anos • ${candidate.suggestedArea}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getMatchColor(candidate.matchScore),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${candidate.matchScore.toStringAsFixed(0)}% Match',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatChip(Icons.school, '${candidate.completedTrails} trilhas'),
                  const SizedBox(width: 8),
                  _buildStatChip(Icons.star, '${candidate.totalXP} XP'),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    Icons.access_time,
                    _formatLastActive(candidate.lastActive),
                  ),
                ],
              ),
              if (candidate.topSkills.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'Principais habilidades:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: candidate.topSkills.entries.take(3).map((entry) {
                    return Chip(
                      label: Text(
                        '${entry.key} (${entry.value.toStringAsFixed(0)})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: AppColors.primaryLight,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _analyzeCompatibility(candidate),
                  icon: const Icon(Icons.analytics_outlined, size: 18),
                  label: const Text('Descobrir Compatibilidade com a Vaga'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Nenhum candidato encontrado',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMatchColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.secondary;
    return Colors.orange;
  }

  String _formatLastActive(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Hoje';
    if (diff.inDays == 1) return 'Ontem';
    if (diff.inDays < 7) return '${diff.inDays}d atrás';
    return '${(diff.inDays / 7).floor()}sem atrás';
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros Avançados'),
        content: const Text('Filtros adicionais em breve!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showCandidateDetails(CandidateProfile candidate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      candidate.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          candidate.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${candidate.age} anos',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailSection(
                'Área Sugerida',
                candidate.suggestedArea,
                Icons.work,
              ),
              const SizedBox(height: 16),
              _buildDetailSection(
                'Match Score',
                '${candidate.matchScore.toStringAsFixed(0)}%',
                Icons.star,
              ),
              const SizedBox(height: 16),
              const Text(
                'Todas as Habilidades',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...candidate.topSkills.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(child: Text(entry.key)),
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: entry.value / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            _getMatchColor(entry.value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(entry.value.toStringAsFixed(0)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Fechar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _analyzeCompatibility(candidate);
                      },
                      icon: const Icon(Icons.analytics),
                      label: const Text('Analisar Compatibilidade'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
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

  Widget _buildDetailSection(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _analyzeCompatibility(CandidateProfile candidate) {
    // Mock de vaga para análise
    final mockJob = JobPostingModel(
      id: '1',
      companyId: 'demo_company',
      title: 'Assistente de ${candidate.suggestedArea}',
      description: 'Vaga para atuar na área de ${candidate.suggestedArea}',
      type: JobType.fullTime,
      workMode: WorkMode.hybrid,
      location: 'São Paulo, SP',
      requirements: ['Ensino médio completo', 'Experiência prévia'],
      responsibilities: ['Executar atividades da área', 'Trabalhar em equipe'],
      benefits: ['Vale transporte', 'Vale refeição'],
      skills: candidate.topSkills.keys.toList(),
      postedAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CandidateMatchAnalysisScreen(
          candidate: candidate,
          job: mockJob,
        ),
      ),
    );
  }

  List<CandidateProfile> _getMockCandidates() {
    // Mock data - em produção viria de um provider/API
    return [
      CandidateProfile(
        userId: '1',
        name: 'Ana Silva',
        age: 22,
        suggestedArea: 'Tecnologia',
        matchScore: 87,
        topSkills: {
          'Ferramentas Digitais': 92,
          'Adaptabilidade Tecnológica': 88,
          'Pensamento Crítico': 82,
        },
        completedTrails: 3,
        totalXP: 450,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CandidateProfile(
        userId: '2',
        name: 'Carlos Santos',
        age: 28,
        suggestedArea: 'Logística',
        matchScore: 79,
        topSkills: {
          'Raciocínio Lógico': 85,
          'Cálculos Básicos': 80,
          'Organização': 75,
        },
        completedTrails: 2,
        totalXP: 320,
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CandidateProfile(
        userId: '3',
        name: 'Maria Oliveira',
        age: 25,
        suggestedArea: 'Atendimento',
        matchScore: 92,
        topSkills: {
          'Comunicação Verbal': 95,
          'Empatia': 90,
          'Leitura e Interpretação': 88,
        },
        completedTrails: 4,
        totalXP: 580,
        lastActive: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}
