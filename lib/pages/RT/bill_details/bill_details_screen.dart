import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/theme/app_colors.dart';

import '../../../providers/providers.dart';
import '../../../providers/user_providers.dart';
import '../bill_management/edit_bill/edit_bills_screen.dart';

class BillDetailsScreen extends ConsumerWidget {
  const BillDetailsScreen({super.key, required this.billId});

  final String billId;

  Widget _buildPropertyItem(BuildContext context, String label, String sublabel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium
          ),
          Text(
            sublabel,
            style: GoogleFonts.roboto(fontSize: 14.sp)
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context, String billId) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 24.sp),
              const SizedBox(width: 10),
              const Text('Konfirmasi Hapus'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anda yakin ingin menghapus iuran ini?',
                style: GoogleFonts.roboto(fontSize: 15.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                'Aksi ini tidak dapat dibatalkan dan akan menghapus data iuran secara permanen',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.negative,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.w),
                  )
              ),
              child: Text('Ya, Hapus', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final asyncBill = ref.watch(billDetailsProvider(billId));
    final role = ref.watch(roleProvider);

    ref.listen<AsyncValue<void>>(billNotifierProvider, (prev, next) {
      if (prev is AsyncLoading && !next.isLoading) {
        if (next.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${next.error}')),
          );

        } else if (next is AsyncData) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Iuran berhasil dihapus')),
          );
          Navigator.of(context).pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Iuran',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: asyncBill.when(
        data: (bill) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPropertyItem(context, 'Judul Iuran', bill.billName),
              _buildPropertyItem(context, 'Tipe Iuran', bill.billType == BillType.regular
                  ? 'Bulanan' : 'Khusus'),
              _buildPropertyItem(context, 'Jatuh Tempo', DateFormat('dd MMMM yyyy', 'id_ID').format(bill.dueDate)),
              _buildPropertyItem(context, 'Nominal', currencyFormatter.format(bill.amount)),
              if (role!.contains('ketua'))...[
                const Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: AppColors.primary200, width: 1.5.w), // Lebar border dengan .w
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditBillsScreen(existingBill: bill),
                          )
                      );
                    },
                    child: Text(
                      'Edit Iuran',
                      textAlign: TextAlign.center, // Menambahkan text align center
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp, // Ukuran font disesuaikan
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary200,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton.icon(
                    label: Text(
                      'Hapus Iuran',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.negative,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () async {
                      final bool shouldDelete = await _showDeleteConfirmationDialog(context, billId);
                      if (shouldDelete) {
                        await ref.read(billNotifierProvider.notifier)
                            .executeDeleteBill(billId);
                      }
                    },
                  ),
                ),
                SizedBox(height: 20)
              ]
            ],
          );
        },
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }

}