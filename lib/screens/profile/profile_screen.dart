import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/professional_profile_provider.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final userProvider = context.read<UserProvider>();
    final user = userProvider.currentUser;
    if (user == null) return;

    final newName = _nameController.text.trim();
    if (newName == user.name) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nada para atualizar.')),
      );
      return;
    }

    userProvider.updateUser(user.copyWith(name: newName));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nome atualizado com sucesso.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final profile = context.watch<ProfessionalProfileProvider>().profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Salvar',
            onPressed: _save,
          )
        ],
      ),
      body: user == null
          ? const Center(child: Text('Nenhum usuário carregado.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            (user.name.isNotEmpty
                                    ? user.name.substring(0, 1).toUpperCase()
                                    : 'U'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.email,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Nível ${user.level} • ${user.totalPoints} XP',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Card de área profissional sugerida
                    if (profile != null && profile.suggestedArea != 'Não avaliado')
                      Card(
                        color: AppColors.primaryLight,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.work, color: Colors.white),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Área Sugerida',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                profile.suggestedArea,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (profile.topSkill != 'Não avaliado') ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Habilidade principal: ${profile.topSkill}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    profile.dataShared
                                        ? Icons.check_circle
                                        : Icons.lock,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    profile.dataShared
                                        ? 'Visível para empresas'
                                        : 'Dados privados',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    Text('Informações',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        hintText: 'Digite seu nome',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Informe um nome válido';
                        if (v.length < 2) return 'O nome deve ter ao menos 2 caracteres';
                        return null;
                      },
                      onFieldSubmitted: (_) => _save(),
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar alterações'),
                        onPressed: _save,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
