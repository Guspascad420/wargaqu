import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/components/reusable_login_ui.dart';
import 'package:wargaqu/pages/RT/rt_main_screen.dart';
import 'package:wargaqu/pages/auth/RT/rt_registration_form.dart';
import 'package:wargaqu/providers/providers.dart';

class RtLoginForm extends ConsumerStatefulWidget {
  const RtLoginForm({super.key});

  @override
  ConsumerState<RtLoginForm> createState() => _RtLoginFormState();
}

class _RtLoginFormState extends ConsumerState<RtLoginForm> {
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
    ref.listen<AsyncValue<void>>(loginNotifierProvider, (prev, next) {
      if (!_didSubmit) return;

      if (prev is AsyncLoading && !next.isLoading) {
        if (next.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${next.error}')),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RtMainScreen()),
          );
          setState(() {
            _didSubmit = false;
          });
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: ReusableLoginUI(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              subtitle: 'Halo RT! Masuk ke akun Anda untuk dapat menggunakan layanan kami',
              onLoginPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _didSubmit = true;
                  });
                  ref.read(loginNotifierProvider.notifier).loginUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                }
              }, onForgotPasswordPressed: () {},
              onRegistrationOptionPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const RtRegistrationForm())
                );
              }
          )
      ),
    );
  }

}