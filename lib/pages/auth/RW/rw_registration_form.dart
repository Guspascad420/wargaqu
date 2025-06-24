import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/pages/RW/rw_main_screen.dart';
import 'package:wargaqu/pages/auth/RW/rw_login_form.dart';
import 'package:wargaqu/providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

class RwRegistrationForm extends ConsumerStatefulWidget {
  const RwRegistrationForm({super.key});

  @override
  ConsumerState<RwRegistrationForm> createState() => _RwRegistrationFormState();
}

class _RwRegistrationFormState extends ConsumerState<RwRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _didSubmit = false;

  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final RegExp _phoneRegExp = RegExp(r"^0[0-9]{9,12}$");

  final TextEditingController _namaRwController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _kodeRwController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _namaRwController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _fullNameController.dispose();
    _kodeRwController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(registrationNotifierProvider, (prev, next) {
      if (!_didSubmit) return;

      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );

        print(next.error);

      } else if (next is AsyncData<void>) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RwMainScreen())
        );
        setState(() {
          _didSubmit = false;
        });
      }
    });

    final regState = ref.watch(registrationNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image.asset(
                          'images/wargaqu.png',
                          width: 150.w,
                          fit: BoxFit.contain,
                        )
                    ),
                    SizedBox(height: 30.h),
                    Text('Daftar Akun', style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10.h),
                    Text('Halo RW! Daftarkan akun dengan data RW Anda',
                        style: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(height: 20.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: const Key('addressField'),
                            controller: _addressController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Alamat',
                              prefixIcon: Icon(Icons.home, size: 24.r),
                            ),
                            keyboardType: TextInputType.streetAddress,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat harus diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            key: const Key('phoneNumberField'),
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Nomor Telepon',
                              prefixIcon: Icon(Icons.phone, size: 24.r),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor Telepon wajib diisi';
                              }
                              if (!_phoneRegExp.hasMatch(value)) {
                                return 'Format Nomor Telepon salah, coba lagi (Contoh: 0812xxxx)';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            key: const Key('rwUniqueCodeField'),
                            controller: _kodeRwController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Kode Unik RW',
                              prefixIcon: Icon(Icons.qr_code_scanner, size: 24.r),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kode Unik RW wajib diisi.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            key: const Key('fullNameField'),
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Nama Lengkap',
                              prefixIcon: Icon(Icons.person, size: 24.r),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama Lengkap harus diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            key: const Key('emailField'),
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email, size: 24.r),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email wajib diisi.';
                              }
                              if (!_emailRegExp.hasMatch(value)) {
                                return 'Format Email tidak valid.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            key: const Key('passwordField'),
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Kata Sandi',
                              prefixIcon: Icon(Icons.lock, size: 24.r),
                              helperText: 'Minimal 6 karakter.',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  size: 24.r,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kata Sandi wajib diisi.';
                              }
                              if (value.length < 6) {
                                return 'Kata Sandi minimal terdiri dari 6 karakter.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: const Key('submitButton'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary400,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _didSubmit = true;
                                  });
                                  ref.read(registrationNotifierProvider.notifier).registerRwOfficial(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    fullName: _fullNameController.text,
                                    rwUniqueCode: _kodeRwController.text,
                                    address: _addressController.text,
                                    phoneNumber: _phoneNumberController.text
                                  );
                                }
                              },
                              child: regState.isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Daftar',
                                      style: GoogleFonts.roboto(fontSize: 18.sp,
                                          color: Colors.white, fontWeight: FontWeight.w500),
                                    ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                side: BorderSide(color: AppColors.primary90, width: 1.5.w), // Lebar border dengan .w
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Kembali Ke Menu Masuk Sebagai',
                                textAlign: TextAlign.center, // Menambahkan text align center
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp, // Ukuran font disesuaikan
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary90,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sudah punya akun? ',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => const RwLoginForm())
                                  );
                                },
                                child: Text(
                                  'Masuk',
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary90
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}
