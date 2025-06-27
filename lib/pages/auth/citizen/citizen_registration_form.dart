import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:wargaqu/pages/auth/citizen/citizen_login_form.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/services/auth_service.dart';
import 'package:wargaqu/services/user_service.dart';
import 'package:wargaqu/theme/app_colors.dart';

final userDbServiceProvider = Provider<UserDbService>((ref) {
  return UserDbService(FirebaseFirestore.instance);
});

class CitizenRegistrationForm extends ConsumerStatefulWidget {
  const CitizenRegistrationForm({super.key});

  @override
  ConsumerState<CitizenRegistrationForm> createState() => _CitizenRegistrationFormState();
}

class _CitizenRegistrationFormState extends ConsumerState<CitizenRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final RegExp _phoneRegExp = RegExp(r"^0[0-9]{9,12}$");

  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noKkController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _statusKependudukanController = TextEditingController();
  final TextEditingController _kodeRtController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    _noKkController.dispose();
    _noTeleponController.dispose();
    _pekerjaanController.dispose();
    _fullNameController.dispose();
    _statusKependudukanController.dispose();
    _kodeRtController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(registrationNotifierProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
      }
      if (!next.isLoading && !next.hasError && prev is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi RW berhasil!')));
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
                    Text('Halo Warga! Daftarkan akun dengan data diri secara lengkap dan benar sesuai dengan KTP',
                        style: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(height: 20.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _namaLengkapController,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              prefixIcon: Icon(Icons.person, size: 24.r),
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama Lengkap wajib diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: _nikController,
                            decoration: InputDecoration(
                              labelText: 'NIK',
                              prefixIcon: Icon(Icons.credit_card, size: 24.r),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'NIK wajib diisi, ya!';
                              }
                              if (value.length != 16) {
                                return 'NIK harus 16 digit';
                              }
                              if (int.tryParse(value) == null) {
                                return 'NIK harus berupa angka';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: _alamatController,
                            decoration: InputDecoration(
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
                            controller: _noKkController,
                            decoration: InputDecoration(
                              labelText: 'Nomor Kartu Keluarga',
                              prefixIcon: Icon(Icons.group, size: 24.r),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor Kartu Keluarga wajib diisi';
                              }
                              if (value.length != 16) {
                                return 'Nomor KK harus 16 digit';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Nomor KK harus berupa angka';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: _noTeleponController,
                            decoration: InputDecoration(
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
                            controller: _pekerjaanController,
                            decoration: InputDecoration(
                                labelText: 'Pekerjaan Saat Ini',
                                prefixIcon: Icon(Icons.work, size: 24.r)
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pekerjaan Saat Ini wajib diisi.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: _statusKependudukanController,
                            decoration: InputDecoration(
                              labelText: 'Status Kependudukan',
                              prefixIcon: Icon(Icons.account_balance, size: 24.r),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Status Kependudukan wajib diisi.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: _kodeRtController,
                            decoration: InputDecoration(
                              labelText: 'Kode Unik RT',
                              prefixIcon: Icon(Icons.qr_code_scanner, size: 24.r),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kode Unik RT wajib diisi.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              prefixIcon: Icon(Icons.person, size: 24.r),
                            ),
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama Lengkap harus diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
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
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary200,
                                padding: EdgeInsets.symmetric(vertical: 16.h), // Padding vertikal dengan .h
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r), // Radius dengan .r
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Logika pendaftaran
                                }
                              },
                              child: Text(
                                'Daftar',
                                style: GoogleFonts.roboto(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500),
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
                                    MaterialPageRoute(builder: (context) => const CitizenLoginForm())
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
