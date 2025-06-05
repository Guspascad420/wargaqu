import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill/bill.dart';

class PaymentDetailDialogContent extends StatelessWidget {
  final Bill data;

  const PaymentDetailDialogContent({super.key, required this.data});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return Colors.green.shade700;
      case 'belum dibayar':
        return Colors.orange.shade700;
      case 'menunggu konfirmasi':
        return Colors.blue.shade600;
      case 'ditolak':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade800;
    }
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {Color? valueColor, FontWeight? valueWeight}) {
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
          _buildDetailRow(context, 'Nama Iuran', data.billName, valueWeight: FontWeight.w500),
          _buildDetailRow(context, 'Dibuat oleh', data.createdBy),
          _buildDetailRow(context, 'Nominal', currencyFormatter.format(data.amount), valueWeight: FontWeight.w500),

          SizedBox(height: 10.h),

          _buildSectionTitle(context, 'Detail Pembayaran'),
          _buildDetailRow(context, 'Batas Bayar', '${dateFormatter.format(data.dueDate)} WIB'),
          _buildDetailRow(context, 'Media Bayar', data.paymentMethod),
          _buildDetailRow(context,
            'Status',
            data.paymentStatus,
            valueColor: _getStatusColor(data.paymentStatus),
            valueWeight: FontWeight.bold,
          ),
          if (data.paymentStatus == 'Menunggu konfirmasi')...[
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
