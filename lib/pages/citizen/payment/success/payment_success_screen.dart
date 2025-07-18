import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/main.dart';
import 'package:wargaqu/pages/citizen/citizen_main_screen.dart';
import 'package:wargaqu/theme/app_colors.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final int amount;
  final String destinationBank;
  final DateTime transactionDate;

  const PaymentSuccessScreen({super.key, required this.amount, required this.destinationBank, required this.transactionDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('images/good_team_pana.png'),
              Text(
                  'Upload Bukti Berhasil!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge
              ),
              SizedBox(height: 12.h),
              Text(
                  'Pembayaran Anda sedang kami proses dan menunggu konfirmasi dari pengurus RT. '
                      'Anda akan menerima notifikasi jika status pembayaran telah diperbarui.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
              ),
              SizedBox(height: 15.h),
              _buildSummaryCard(context),
              SizedBox(height: 15.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthWrapper()),
                        (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary400,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Kembali ke beranda',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('d MMMM yyyy, HH:mm');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSummaryRow(context, 'Total Pembayaran: ', currencyFormatter.format(amount)),
          const Divider(height: 20),
          _buildSummaryRow(context, 'Tujuan Transfer: ', destinationBank),
          const Divider(height: 20),
          _buildSummaryRow(context, 'Waktu Transaksi: ', dateFormatter.format(transactionDate)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            color: Colors.grey.shade600,
            fontSize: 14.sp,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            style: GoogleFonts.roboto(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

}