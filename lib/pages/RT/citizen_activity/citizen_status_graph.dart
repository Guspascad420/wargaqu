import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:segmented_progress_bar/segmented_progress_bar.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

class CitizenStatusGraph extends ConsumerWidget {
  const CitizenStatusGraph({super.key});

  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          margin: EdgeInsets.only(left: 15.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtData = ref.watch(rtDataProvider);
    final asyncStatusSegments = ref.watch(statusSegmentsProvider((rtId: rtData!.id, context: context)));

    return asyncStatusSegments.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (socialSegments) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 15.w),
                  child: SegmentedProgressBar(
                    segments: socialSegments,
                  ),
                ),
              ),
              legendItem(AppColors.positive, 'Lunas'),
              SizedBox(height: 5.h),
              legendItem(Colors.indigo, 'Perlu Konfirmasi'),
              SizedBox(height: 5.h),
              legendItem(AppColors.negative, 'Belum bayar'),
              SizedBox(height: 20.h),
            ]
        );
      }
    );
  }

}