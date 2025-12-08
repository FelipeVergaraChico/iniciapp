import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../models/company_model.dart';
import '../../models/professional_profile_model.dart';

class CandidateMatchAnalysisScreen extends StatefulWidget {
  final CandidateProfile candidate;
  final JobPostingModel job;

  const CandidateMatchAnalysisScreen({
    super.key,
    required this.candidate,
    required this.job,
  });

  @override
  State<CandidateMatchAnalysisScreen> createState() =>
      _CandidateMatchAnalysisScreenState();
}

class _CandidateMatchAnalysisScreenState
    extends State<CandidateMatchAnalysisScreen> {
  late CandidateMatchResult _matchResult;
  bool _isCalculating = true;

  @override
  void initState() {
    super.initState();
    _calculateMatch();
  }

  Future<void> _calculateMatch() async {
    // Simula cálculo com IA
    await Future.delayed(const Duration(seconds: 2));

    // Calcula match entre skills do candidato e da vaga
    final jobSkills = widget.job.skills;
    final candidateSkills = widget.candidate.topSkills.keys.toList();

    final matchedSkills = candidateSkills
        .where((skill) => jobSkills.any((js) => 
            js.toLowerCase().contains(skill.toLowerCase()) ||
            skill.toLowerCase().contains(js.toLowerCase())))
        .toList();

    final missingSkills = jobSkills
        .where((skill) => !matchedSkills.any((ms) =>
            ms.toLowerCase().contains(skill.toLowerCase())))
        .toList();

    // Calcula scores por skill
    final skillScores = <String, double>{};
    for (final skill in matchedSkills) {
      skillScores[skill] = widget.candidate.topSkills[skill] ?? 0.0;
    }

    // Score geral baseado em múltiplos fatores
    double overallScore = 0;
    
    // 40% baseado em skills matching
    final skillMatchPercent = matchedSkills.length / jobSkills.length;
    overallScore += skillMatchPercent * 40;

    // 30% baseado na qualidade das skills (scores)
    if (skillScores.isNotEmpty) {
      final avgSkillScore = skillScores.values.reduce((a, b) => a + b) / skillScores.length;
      overallScore += (avgSkillScore / 100) * 30;
    }

    // 20% baseado em XP e trilhas completadas
    final xpScore = (widget.candidate.totalXP / 1000).clamp(0, 1);
    overallScore += xpScore * 20;

    // 10% baseado na área sugerida
    if (widget.candidate.suggestedArea.toLowerCase() == 
        widget.job.title.toLowerCase().split(' ').first.toLowerCase()) {
      overallScore += 10;
    }

    final reasoning = _generateReasoning(
      overallScore,
      matchedSkills,
      missingSkills,
      skillMatchPercent,
    );

    setState(() {
      _matchResult = CandidateMatchResult(
        candidateId: widget.candidate.userId,
        candidateName: widget.candidate.name,
        overallScore: overallScore.clamp(0, 100),
        skillScores: skillScores,
        matchedSkills: matchedSkills,
        missingSkills: missingSkills,
        suggestedArea: widget.candidate.suggestedArea,
        totalXP: widget.candidate.totalXP,
        completedTrails: widget.candidate.completedTrails,
        reasoning: reasoning,
      );
      _isCalculating = false;
    });
  }

  String _generateReasoning(
    double score,
    List<String> matched,
    List<String> missing,
    double matchPercent,
  ) {
    if (score >= 80) {
      return 'Candidato EXCELENTE para a vaga! Possui ${matched.length} das competências desejadas '
          '(${(matchPercent * 100).toInt()}% de match) com alto nível de proficiência. '
          'Demonstra experiência relevante através das trilhas completadas e XP acumulado. '
          'Recomendamos fortemente o contato para entrevista.';
    } else if (score >= 60) {
      return 'Candidato BOM para a vaga. Atende a maioria dos requisitos com ${matched.length} competências '
          'alinhadas. Pode precisar de treinamento em: ${missing.take(2).join(", ")}. '
          'O perfil mostra potencial de desenvolvimento e engajamento no aprendizado.';
    } else if (score >= 40) {
      return 'Candidato com potencial MODERADO. Possui algumas competências relevantes mas '
          'necessita desenvolvimento em áreas-chave como: ${missing.take(3).join(", ")}. '
          'Considere para vagas de nível júnior ou com programa de capacitação.';
    } else {
      return 'Compatibilidade BAIXA com a vaga atual. O candidato ainda está em desenvolvimento '
          'e não atende aos requisitos mínimos. Recomendamos acompanhar o progresso futuro '
          'ou considerar para outras posições mais adequadas ao perfil.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCalculating) {
      return Scaffold(
        appBar: AppBar(title: const Text('Analisando Compatibilidade')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Analisando perfil do candidato...',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Usando IA para calcular compatibilidade',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Compatibilidade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Compartilhar análise
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildOverallScoreCard(),
          const SizedBox(height: 16),
          _buildSkillsRadarChart(),
          const SizedBox(height: 16),
          _buildSkillsMatchCard(),
          const SizedBox(height: 16),
          _buildExperienceCard(),
          const SizedBox(height: 16),
          _buildReasoningCard(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    widget.candidate.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.candidate.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Área sugerida: ${widget.candidate.suggestedArea}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              'Vaga: ${widget.job.title}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.job.type.label} • ${widget.job.workMode.label}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard() {
    final score = _matchResult.overallScore;
    final color = _getScoreColor(score);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Compatibilidade Geral',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${score.toInt()}%',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        _getScoreLabel(score),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsRadarChart() {
    if (_matchResult.skillScores.isEmpty) {
      return const SizedBox.shrink();
    }

    final skills = _matchResult.skillScores.keys.take(5).toList();
    final scores = skills.map((s) => _matchResult.skillScores[s]!).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Radar de Competências',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,
                  tickCount: 5,
                  ticksTextStyle: const TextStyle(fontSize: 10, color: Colors.transparent),
                  radarBorderData: BorderSide(color: Colors.grey[300]!),
                  gridBorderData: BorderSide(color: Colors.grey[200]!, width: 1),
                  tickBorderData: BorderSide(color: Colors.grey[300]!),
                  getTitle: (index, angle) {
                    return RadarChartTitle(
                      text: skills[index],
                      angle: 0,
                    );
                  },
                  dataSets: [
                    RadarDataSet(
                      fillColor: AppColors.primary.withValues(alpha: 0.2),
                      borderColor: AppColors.primary,
                      dataEntries: scores.map((s) => RadarEntry(value: s)).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsMatchCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Análise de Competências',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSkillsSection(
              'Competências Alinhadas',
              _matchResult.matchedSkills,
              AppColors.success,
              Icons.check_circle,
            ),
            if (_matchResult.missingSkills.isNotEmpty) ...[
              const Divider(height: 24),
              _buildSkillsSection(
                'Áreas para Desenvolvimento',
                _matchResult.missingSkills,
                Colors.orange,
                Icons.school,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(
    String title,
    List<String> skills,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${skills.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) {
            final score = _matchResult.skillScores[skill];
            return Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(skill),
                  if (score != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      '${score.toInt()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
              backgroundColor: color.withValues(alpha: 0.1),
              labelStyle: TextStyle(color: color),
              side: BorderSide(color: color),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExperienceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Experiência e Progresso',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'XP Total',
                    '${_matchResult.totalXP}',
                    Icons.star,
                    AppColors.secondary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Trilhas',
                    '${_matchResult.completedTrails}',
                    Icons.school,
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Área',
                    _matchResult.suggestedArea,
                    Icons.work,
                    AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReasoningCard() {
    final score = _matchResult.overallScore;
    final color = _getScoreColor(score);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3), width: 2),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.psychology, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Análise Inteligente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        'Gerado por IA baseado em múltiplos fatores',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.auto_awesome, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                _matchResult.reasoning,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              _sendProposal();
            },
            icon: const Icon(Icons.send),
            label: const Text('Enviar Proposta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'EXCELENTE';
    if (score >= 60) return 'BOM';
    if (score >= 40) return 'MODERADO';
    return 'BAIXO';
  }

  void _sendProposal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enviar Proposta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deseja enviar uma proposta para ${widget.candidate.name}?'),
            const SizedBox(height: 16),
            Text(
              'Vaga: ${widget.job.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Match: ${_matchResult.overallScore.toInt()}%',
              style: TextStyle(
                color: _getScoreColor(_matchResult.overallScore),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Proposta enviada para ${widget.candidate.name}!'),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pop(context); // Volta para a lista
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
