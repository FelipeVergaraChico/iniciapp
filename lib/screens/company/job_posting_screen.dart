import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../models/company_model.dart';

class JobPostingScreen extends StatefulWidget {
  const JobPostingScreen({super.key});

  @override
  State<JobPostingScreen> createState() => _JobPostingScreenState();
}

class _JobPostingScreenState extends State<JobPostingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _vacanciesController = TextEditingController(text: '1');

  JobType _selectedType = JobType.fullTime;
  WorkMode _selectedWorkMode = WorkMode.hybrid;
  String? _selectedExperience;

  final List<String> _requirements = [];
  final List<String> _responsibilities = [];
  final List<String> _skills = [];
  final List<String> _benefits = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    _vacanciesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Vaga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Assistente IA',
            onPressed: _showAIAssistant,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAIBanner(),
            const SizedBox(height: 24),
            _buildBasicInfo(),
            const SizedBox(height: 24),
            _buildJobDetails(),
            const SizedBox(height: 24),
            _buildListSection(
              title: 'Requisitos',
              items: _requirements,
              onAdd: () => _addItem(context, 'Requisito', _requirements),
              icon: Icons.checklist,
            ),
            const SizedBox(height: 24),
            _buildListSection(
              title: 'Responsabilidades',
              items: _responsibilities,
              onAdd: () => _addItem(context, 'Responsabilidade', _responsibilities),
              icon: Icons.task_alt,
            ),
            const SizedBox(height: 24),
            _buildListSection(
              title: 'Competências Desejadas',
              items: _skills,
              onAdd: () => _addItem(context, 'Competência', _skills),
              icon: Icons.emoji_events,
            ),
            const SizedBox(height: 24),
            _buildListSection(
              title: 'Benefícios',
              items: _benefits,
              onAdd: () => _addItem(context, 'Benefício', _benefits),
              icon: Icons.card_giftcard,
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAIBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.purple[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Assistente IA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Gere descrições profissionais automaticamente',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _showAIAssistant,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple[600],
            ),
            child: const Text('Usar IA'),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações Básicas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título da Vaga',
                prefixIcon: const Icon(Icons.work_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o título da vaga';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a descrição da vaga';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Localização',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a localização';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _vacanciesController,
                    decoration: InputDecoration(
                      labelText: 'Nº de Vagas',
                      prefixIcon: const Icon(Icons.groups_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o número';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _salaryController,
              decoration: InputDecoration(
                labelText: 'Faixa Salarial (opcional)',
                prefixIcon: const Icon(Icons.attach_money),
                hintText: 'Ex: R\$ 2.000 - R\$ 3.500',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalhes da Vaga',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<JobType>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: 'Tipo de Contratação',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: JobType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<WorkMode>(
              initialValue: _selectedWorkMode,
              decoration: InputDecoration(
                labelText: 'Modelo de Trabalho',
                prefixIcon: const Icon(Icons.computer_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: WorkMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWorkMode = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedExperience,
              decoration: InputDecoration(
                labelText: 'Nível de Experiência',
                prefixIcon: const Icon(Icons.school_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Júnior', child: Text('Júnior')),
                DropdownMenuItem(value: 'Pleno', child: Text('Pleno')),
                DropdownMenuItem(value: 'Sênior', child: Text('Sênior')),
                DropdownMenuItem(value: 'Estágio', child: Text('Estágio')),
                DropdownMenuItem(value: 'Aprendiz', child: Text('Jovem Aprendiz')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedExperience = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection({
    required String title,
    required List<String> items,
    required VoidCallback onAdd,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'Nenhum item adicionado',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _handleSubmit,
        icon: const Icon(Icons.publish),
        label: const Text(
          'Publicar Vaga',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _addItem(BuildContext context, String label, List<String> list) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          maxLines: 2,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  list.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _showAIAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _buildAIAssistantContent(scrollController);
        },
      ),
    );
  }

  Widget _buildAIAssistantContent(ScrollController scrollController) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, color: Colors.purple[600], size: 28),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assistente IA',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Gere conteúdo profissional automaticamente',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                _buildAIOption(
                  title: 'Gerar Descrição Completa',
                  subtitle: 'Cria uma descrição profissional baseada no título',
                  icon: Icons.description,
                  onTap: () => _generateWithAI('description'),
                ),
                const SizedBox(height: 12),
                _buildAIOption(
                  title: 'Sugerir Requisitos',
                  subtitle: 'Lista requisitos comuns para esta vaga',
                  icon: Icons.checklist,
                  onTap: () => _generateWithAI('requirements'),
                ),
                const SizedBox(height: 12),
                _buildAIOption(
                  title: 'Sugerir Responsabilidades',
                  subtitle: 'Define responsabilidades típicas do cargo',
                  icon: Icons.task_alt,
                  onTap: () => _generateWithAI('responsibilities'),
                ),
                const SizedBox(height: 12),
                _buildAIOption(
                  title: 'Sugerir Competências',
                  subtitle: 'Identifica skills relevantes para a vaga',
                  icon: Icons.emoji_events,
                  onTap: () => _generateWithAI('skills'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple[50],
          child: Icon(icon, color: Colors.purple[600]),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _generateWithAI(String type) async {
    Navigator.pop(context); // Fecha o modal

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o título da vaga primeiro'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Simula processamento

    // Simula geração com IA
    await Future.delayed(const Duration(seconds: 2));

    setState(() {

      switch (type) {
        case 'description':
          _descriptionController.text =
              'Estamos em busca de um profissional qualificado para a posição de ${_titleController.text}. '
              'O candidato ideal deve possuir excelentes habilidades de comunicação, '
              'capacidade de trabalhar em equipe e forte comprometimento com resultados. '
              'Oferecemos um ambiente dinâmico e oportunidades de crescimento profissional.';
          break;

        case 'requirements':
          _requirements.clear();
          _requirements.addAll([
            'Ensino médio completo',
            'Experiência prévia na área (desejável)',
            'Conhecimento em ferramentas digitais',
            'Boa comunicação verbal e escrita',
            'Capacidade de trabalhar em equipe',
          ]);
          break;

        case 'responsibilities':
          _responsibilities.clear();
          _responsibilities.addAll([
            'Executar atividades relacionadas à função',
            'Manter organização e qualidade no trabalho',
            'Seguir procedimentos e protocolos estabelecidos',
            'Comunicar-se efetivamente com a equipe',
            'Contribuir para melhorias nos processos',
          ]);
          break;

        case 'skills':
          _skills.clear();
          _skills.addAll([
            'Comunicação',
            'Trabalho em equipe',
            'Organização',
            'Proatividade',
            'Resolução de problemas',
          ]);
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conteúdo gerado com sucesso!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_requirements.isEmpty || _responsibilities.isEmpty || _skills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adicione requisitos, responsabilidades e competências'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final _ = JobPostingModel(
        id: const Uuid().v4(),
        companyId: 'demo_company',
        title: _titleController.text,
        description: _descriptionController.text,
        type: _selectedType,
        workMode: _selectedWorkMode,
        location: _locationController.text,
        salaryRange: _salaryController.text.isEmpty ? null : _salaryController.text,
        requirements: _requirements,
        responsibilities: _responsibilities,
        benefits: _benefits,
        skills: _skills,
        experienceLevel: _selectedExperience,
        postedAt: DateTime.now(),
        vacancies: int.parse(_vacanciesController.text),
      );

      // TODO: Salvar vaga no backend/provider

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vaga publicada com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    }
  }
}
