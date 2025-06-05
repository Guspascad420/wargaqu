import 'package:flutter/material.dart';
import 'package:wargaqu/components/reusable_login_ui.dart';
import 'package:wargaqu/pages/RT/rt_main_screen.dart';
import 'package:wargaqu/pages/auth/RT/rt_registration_form.dart';

class RtLoginForm extends StatefulWidget {
  const RtLoginForm({super.key});

  @override
  State<RtLoginForm> createState() => _RtLoginFormState();
}

class _RtLoginFormState extends State<RtLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const RtMainScreen())
                );
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