import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/pages/RT/rt_main_screen.dart';
import 'package:wargaqu/pages/RW/rw_main_screen.dart';
import 'package:wargaqu/pages/citizen/citizen_main_screen.dart';
import 'package:wargaqu/pages/citizen/waiting_approval/waiting_for_approval_screen.dart';
import 'package:wargaqu/pages/login_choice.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/user_providers.dart';
import 'package:wargaqu/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null);

  if (kDebugMode) {
    try {
      final String ipLaptop = "192.168.18.42";
      debugPrint("Menyambungkan ke Firebase Emulators...");
      await FirebaseAuth.instance.useAuthEmulator(ipLaptop, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(ipLaptop, 8080);
      await FirebaseStorage.instance.useStorageEmulator(ipLaptop, 9199);
      debugPrint("Berhasil tersambung ke Emulators.");
    } catch (e) {
      debugPrint("Gagal menyambung ke Emulators: $e");
    }
  }
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: child
        );
      },
      child: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Terjadi Error: $err')),
      ),
      data: (userModel) {
        if (userModel == null) {
          return const LoginChoiceScreen();
        }

        if (userModel.status == 'pending_confirmation') {
          return const WaitingForApprovalScreen();
        }

        if (userModel.status == 'ACTIVE') {
          if (userModel.role.contains('citizen')) {
            return const CitizenMainScreen();
          }
          if (userModel.role.contains('rt')) {
            return const RtMainScreen();
          }
          if (userModel.role.contains('rw')) {
            return const RwMainScreen();
          }
        }
        return const LoginChoiceScreen();
      },
    );
  }
}

class RoleBasedRedirect extends ConsumerWidget {
  const RoleBasedRedirect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userDocStreamProvider);

    return userProfileState.when(
      data: (snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          return const LoginChoiceScreen();
        }
        final userProfile = snapshot.data() as Map<String, dynamic>;
        final String status = userProfile['status'] ?? 'pending_confirmation';
        final String role = userProfile['role'] ?? '';
        debugPrint("Full name: ${userProfile['fullName']}");

        if (status == 'pending_confirmation') {
          return const WaitingForApprovalScreen();
        }

        if (status == 'ACTIVE') {
          if (role.contains('citizen')) {
            return const CitizenMainScreen();
          }
          if (role.contains('rt')) {
            return const RtMainScreen();
          }
          if (role.contains('rw')) {
            return const RwMainScreen();
          }
        }

        return const LoginChoiceScreen();
      },
      loading: () {
        return Scaffold(
          body: Column(
            children: [
              Center(child: CircularProgressIndicator()),
              Text('Loading...'),
            ],
          ),
        );
      },
      error: (err, stack) => Scaffold(body: Center(child: Text('Terjadi Error:\n$err', textAlign: TextAlign.center)))
    );
  }
}
