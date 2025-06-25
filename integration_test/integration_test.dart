import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wargaqu/pages/RW/rw_main_screen.dart';
import 'package:wargaqu/pages/auth/RW/rw_registration_form.dart';
import 'package:wargaqu/theme/app_theme.dart';
import 'package:wargaqu/pages/RW/rt_management/new_rt_form_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Path Provider Integration Test', () {
    testWidgets('Mendapatkan application support directory yang valid', (WidgetTester tester) async {
      final Directory appSupportDir = await getApplicationSupportDirectory();

      expect(appSupportDir, isNotNull);
      expect(await appSupportDir.exists(), isTrue);
      expect(appSupportDir.path, anyOf(contains('data'), contains('Library'), contains('Roaming')));
    });
  });

  group('RW registration test', () {
    testWidgets('User bisa sign up dengan kredensial yang valid', (WidgetTester tester) async {
      await tester.pumpWidget(
          ProviderScope(
            child: ScreenUtilInit(
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
              child: const RwRegistrationForm(),
            ),
          )
      );

      final Finder emailField = find.byKey(const Key('emailField'));
      final Finder passwordField = find.byKey(const Key('passwordField'));
      final Finder addressField = find.byKey(const Key('addressField'));
      final Finder phoneNumberField = find.byKey(const Key('phoneNumberField'));
      final Finder fullNameField = find.byKey(const Key('fullNameField'));
      final Finder rwUniqueCodeField = find.byKey(const Key('rwUniqueCodeField'));
      final Finder submitButton = find.byKey(const Key('submitButton'));

      await tester.enterText(emailField, 'budisantoso@gmail.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(addressField, 'Jl. Raya Jakarta');
      await tester.enterText(phoneNumberField, '08123456789');
      await tester.enterText(fullNameField, 'Budi Santoso');
      await tester.enterText(rwUniqueCodeField, 'RW05MAKMUR2025');
      await tester.tap(submitButton);

      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byType(RwMainScreen), findsOneWidget);
      expect(find.byType(RwRegistrationForm), findsNothing);
    });
  });

  group('Add new RT test', () {
    testWidgets('User bisa menambahkan RT baru', (WidgetTester tester) async {
      await tester.pumpWidget(
          ProviderScope(
            child: ScreenUtilInit(
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
              child: const NewRtFormScreen(),
            ),
          )
      );
      final Finder rtNumberField = find.byKey(const Key('rtNumberField'));
      final Finder rtNameField = find.byKey(const Key('rtNameField'));
      final Finder addressField = find.byKey(const Key('addressField'));
      final Finder submitButton = find.byKey(const Key('submitButton'));

      await tester.enterText(rtNumberField, '123');
      await tester.enterText(rtNameField, 'RT 123');
      await tester.enterText(addressField, 'Jl. Raya Jakarta');
      await tester.tap(submitButton);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(NewRtFormScreen), findsNothing);
    });
  });
}