import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/pages/citizen/payment/payment_screen.dart';
import 'package:wargaqu/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/rt_providers.dart';

final selectedAccountIdProvider = StateProvider<String?>((ref) => 'Kas Tunai RT');

class BankAccountSelectionScreen extends ConsumerWidget {
  final BillType billType;
  final String title;
  final int amount;

  const BankAccountSelectionScreen({super.key, required this.billType, required this.title, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<BankAccount> bankAccounts = ref.watch(mockBankAccountsProvider);
    final String? selectedAccountId = ref.watch(selectedAccountIdProvider);
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h,),
            Text('Pilih Rekening Bank', style: Theme.of(context).textTheme.titleLarge),
            Text('Pilih metode pembayaran yang ingin ditransfer', style: Theme.of(context).textTheme.bodyLarge, maxLines: 2,),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.h),
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
                            Text(title, style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(height: 4.h),
                            Text(
                              'Nominal: ${currencyFormatter.format(amount)}',
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
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: bankAccounts.length,
                itemBuilder: (context, index) {
                  final account = bankAccounts[index];
                  final isSelected = selectedAccountId == account.id;
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
                },
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: Text(
                  'Selanjutnya',
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
                onPressed: selectedAccountId == null ? null : () {
                  final selectedAccount = bankAccounts.firstWhere(
                        (account) => account.id == selectedAccountId,
                  );
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PaymentScreen(selectedBankAccount: selectedAccount))
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}