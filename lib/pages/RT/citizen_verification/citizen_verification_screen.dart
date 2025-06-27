import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/pages/RT/citizen_verification/citizen_verification_card.dart';
import 'package:wargaqu/theme/app_colors.dart';

import '../../../providers/rt_providers.dart';

class CitizenVerificationScreen extends ConsumerWidget {

  final List<UserModel> mockPendingCitizens;

  const CitizenVerificationScreen({super.key, required this.mockPendingCitizens});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtData = ref.watch(rtDataProvider);
    final asyncPendingCitizens = ref.watch(pendingCitizensProvider(rtData!.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi Warga',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: asyncPendingCitizens.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text(err.toString()),
        data: (pendingCitizens) {
          return pendingCitizens.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, color: AppColors.positive, size: 125.w),
                      SizedBox(height: 10.h,),
                      Text('Semua Sudah Beres!', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                      Text('Kerja bagus! Saat ini tidak ada pendaftaran warga baru yang memerlukan persetujuan Anda',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF74696D),
                          ),
                          textAlign: TextAlign.center),
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    final applicant = mockPendingCitizens[index];
                    return CitizenVerificationCard(applicant: applicant, onApprove: () {},
                        onViewDetail: () {}, rtName: 'RT 003 La Masia');
                  },
                  separatorBuilder: (BuildContext context, int index) => SizedBox(height: 16.h),
                  itemCount: mockPendingCitizens.length
              );
        }
      ),
    );
  }
}