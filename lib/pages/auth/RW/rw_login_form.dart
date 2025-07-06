import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/components/reusable_login_ui.dart';
import 'package:wargaqu/pages/auth/RW/rw_registration_form.dart';
import 'package:wargaqu/providers/providers.dart';

class RwLoginForm extends ConsumerStatefulWidget {
  const RwLoginForm({super.key});

  @override
  ConsumerState<RwLoginForm> createState() => _RwLoginFormState();
}

class _RwLoginFormState extends ConsumerState<RwLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _didSubmit = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authNotifierProvider, (prev, next) {
      if (prev is AsyncLoading && !next.isLoading) {
        if (next.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${next.error}')),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: ReusableLoginUI(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                subtitle: 'Halo RW! Masuk ke akun Anda untuk dapat menggunakan layanan kami',
                onLoginPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref.read(authNotifierProvider.notifier).loginUser(
                        email: _emailController.text,
                        password: _passwordController.text,
                    );
                  }
                }, onForgotPasswordPressed: () {},
                onRegistrationOptionPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const RwRegistrationForm())
                  );
                }
            )
          )
      ),
    );
  }

}