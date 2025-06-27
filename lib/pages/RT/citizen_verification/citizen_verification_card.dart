import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../model/user/user.dart';
import '../../../theme/app_colors.dart';

class CitizenVerificationCard extends StatefulWidget {
  final UserModel applicant;
  final String rtName;
  final VoidCallback onApprove;
  final VoidCallback onViewDetail;

  const CitizenVerificationCard({super.key, required this.applicant,
    required this.onApprove, required this.onViewDetail, required this.rtName});

  @override
  State<CitizenVerificationCard> createState() => _CitizenVerificationCardState();
}

class _CitizenVerificationCardState extends State<CitizenVerificationCard> {
  final _dateFormatter = DateFormat('d MMMM yyyy, HH:mm');
  final TextEditingController _reasonController = TextEditingController();
  bool _isBeingRejected = false;

  Future<bool> _showCitizenApprovalDialog(
      BuildContext context, {
        required UserModel applicant,
      }) async
  {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(Icons.how_to_reg_rounded, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              const Text('Konfirmasi Persetujuan'),
            ],
          ),
          titleTextStyle: GoogleFonts.roboto(
              fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          content: Text.rich(
            TextSpan(
              style: GoogleFonts.roboto(fontSize: 15, color: Colors.grey.shade700),
              children: <TextSpan>[
                const TextSpan(text: 'Anda yakin ingin menyetujui pendaftaran atas nama '),
                TextSpan(
                  text: applicant.fullName,
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                const TextSpan(text: ' sebagai warga di '),
                TextSpan(
                  text: widget.rtName,
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w),
                )
              ),
              child: Text('Ya, Setujui', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    // Jika user menutup dialog tanpa menekan tombol (misal, klik di luar),
    // result akan null. Kita anggap itu sebagai 'false'.
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: widget.onViewDetail,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.applicant.fullName,
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.applicant.address,
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Mendaftar pada: ${_dateFormatter.format(widget.applicant.joinedTimestamp!)}',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.close_rounded, size: 18.sp),
                    label: const Text('Tolak'),
                    onPressed: () {
                      setState(() {
                        if (_isBeingRejected) {
                          _isBeingRejected = false;
                        } else {
                          _isBeingRejected = true;
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: _isBeingRejected ? Colors.white : Colors.red.shade700,
                      backgroundColor: _isBeingRejected ? Colors.red.shade700 : Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.w),
                          side: BorderSide(
                            color: Colors.red.shade700,
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton.icon(
                    icon: Icon(Icons.check_rounded, size: 18.sp),
                    label: Text('Setujui', style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )),
                    onPressed: () async {
                      final bool shouldApprove = await _showCitizenApprovalDialog(context, applicant: widget.applicant);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isBeingRejected)...[
                SizedBox(height: 15.h),
                TextField(
                  key: const Key('addressField'),
                  controller: _reasonController,
                  decoration: InputDecoration(
                      labelText: 'Berikan alasan penolakan...',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('submitButton'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary400,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: _reasonController.text.isEmpty ? null : () {

                    },
                    child: Text(
                      'Kirim',
                      style: GoogleFonts.roboto(fontSize: 15.sp,
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

}