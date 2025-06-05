import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill_type.dart';
import 'package:wargaqu/pages/citizen/bank_account/bank_account_selection_screen.dart';

class BillItemCard extends StatelessWidget {
  final BillType? billType;
  final String title;
  final DateTime dueDate;
  final double amount;
  final String? status;
  final void Function(BuildContext)? showPaymentDetailDialog;

  const BillItemCard({
    super.key,
    this.billType,
    required this.title,
    required this.dueDate,
    required this.amount,
    this.status,
    this.showPaymentDetailDialog,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'Lunas':
        return Colors.green.shade600;
      case 'Belum bayar':
        return Colors.orange.shade700;
      case 'Menunggu konfirmasi':
        return Colors.blue.shade600;
      case 'Ditolak':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final dateFormatter = DateFormat('d MMMM yyyy',);

    return InkWell(
      onTap: () {
        if (status == null && billType != null) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BankAccountSelectionScreen(
                 billType: billType!, title: 'Iuran Februari 2024', amount: 20000
              ))
          );
        } else {
          showPaymentDetailDialog!(context);
        }
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
                      Text(title, style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 4.h),
                      Text(
                        'Tenggat Bayar: ${dateFormatter.format(dueDate)}',
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Nominal: ${currencyFormatter.format(amount)}',
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                        ),
                      ),
                      if (status != null && status!.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          'Status: $status',
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(status)
                          ),
                        ),
                      ],
                    ],
                  )
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