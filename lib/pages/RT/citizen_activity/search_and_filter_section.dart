import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchAndFilterSection extends StatelessWidget {
  const SearchAndFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
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
          // 1. Search Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            height: 40.h,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama warga...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
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
                FilterChip(label: const Text('Semua'), onSelected: (b){}),
                SizedBox(width: 8.w),
                FilterChip(label: const Text('Lunas'), onSelected: (b){}, selected: true),
                SizedBox(width: 8.w),
                FilterChip(label: const Text('Belum Bayar'), onSelected: (b){}),
                SizedBox(width: 8.w),
                FilterChip(label: const Text('Perlu Konfirmasi'), onSelected: (b){}),
                SizedBox(width: 15.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

}