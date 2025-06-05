import 'package:flutter/material.dart';
import 'package:wargaqu/components/reusable_login_ui.dart';
import 'package:wargaqu/pages/RW/rw_registration_form.dart';

class RwLoginForm extends StatefulWidget {
  const RwLoginForm({super.key});

  @override
  State<RwLoginForm> createState() => _RwLoginFormState();
}

class _RwLoginFormState extends State<RwLoginForm> {
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
          child: SingleChildScrollView(
            child: ReusableLoginUI(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                subtitle: 'Halo RW! Masuk ke akun Anda untuk dapat menggunakan layanan kami',
                onLoginPressed: () {}, onForgotPasswordPressed: () {},
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