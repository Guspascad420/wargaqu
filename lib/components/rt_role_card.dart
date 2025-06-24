import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/theme/app_colors.dart';

enum UniqueCodeStatus { available, used, notGenerated }

class RtRoleCard extends ConsumerStatefulWidget {
  final String roleName;
  final String? uniqueCode;
  final UniqueCodeStatus status;
  final String? usedBy;
  final String? usedAt;
  final Future<void> Function()? onGenerate;
  final VoidCallback? onRegenerate;
  final VoidCallback? onShare;
  final VoidCallback? onDeactivate;

  const RtRoleCard({
    super.key,
    required this.roleName,
    this.uniqueCode,
    required this.status,
    this.usedBy,
    this.usedAt,
    this.onGenerate,
    this.onRegenerate,
    this.onShare,
    this.onDeactivate,
  });

  @override
  ConsumerState<RtRoleCard> createState() => _RtRoleCardState();
}

class _RtRoleCardState extends ConsumerState<RtRoleCard> {
  bool _isLoading = false;

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: Colors.grey.shade600),
          SizedBox(width: 8.w),
          Text('$label: ', style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.grey.shade500)),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    Color chipTextColor;
    String chipText;

    switch (widget.status) {
      case UniqueCodeStatus.available:
        chipColor = Colors.blue.shade100;
        chipTextColor = Colors.blue.shade800;
        chipText = 'TERSEDIA';
        break;
      case UniqueCodeStatus.used:
        chipColor = Colors.green.shade100;
        chipTextColor = Colors.green.shade800;
        chipText = 'SUDAH DIGUNAKAN';
        break;
      case UniqueCodeStatus.notGenerated:
        chipColor = Colors.grey.shade100;
        chipTextColor = Colors.grey.shade800;
        chipText = 'BELUM DIBUAT';
        break;
    }
    return Chip(
      label: Text(chipText, style: GoogleFonts.roboto(fontSize: 11.sp, fontWeight: FontWeight.bold, color: chipTextColor)),
      backgroundColor: chipColor,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.grey.shade200, width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.roleName,
                style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              _buildStatusChip(),
            ],
          ),
          const Divider(height: 20.0),

          if (widget.status == UniqueCodeStatus.notGenerated)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary400,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Generate Kode', style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        ),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await widget.onGenerate?.call();
                    } catch (e) {
                      print("Aksi generate gagal: $e");
                    } finally {
                      if (mounted) { // Best practice: cek kalo widget masih ada di tree
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  }
                )
              ],
            )
          else ...[
            _buildDetailRow(context, Icons.vpn_key_outlined, "Kode Unik", widget.uniqueCode ?? '-'),
            if (widget.status == UniqueCodeStatus.used) ...[
              _buildDetailRow(context, Icons.person_outline, "Digunakan oleh", widget.usedBy ?? '-'),
              _buildDetailRow(context, Icons.calendar_today_outlined, "Pada Tanggal", widget.usedAt ?? '-'),
            ],
            SizedBox(height: 12.h),
            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.status == UniqueCodeStatus.available) ...[
                  TextButton(
                      onPressed: widget.onDeactivate,
                      child: Text('Nonaktifkan', style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ))
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share, size: 16, color: Colors.white),
                    label: Text(
                      'Kirim via WA',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.positive,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: widget.onShare,
                  ),
                ],
                if (widget.status == UniqueCodeStatus.used)
                  ElevatedButton(
                    onPressed: widget.onRegenerate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.negative,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Ganti Pengurus',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            )
          ]
        ],
      ),
    );
  }
}