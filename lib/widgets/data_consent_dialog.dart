import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/professional_profile_provider.dart';
import '../../core/theme/app_colors.dart';

class DataConsentDialog extends StatefulWidget {
  const DataConsentDialog({super.key});

  @override
  State<DataConsentDialog> createState() => _DataConsentDialogState();
}

class _DataConsentDialogState extends State<DataConsentDialog> {
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.security, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Compartilhar seus dados?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conecte-se com empresas!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ao aceitar, você permite que empresas parceiras visualizem:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildPermissionItem(
              Icons.school,
              'Seu desempenho nas trilhas',
            ),
            _buildPermissionItem(
              Icons.star,
              'Suas habilidades e áreas de destaque',
            ),
            _buildPermissionItem(
              Icons.work,
              'Sugestão de área profissional',
            ),
            _buildPermissionItem(
              Icons.person,
              'Nome, idade e nível',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_user, 
                        color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Seus dados estão seguros',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Seus dados pessoais são protegidos\n'
                    '• Apenas empresas verificadas têm acesso\n'
                    '• Você pode revogar a qualquer momento\n'
                    '• Conforme LGPD (Lei 13.709/2018)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _acceptedTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptedTerms = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'Li e aceito compartilhar meus dados',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final provider = context.read<ProfessionalProfileProvider>();
            provider.updateDataSharing(false);
            provider.markConsentDialogShown();
            Navigator.of(context).pop();
          },
          child: const Text('Agora não'),
        ),
        ElevatedButton.icon(
          onPressed: _acceptedTerms
              ? () {
                  final provider = context.read<ProfessionalProfileProvider>();
                  provider.updateDataSharing(true);
                  provider.markConsentDialogShown();
                  Navigator.of(context).pop();
                  
                  // Mostra feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Dados compartilhados! Empresas podem te encontrar.',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.check),
          label: const Text('Aceitar e continuar'),
        ),
      ],
    );
  }

  Widget _buildPermissionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper para mostrar o dialog
Future<void> showDataConsentDialogIfNeeded(BuildContext context) async {
  final provider = context.read<ProfessionalProfileProvider>();
  
  if (!provider.hasShownConsentDialog) {
    // Aguarda um frame para garantir que o context está pronto
    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DataConsentDialog(),
      );
    }
  }
}
