import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/providers/rt_providers.dart';

class RtItemCard extends ConsumerWidget {
  final String rtId;
  final String rtName;
  final int population;
  final bool isActive;

  const RtItemCard({super.key, required this.rtId, required this.rtName,
    required this.population, required this.isActive});

  Color _getStatusFontColor() {
    return isActive ? Colors.green.shade800 : Colors.grey.shade800;
  }

  Color _getStatusColor() {
    return isActive ? Colors.green.shade100 : Colors.grey.shade100;
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: GoogleFonts.roboto(fontSize: 13.sp, color: Theme.of(context).colorScheme.onSurface)),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncChairman = ref.watch(rtChairmanProvider(rtId));
    final rtChairman = asyncChairman.when(
      data: (chairman) => chairman?.fullName ?? '',
      loading: () => 'Loading...',
      error: (err, stack) => '',
    );
    return InkWell(
        onTap: () {

        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rtName, style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        children: [
                          Text('Ketua: ', style: GoogleFonts.roboto(fontSize: 13.sp, color: Theme.of(context).colorScheme.onSurface)),
                          Expanded(
                            child: Text(
                              rtChairman == '' ? 'Belum ditentukan' : rtChairman,
                              style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w600,
                                  color: rtChairman == '' ? Colors.red : Theme.of(context).colorScheme.onSurface),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      _buildDetailRow(context, 'Jumlah Warga', '$population KK'),
                      SizedBox(height: 5.h),
                      Chip(
                        label: Text(isActive ? 'Aktif' : 'Nonaktif',
                            style: GoogleFonts.roboto(fontSize: 14.sp,
                                fontWeight: FontWeight.bold, color: _getStatusFontColor())),
                        backgroundColor: _getStatusColor(),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade500,
                  size: 36.r,
                ),
              ],
            )
        )
    );
  }
}