import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/pages/RW/unique_code/unique_code_management_screen.dart';
import 'package:wargaqu/pages/login_choice.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/rt_providers.dart';

class RwProfileScreen extends ConsumerWidget {
  const RwProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return Container(
        margin: EdgeInsets.all(15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pengaturan Saya', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {

              },
              borderRadius: BorderRadius.circular(12.0), // Biar efek ripple-nya juga rounded
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: Theme.of(context).colorScheme.onSurface, // Warna ikon dari parameter
                      size: 22.w,
                    ),
                    SizedBox(width: 16.w),
                    // Teks Menu
                    Expanded(
                      child: Text(
                        'Akun Saya',
                        style: GoogleFonts.roboto(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade500,
                      size: 28.r,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Text('Manajemen RW', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UniqueCodeManagementScreen())
                );
              },
              borderRadius: BorderRadius.circular(12.0), // Biar efek ripple-nya juga rounded
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.key_rounded,
                      color: Theme.of(context).colorScheme.onSurface, // Warna ikon dari parameter
                      size: 22.w,
                    ),
                    SizedBox(width: 16.w),
                    // Teks Menu
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generate kode unik RT',
                            style: GoogleFonts.roboto(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Buat & kelola kode registrasi untuk pengurus RT',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade500,
                      size: 28.r,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: Text(
                  'Keluar',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  authService.signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginChoiceScreen())
                  );
                },
              ),
            ),
          ],
        )
    );
  }

}