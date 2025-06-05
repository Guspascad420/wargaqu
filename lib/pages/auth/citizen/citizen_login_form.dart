import 'package:flutter/material.dart';
import 'package:wargaqu/components/reusable_login_ui.dart';
import 'package:wargaqu/pages/auth/citizen/citizen_registration_form.dart';
import 'package:wargaqu/pages/citizen/citizen_main_screen.dart';

class CitizenLoginForm extends StatefulWidget {
  const CitizenLoginForm({super.key});

  @override
  State<CitizenLoginForm> createState() => _CitizenLoginFormState();
}

class _CitizenLoginFormState extends State<CitizenLoginForm> {
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
            subtitle: 'Halo Warga! Masuk ke akun Anda untuk dapat menggunakan layanan kami',
            onLoginPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => CitizenMainScreen()),
                    (Route<dynamic> route) => false,
              );
            },
            onForgotPasswordPressed: () {},
            onRegistrationOptionPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const CitizenRegistrationForm())
              );
            })
      ),
    );
  }

}