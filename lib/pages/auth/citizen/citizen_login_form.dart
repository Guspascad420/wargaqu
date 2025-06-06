import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/components/reusable_login_ui.dart';
import 'package:wargaqu/model/auth/auth_state.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/pages/auth/citizen/citizen_registration_form.dart';
import 'package:wargaqu/pages/citizen/citizen_main_screen.dart';
import 'package:wargaqu/services/auth_service.dart';
import 'package:wargaqu/services/user_db_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(fb_auth.FirebaseAuth.instance);
});
final userDbServiceProvider = Provider<UserDbService>((ref) {
  return UserDbService(FirebaseFirestore.instance);
});

class LoginNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return const AuthState();
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String nik,
    required String fullName,
    String? phoneNumber,
    required String address,
    String? currentOccupation,
    String? residencyStatus,
    required String rwId,
    required String rtId
  }) async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final firebaseUser = await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseUser == null) {
        throw Exception('Gagal login');
      }

      state = AsyncValue.data(const AuthState(status: AuthStateStatus.success));
      debugPrint('Login berhasil untuk: $email');

    } catch (e) {
      debugPrint('Error di LoginNotifier: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

class CitizenLoginForm extends ConsumerStatefulWidget {
  const CitizenLoginForm({super.key});

  @override
  ConsumerState<CitizenLoginForm> createState() => _CitizenLoginFormState();
}

class _CitizenLoginFormState extends ConsumerState<CitizenLoginForm> {
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