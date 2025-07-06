import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/providers/providers.dart';

import '../../../providers/citizen_providers.dart';

class SearchAndFilterSection extends ConsumerWidget {
  const SearchAndFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(filterStatusProvider);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            height: 40.h,
            child: TextField(
              onChanged: (query) {
                ref.read(citizenSearchQueryProvider.notifier).state = query;
              },
              decoration: InputDecoration(
                hintText: 'Cari nama warga...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          // 2. Filter Chips
          SizedBox(
            height: 32.h,
            child: ListView( // Pake ListView biar bisa scroll horizontal kalo filter banyak
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 15.w),
                ChoiceChip(label: const Text('Semua'), onSelected: (b) {
                  ref.read(filterStatusProvider.notifier).state = 'semua';
                }, selected: selectedStatus == 'semua'),
                SizedBox(width: 8.w),
                ChoiceChip(label: const Text('Lunas'), onSelected: (b) {
                  ref.read(filterStatusProvider.notifier).state = 'lunas';
                }, selected: selectedStatus == 'lunas'),
                SizedBox(width: 8.w),
                ChoiceChip(label: const Text('Belum Bayar'), onSelected: (b) {
                  ref.read(filterStatusProvider.notifier).state = 'belum_bayar';
                }, selected: selectedStatus == 'belum_bayar'),
                SizedBox(width: 8.w),
                ChoiceChip(label: const Text('Perlu Konfirmasi'), onSelected: (b) {
                  ref.read(filterStatusProvider.notifier).state = 'perlu_konfirmasi';
                }, selected: selectedStatus == 'perlu_konfirmasi'),
                SizedBox(width: 8.w),
                ChoiceChip(label: const Text('Ditolak'), onSelected: (b) {
                  ref.read(filterStatusProvider.notifier).state = 'ditolak';
                }, selected: selectedStatus == 'ditolak'),
                SizedBox(width: 15.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

}