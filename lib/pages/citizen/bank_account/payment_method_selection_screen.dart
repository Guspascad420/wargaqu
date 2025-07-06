import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/pages/citizen/payment/payment_screen.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/bill/bill.dart';
import '../../../providers/rt_providers.dart';

final selectedAccountIdProvider = StateProvider<String?>((ref) => null);

class PaymentMethodSelectionScreen extends ConsumerWidget {
  final Bill bill;
  final BillType billType;

  const PaymentMethodSelectionScreen({super.key, required this.billType, required this.bill});

  Widget _bankAccountContainer(BuildContext context, BankAccount account,
      bool isSelected, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary400.withOpacity(0.1) : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.primary400 : Colors.grey.shade300,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () {
            ref.read(selectedAccountIdProvider.notifier).state = account.id;
          },
          borderRadius: BorderRadius.circular(12.r),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                account.logoAsset == null ? Icon(Icons.account_balance_rounded, size: 35.r)
                    : Image.asset(account.logoAsset!, width: 50.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName,
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.blue.shade500 : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        account.accountNumber,
                        style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'a/n ${account.accountHolder}',
                        style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: Theme.of(context).primaryColor, size: 24.r)
                else
                  Icon(Icons.circle_outlined, color: Colors.grey.shade400, size: 24.r),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchWhatsApp(String? chairmanPhoneNumber) {
    if (chairmanPhoneNumber == null) {
      return;
    }

    String phoneNumber = '';
    if (!chairmanPhoneNumber.startsWith('0')) {
      phoneNumber = '62${chairmanPhoneNumber.substring(1)}';
    }
    final url = 'https://wa.me/$phoneNumber';
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtData = ref.watch(rtDataProvider);
    final String? selectedAccountId = ref.watch(selectedAccountIdProvider);
    final asyncChairman = ref.watch(rtChairmanProvider(rtData!.id));

    final chairmanPhoneNumber = asyncChairman.when(
      data: (chairman) => chairman?.phoneNumber,
      loading: () => 'Loading...',
      error: (err, stack) => '',
    );

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h,),
            Text('Pilih Metode Pembayaran', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 30.h, horizontal: 25.w),
        child: ElevatedButton.icon(
          label: Text(
            rtData.bankAccounts.isNotEmpty
                ? 'Selanjutnya'
                : 'Hubungi Pengurus RT',
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary400,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.w),
            ),
            elevation: 2,
          ),
          onPressed: rtData.bankAccounts.isEmpty
              ? () {
                _launchWhatsApp(chairmanPhoneNumber);
              }
              : selectedAccountId == null ? null : () {
                  // print("selectedId: $selectedAccountId");
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PaymentScreen(bill: bill))
                  );
                },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10.h),
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
                              Text(bill.billName, style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: 4.h),
                              Text(
                                'Nominal: ${currencyFormatter.format(bill.amount)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          )
                      )
                    ],
                  )
              ),
              rtData.bankAccounts.isEmpty ?
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.credit_card_off_outlined , size: 125.w),
                    SizedBox(height: 10.h),
                    Text('Metode Pembayaran Belum Tersedia',
                        style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                    Text('Saat ini, Pengurus RT Anda belum menambahkan rekening bank '
                        'atau e-wallet untuk pembayaran online',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF74696D),
                        ),
                        textAlign: TextAlign.center),
                    Text('Silakan hubungi Pengurus RT untuk info lebih lanjut'
                        'atau untuk melakukan pembayaran tunai',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF74696D),
                        ),
                        textAlign: TextAlign.center)
                      ]
                  )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: rtData.bankAccounts.length,
                      itemBuilder: (context, index) {
                        final account = rtData.bankAccounts[index];
                        return _bankAccountContainer(context, account, selectedAccountId == account.id, ref);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    ),
            ],
          )
        ),
      ),
    );
  }
}