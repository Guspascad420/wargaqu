import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

class ReusableLoginUI extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String subtitle;
  final String loginButtonText;
  final VoidCallback onLoginPressed;
  final VoidCallback onForgotPasswordPressed;
  final VoidCallback onRegistrationOptionPressed;

  const ReusableLoginUI({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.subtitle,
    required this.onLoginPressed,
    required this.onForgotPasswordPressed,
    required this.onRegistrationOptionPressed,
    this.loginButtonText = 'Masuk',
  });

  @override
  ConsumerState<ReusableLoginUI> createState() => _ReusableLoginUIState();
}

class _ReusableLoginUIState extends ConsumerState<ReusableLoginUI> {
  bool _isPasswordVisible = false;
  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authNotifierProvider);

    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Image.asset('images/wargaqu.png', scale: 2.5)),
            const SizedBox(height: 30),
            Text('Selamat Datang', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),

            TextFormField(
              key: const Key('emailField'),
              controller: widget.emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email wajib diisi.';
                }
                if (!_emailRegExp.hasMatch(value)) {
                  return 'Format Email tidak valid.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              key: const Key('passwordField'),
              controller: widget.passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Kata Sandi',
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata Sandi wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onForgotPasswordPressed,
                child: Text(
                  'Lupa Kata Sandi?',
                  style: GoogleFonts.roboto(
                    color: AppColors.primary90,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              key: const Key('loginButton'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary400,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: widget.onLoginPressed,
              child: loginState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                widget.loginButtonText,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum punya akun? ',
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
                GestureDetector(
                  key: const Key('registrationOption'),
                  onTap: widget.onRegistrationOptionPressed,
                  child: Text(
                    'Daftar di sini',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary90,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}