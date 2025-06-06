import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum TransactionType { expense, income }
final transactionTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.expense);

class TransactionTabView extends ConsumerWidget{
  const TransactionTabView({super.key});

  AlignmentGeometry _getAlignment(TransactionType globallySelectedType) {
    switch (globallySelectedType) {
      case TransactionType.expense:
        return Alignment.centerLeft;
      case TransactionType.income:
        return Alignment.centerRight;
    }
  }

  TextStyle _getTextStyle(BuildContext context, TransactionType currentTabType, // The type of the tab being styled
      TransactionType globallySelectedType,) {
    bool isSelected = globallySelectedType == currentTabType;
    return GoogleFonts.roboto(
      fontSize: 14.sp,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      color: isSelected ? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.onSurface,
    );
  }

  Widget _buildTabItem(BuildContext context, WidgetRef ref, String label, TransactionType type,
      TransactionType globallySelectedType) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(transactionTypeProvider.notifier).state = type;
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Text(
              label,
              style: _getTextStyle(context, type, globallySelectedType),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(transactionTypeProvider);
    final Color backgroundColor = Colors.grey.shade800;
    final double borderRadius = 12.r;

    return Container(
      height: 40.h, // Sesuaikan tinggi keseluruhan
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double sliderWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              // 1. Slider putih yang bisa bergeser
              AnimatedAlign(
                alignment: _getAlignment(selectedType),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: Container(
                  width: sliderWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),
              // 2. Teks label yang ada di atas slider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTabItem(context, ref, 'Expense', TransactionType.expense, selectedType),
                  _buildTabItem(context, ref, 'Income', TransactionType.income, selectedType),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}