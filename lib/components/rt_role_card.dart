import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Navigator.pop(context); // Tutup bottom sheet setelah salin
  }

  Future<void> _shareViaWhatsApp(BuildContext context, String text) async {
    final String whatsappUrl = "whatsapp://send?text=${Uri.encodeComponent(text)}";
    final Uri url = Uri.parse(whatsappUrl);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        // Kalau WhatsApp nggak terinstall, kasih info aja
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('WhatsApp tidak terinstall di perangkat ini. 📱'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka WhatsApp. Error: $e 😥'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      Navigator.pop(context); // Tutup bottom sheet
    }
  }

  void _showShareOptions(BuildContext context, String textToShare) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Wrap(
            children: <Widget>[
              // Title di atas opsi
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Text(
                    'Pilih Aksi',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary400,
                    ),
                  ),
                ),
              ),
              Divider(height: 1.h, color: Colors.grey[300]),
              SizedBox(height: 10.h),
              // Opsi "Salin"
              ListTile(
                leading: Icon(Icons.copy, size: 24.w, color: Colors.blueGrey),
                title: Text('Salin Teks', style: TextStyle(fontSize: 16.sp)),
                onTap: () => _copyToClipboard(context, textToShare),
              ),
              ListTile(
                leading: Image.asset(
                  'images/whatsapp.png', // Pastiin ada icon WA di folder assets
                  width: 24.w,
                  height: 24.h,
                ),
                title: Text('Bagikan via WhatsApp', style: TextStyle(fontSize: 16.sp)),
                onTap: () => _shareViaWhatsApp(context, textToShare),
              ),
              SizedBox(height: 10.h),
              Divider(height: 1.h, color: Colors.grey[300]),
              SizedBox(height: 10.h),
              // Tombol Batal
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                      'Kirim',
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
                    onPressed: () {
                      _showShareOptions(context, widget.uniqueCode ?? '');
                    },
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