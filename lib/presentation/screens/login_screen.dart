import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/utils/validators.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/widgets/custom_textfield.dart';
import '../../presentation/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'admin@lab.com');
  final _passwordCtrl = TextEditingController(text: 'admin123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // ✅ بعد login نمشي dashboard
    if (authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/dashboard');
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, Color(0xFF1D4ED8)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.science_rounded,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Bienvenue',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Connectez-vous a votre compte',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomTextField(
                          controller: _emailCtrl,
                          label: AppStrings.email,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email requis';
                            if (!v.contains('@')) return 'Email invalide';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordCtrl,
                          label: AppStrings.password,
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Mot de passe requis';
                            if (v.length < 6) return 'Min 6 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Mot de passe oublie?'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: AppStrings.login,
                          isLoading: authState.isLoading,
                          onPressed: _login,
                        ),
                        const SizedBox(height: 24),
                        if (authState.error != null)
                          Text(
                            authState.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
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
}