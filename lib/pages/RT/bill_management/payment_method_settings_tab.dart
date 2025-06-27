import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/theme/app_colors.dart';

class PaymentMethodSettingsTab extends StatelessWidget {
  const PaymentMethodSettingsTab({super.key, required this.bankAccounts});

  final List<BankAccount> bankAccounts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            Text('Rekening Bank Resmi', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 10.h),
            bankAccounts.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, size: 120.h,),
                    Text('Belum Ada Rekening Bank Ditambahkan', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),
                    Text('Tekan tombol + di bawah untuk memulai', style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF74696D),
                    ), textAlign: TextAlign.center),
                  ],
                )
              : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final account = bankAccounts[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding( // Padding untuk konten di dalam InkWell
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Row(
                          children: [
                            Image.asset(account.logoAsset!, width: 50.w),
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
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    account.accountNumber,
                                    style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.grey.shade700),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'a/n ${account.accountHolderName}',
                                    style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemCount: bankAccounts.length
            ),
          ],
        ),
      )
    );
  }
}