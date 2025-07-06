import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/payment/payment.dart';

class PaymentDetailDialogContent extends StatelessWidget {
  final String billName;
  final int amountPaid;
  final String paymentMethod;
  final String status;

  const PaymentDetailDialogContent({super.key, required this.billName,
    required this.amountPaid, required this.paymentMethod, required this.status});

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'lunas':
        return Colors.green.shade100;
      case 'belum_bayar':
        return Colors.orange.shade100;
      case 'perlu_konfirmasi':
        return Colors.blue.shade100;
      case 'ditolak':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'lunas':
        return 'Lunas';
      case 'belum_bayar':
        return 'Belum bayar';
      case 'perlu_konfirmasi':
        return 'Menunggu konfirmasi';
      case 'ditolak':
        return 'Ditolak';
      default:
        return '';
    }
  }

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {Color? valueColor, FontWeight? valueWeight}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyLarge),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                fontWeight: valueWeight ?? FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentProofRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Bukti bayar: ',
              style: Theme.of(context).textTheme.bodyLarge),
          Expanded(
            child: GestureDetector(
                onTap: () {

                },
                child: Text(
                  'Lihat disini',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue.shade600
                  ),
                ),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final dateFormatter = DateFormat('d MMMM yyyy, HH:mm');

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Detail Iuran'),
          _buildDetailRow(context, 'Nama Iuran', billName, valueWeight: FontWeight.w500),
          // _buildDetailRow(context, 'Dibuat oleh', createdBy),
          _buildDetailRow(context, 'Nominal', currencyFormatter.format(amountPaid), valueWeight: FontWeight.w500),

          SizedBox(height: 10.h),

          _buildSectionTitle(context, 'Detail Pembayaran'),
          _buildDetailRow(context, 'Media Bayar', paymentMethod),
          _buildDetailRow(context,
            'Status',
            _getStatusText(status),
            valueColor: _getStatusColor(status),
            valueWeight: FontWeight.bold,
          ),
          if (status == 'perlu_konfirmasi')...[
            _buildPaymentProofRow(context),
          ],
          SizedBox(height: 24.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
