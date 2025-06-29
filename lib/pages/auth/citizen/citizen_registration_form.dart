import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:wargaqu/pages/auth/citizen/citizen_login_form.dart';
import 'package:wargaqu/pages/citizen/waiting_approval/waiting_for_approval_screen.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

import '../../../model/RT/rt_data.dart';
import '../../../providers/rt_providers.dart';
import '../../../providers/rw_providers.dart';

class CitizenRegistrationForm extends ConsumerStatefulWidget {
  const CitizenRegistrationForm({super.key});

  @override
  ConsumerState<CitizenRegistrationForm> createState() => _CitizenRegistrationFormState();
}

class _CitizenRegistrationFormState extends ConsumerState<CitizenRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final _focusNode = FocusNode();
  bool _isListVisible = false;
  String _selectedRwId = '';
  String _selectedRtId = '';

  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final RegExp _phoneRegExp = RegExp(r"^0[0-9]{9,12}$");

  final List<String> residencyStatusOptions = [
    'Warga Tetap',
    'Warga Kontrak / Kost',
    'Warga Tidak Tetap',
    'Pemilik Properti (Tidak Menetap)',
  ];

  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _rwSearchController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noKkController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _nikController.dispose();
    _addressController.dispose();
    _noKkController.dispose();
    _noTeleponController.dispose();
    _occupationController.dispose();
    _fullNameController.dispose();
    _statusController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rwSearchController.dispose();
    _rtController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isListVisible = _focusNode.hasFocus;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(registrationNotifierProvider, (prev, next) {
      if (prev is AsyncLoading && !next.isLoading) {
        if (next.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
        }
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const WaitingForApprovalScreen())
        );
      }
    });

    final filteredRwList = ref.watch(filteredRwsProvider);
    final allRwsAsync = ref.watch(allRwsProvider);
    final regState = ref.watch(registrationNotifierProvider);

    double containerHeight = 0;
    if (_isListVisible && _rwSearchController.text.isNotEmpty) {
      if (filteredRwList.isNotEmpty) {
        const double itemHeight = 60.0;
        const double maxHeight = 216.0;
        containerHeight = min(filteredRwList.length * itemHeight, maxHeight);
      } else {
        containerHeight = 60.0;
      }
    }

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
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
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
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
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
                            controller: _rwSearchController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              labelText: 'Ketik nama perumahan atau RW...',
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            onChanged: (query) {
                              ref.read(rwSearchQueryProvider.notifier).state = query;
                            },
                          ),

                          if (_isListVisible)
                            allRwsAsync.when(
                              loading: () => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Memuat daftar RW...'),
                              ),
                              error: (e, s) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
                              ),
                              data: (_) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: containerHeight,
                                margin: const EdgeInsets.only(top: 8.0),
                                child: Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(8),
                                  child: filteredRwList.isEmpty && _rwSearchController.text.isNotEmpty
                                      ? const Center(child: Text("RW tidak ditemukan."))
                                      : ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: filteredRwList.length,
                                          itemBuilder: (context, index) {
                                            final rw = filteredRwList[index];
                                            return ListTile(
                                              title: Text(rw.rwName),
                                              onTap: () {
                                                _rwSearchController.text = rw.rwName;
                                                _selectedRwId = rw.id;
                                                _focusNode.unfocus();
                                                ref.read(rwSearchQueryProvider.notifier).state = '';
                                              },
                                            );
                                          },
                                        ),
                                ),
                              ),
                            ),
                          SizedBox(height: 16.h,),

                          if (_rwSearchController.text.isNotEmpty)...[
                            ref.watch(rtListProvider(_selectedRwId)).when(
                              loading: () => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Memuat daftar RT...'),
                              ),
                              error: (e, s) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
                              ),
                              data: (rtList) {
                                final List<DropdownMenuEntry<RtData>> rtEntries = rtList.map((rt) {
                                  return DropdownMenuEntry(value: rt, label: rt.rtName);
                                }).toList();

                                return DropdownMenu<RtData>(
                                  expandedInsets: EdgeInsets.zero,
                                  controller: _rtController,
                                  label: Text('Pilih RT...', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                                  dropdownMenuEntries: rtEntries,
                                  onSelected: (RtData? rt) {
                                    if (rt != null) {
                                      setState(() {
                                        _selectedRtId = rt.id;
                                      });
                                    }
                                  },
                                );
                              }
                            ),
                            SizedBox(height: 16.h),
                          ],

                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Alamat',
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
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
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
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
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
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
                            controller: _occupationController,
                            decoration: InputDecoration(
                                labelText: 'Pekerjaan Saat Ini',
                                filled: true,
                                fillColor: Theme.of(context).colorScheme.surface,
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

                          DropdownMenu<String>(
                            controller: _statusController,
                            expandedInsets: EdgeInsets.zero,
                            label: Text('Status Kependudukan', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                            dropdownMenuEntries:
                            residencyStatusOptions.map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                              );
                            }).toList(),
                            // Fungsi yang dijalankan saat salah satu item dipilih
                            onSelected: (String? status) {
                              if (status != null) {
                                print('Status yang dipilih: $status');
                              }
                            },
                            leadingIcon: Icon(Icons.person_pin_circle_outlined, size: 24.r),
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
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
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
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
                                backgroundColor: AppColors.primary400,
                                padding: EdgeInsets.symmetric(vertical: 16.h), // Padding vertikal dengan .h
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r), // Radius dengan .r
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(registrationNotifierProvider.notifier).registerCitizen(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    fullName: _fullNameController.text,
                                    nik: _nikController.text,
                                    phoneNumber: _noTeleponController.text,
                                    address: _addressController.text,
                                    kkNumber: _noKkController.text,
                                    currentOccupation: _occupationController.text,
                                    residencyStatus: _statusController.text,
                                    rwId: _selectedRwId,
                                    rtId: _selectedRtId
                                  );
                                }
                              },
                              child: regState.isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
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
