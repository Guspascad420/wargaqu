import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/pages/RT/rt_main_screen.dart';
import 'package:wargaqu/pages/RW/rw_main_screen.dart';
import 'package:wargaqu/pages/citizen/citizen_main_screen.dart';
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
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginChoiceScreen();
        } else {
          return RoleBasedRedirect(userId: user.uid);
        }
      },
      loading: () => const Scaffold(),
      // Kalo ada error
      error: (err, stack) => Scaffold(body: Center(child: Text('Terjadi Error:\n$err', textAlign: TextAlign.center)))
    );
  }
}

class RoleBasedRedirect extends ConsumerWidget {
  final String userId;
  const RoleBasedRedirect({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userDocStreamProvider);

    return userProfileState.when(
      data: (snapshot) {
        final userProfile = snapshot.data() as Map<String, dynamic>;

        switch (userProfile['role']) {
          case 'citizen':
            return const CitizenMainScreen();
          case 'ketua_rt':
          case 'bendahara_rt':
            return const RtMainScreen();
          case 'rw_official':
          case 'bendahara_rw':
            return const RwMainScreen();
          default:
            return const LoginChoiceScreen();
        }
      },
      loading: () => const Scaffold(),
      error: (err, stack) => Scaffold(body: Center(child: Text('Terjadi Error:\n$err', textAlign: TextAlign.center)))
    );
  }
}
