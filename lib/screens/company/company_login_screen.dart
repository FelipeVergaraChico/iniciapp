import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class CompanyLoginScreen extends StatefulWidget {
  const CompanyLoginScreen({super.key});

  @override
  State<CompanyLoginScreen> createState() => _CompanyLoginScreenState();
}

class _CompanyLoginScreenState extends State<CompanyLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;

  // Campos de cadastro
  final _companyNameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _companyNameController.dispose();
    _cnpjController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildForm(),
                        const SizedBox(height: 24),
                        _buildSubmitButton(),
                        const SizedBox(height: 16),
                        _buildToggleMode(),
                        const SizedBox(height: 24),
                        _buildBackButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.business,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _isLogin ? 'Portal Empresarial' : 'Cadastro Empresarial',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin
              ? 'Acesse sua conta para gerenciar vagas'
              : 'Crie sua conta e encontre talentos',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!_isLogin) ...[
            TextFormField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: 'Nome da Empresa',
                prefixIcon: const Icon(Icons.business_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o nome da empresa';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cnpjController,
              decoration: InputDecoration(
                labelText: 'CNPJ',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o CNPJ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Telefone',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o telefone';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'E-mail',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o e-mail';
              }
              if (!value.contains('@')) {
                return 'E-mail inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a senha';
              }
              if (value.length < 6) {
                return 'Senha deve ter no mínimo 6 caracteres';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _isLogin ? 'Entrar' : 'Cadastrar',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleMode() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: Text(
        _isLogin
            ? 'Não tem conta? Cadastre sua empresa'
            : 'Já tem conta? Faça login',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
      label: const Text('Voltar para o app'),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[600],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Cria usuário empresa
      final companyUser = UserModel(
        id: 'company_001',
        name: _isLogin 
            ? (_companyNameController.text.isEmpty ? 'Magazine Luiza' : _companyNameController.text)
            : _companyNameController.text,
        email: _emailController.text,
        age: 0, // Empresas não têm idade
        userType: UserType.company,
        createdAt: DateTime.now(),
        lastAccessAt: DateTime.now(),
      );

      // Atualiza o provider com usuário empresa
      context.read<UserProvider>().setUser(companyUser);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLogin
                ? 'Bem-vinda, ${companyUser.name}!'
                : 'Cadastro realizado com sucesso!',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      // Navega de volta para a tela principal (que agora mostrará conteúdo empresarial)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
