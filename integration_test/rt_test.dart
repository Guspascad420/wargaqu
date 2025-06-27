import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/pages/RT/bill_management/add_bills_screen.dart';
import 'package:wargaqu/pages/RT/bill_management/new_bank_account_form/new_bank_account_form.dart';
import 'package:wargaqu/pages/RT/rt_main_screen.dart';
import 'package:wargaqu/pages/auth/RT/rt_login_form.dart';
import 'package:wargaqu/pages/auth/RT/rt_registration_form.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/theme/app_theme.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('RT registration test', () {
    testWidgets('User (RT) bisa sign up dengan kredensial yang valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(360, 800),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.system,
                home: child);
          },
          child: const RtRegistrationForm(),
        ),
      ));

      final Finder fullNameField = find.byKey(const Key('fullNameField'));
      final Finder nikField = find.byKey(const Key('nikField'));
      final Finder addressField = find.byKey(const Key('addressField'));
      final Finder phoneNumberField = find.byKey(const Key('phoneNumberField'));
      final Finder rtUniqueCodeField =
          find.byKey(const Key('rtUniqueCodeField'));
      final Finder emailField = find.byKey(const Key('emailField'));
      final Finder passwordField = find.byKey(const Key('passwordField'));
      final Finder submitButton = find.byKey(const Key('submitButton'));

      await tester.enterText(fullNameField, 'Kylian Mbappe');
      await tester.pumpAndSettle(); // Tunggu UI stabil setelah input

      await tester.enterText(nikField, '292991111888');
      await tester.pumpAndSettle();

      await tester.enterText(addressField, 'Jl. Raya Jakarta');
      await tester.pumpAndSettle();
      await tester.enterText(phoneNumberField, '08123456789');
      await tester.pumpAndSettle();
      await tester.ensureVisible(rtUniqueCodeField);
      await tester
          .pumpAndSettle();
      await tester.enterText(
          rtUniqueCodeField, 'KETUA-UMWRVTMGYDTU50JH9XYK-XCR5XC');
      await tester.pumpAndSettle();
      await tester.ensureVisible(emailField);
      await tester.pumpAndSettle();
      await tester.enterText(emailField, 'kylianmbappe@gmail.com');
      await tester.pumpAndSettle();

      await tester.ensureVisible(passwordField);
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, 'mbappe123');
      await tester.pumpAndSettle();

      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(RtMainScreen), findsOneWidget);
    });
  });

  group('Login and Home Screen Flow', () {
    testWidgets('Setelah login berhasil, halaman home harus menampilkan nama user',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          ProviderScope(
            child: ScreenUtilInit(
              designSize: const Size(360, 800),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: ThemeMode.system,
                    home: child);
              },
              child: const RtLoginForm(),
            ),
          )
      );

      await tester.enterText(find.byKey(const Key('emailField')), 'kylianmbappe@gmail.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'mbappe123');

      await tester.tap(find.byKey(const Key('loginButton')));

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(RtMainScreen), findsOneWidget);
      expect(find.byType(RtLoginForm), findsNothing);

      expect(find.text('dan sudah terhubung pada'), findsOneWidget);

      print('✅ Tes alur login ke home berhasil!');
    });

    // Lo bisa nambahin testWidgets lain di sini, tapi dia bakal jalan dari nol lagi
    // testWidgets('Tombol lain di home berfungsi', (WidgetTester tester) async {
    //   // ...
    // });
  });

  group('Add new bank account', () {
    final testRtData = RtData(
      id: 'UMwRVTMgydtU50jH9xyk',
      rwId: '', rtNumber: 001, rtName: '',
    );

    testWidgets('User bisa menambahkan rekening bank', (WidgetTester tester) async {
      await tester.pumpWidget(
          ProviderScope(
            overrides: [
              // Override rtDataProvider with your specific testRtData instance
              rtDataProvider.overrideWithValue(testRtData),
            ],
            child: ScreenUtilInit(
              designSize: const Size(360, 800),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: ThemeMode.system,
                    home: child);
              },
              child: const NewBankAccountForm(),
            ),
          )
      );
      final Finder dropdownMenuFinder = find.byType(DropdownMenu<String>);
      expect(dropdownMenuFinder, findsOneWidget);

      final Finder accountNumberField = find.byKey(
          const Key('accountNumberField'));
      final Finder accountHolderField = find.byKey(
          const Key('accountHolderField'));
      final Finder submitButton = find.byKey(const Key('submitButton'));

      // Enter text into the fields
      await tester.tap(dropdownMenuFinder);
      await tester.pumpAndSettle();
      final String bankToSelect = 'Bank Mandiri';
      final Finder bankMenuItemFinder = find.text(bankToSelect).last;

      expect(bankMenuItemFinder, findsOneWidget);
      await tester.tap(bankMenuItemFinder);
      await tester.pumpAndSettle();

      await tester.enterText(accountNumberField, '1234567890');
      await tester.pumpAndSettle();

      await tester.enterText(accountHolderField, 'Kylian Mbappe');
      await tester.pumpAndSettle();

      // Ensure the submit button is visible and tap it
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(NewBankAccountForm), findsNothing);

      // Wait for navigation or any async operations to complete
    });
  });

  group('Add new bill', () {
    final testRtData = RtData(
      id: 'UMwRVTMgydtU50jH9xyk',
      rwId: '', rtNumber: 001, rtName: '',
    );

    testWidgets('User bisa menambahkan rekening bank', (WidgetTester tester) async {
      await tester.pumpWidget(
          ProviderScope(
            overrides: [
              // Override rtDataProvider with your specific testRtData instance
              rtDataProvider.overrideWithValue(testRtData),
            ],
            child: ScreenUtilInit(
              designSize: const Size(360, 800),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: ThemeMode.system,
                    home: child);
              },
              child: const AddBillsScreen(billType: BillType.regular),
            ),
          )
      );

      await tester.enterText(find.byKey(const Key('titleField')), 'Iuran Januari 2025');
      await tester.enterText(find.byKey(const Key('amountField')), '50000');
      await tester.tap(find.text('Pilih tanggal...'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('descriptionField')), 'Untuk petugas sampah mingguan');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(NewBankAccountForm), findsNothing);
    });
  });
}
