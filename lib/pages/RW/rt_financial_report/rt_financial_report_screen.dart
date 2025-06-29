import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/pages/RT/financial_report/financial_report_screen.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

class RtFinancialReportScreen extends ConsumerWidget {
  const RtFinancialReportScreen({super.key});

  Widget rtItemCard(BuildContext context, String rtId, String rtName) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => FinancialReportScreen(rtId: rtId)
            )
        );
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.w),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(rtName, style: Theme.of(context).textTheme.titleMedium),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rwId = ref.watch(currentRwIdProvider);
    final asyncRtList = ref.watch(rtListStreamProvider(rwId!));

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Laporan Keuangan Tiap RT', style: Theme.of(context).textTheme.titleLarge),
              Text(
                'Berikut adalah laporan keuangan dari RT-RT yang terhubung dengan Anda',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 15.h,),
              SizedBox(
                height: 50.h,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari nama RT...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              asyncRtList.when(
                error: (err, stack) {
                  print(stack);
                  return Center(child: Text('Error: $err'));
                },
                loading: () {
                  return CircularProgressIndicator();
                },
                data: (rtList) {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final rtData = rtList[index];
                        return rtItemCard(context, rtData.id, rtData.rtName);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemCount: rtList.length
                  );
                }
              )
            ]
        )
      )
    );
  }
}