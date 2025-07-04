import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/providers/providers.dart';

import '../../../providers/rt_providers.dart';

class BillSelector extends ConsumerWidget {
  const BillSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtData = ref.watch(rtDataProvider);
    final selectedBillType = ref.watch(billTypeProvider);
    final asyncBills = ref.watch(allBillsProvider(rtData!.id));
    final Bill? selectedBill = ref.watch(selectedBillProvider);
    final availableBills = ref.watch(availableBillsProvider(rtData.id));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih tipe iuran:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // Or spaceEvenly, etc.
            children: <Widget>[
              if (asyncBills.value!.any((bill) => bill.billType == BillType.regular))
                ChoiceChip(
                  label: Text("Bulanan", style: GoogleFonts.roboto()),
                  selected: selectedBillType == BillType.regular,
                  checkmarkColor: Colors.white,
                  onSelected: (bool selected) {
                    if (selected) {
                      ref.read(billTypeProvider.notifier).state = BillType.regular;
                      final newAvailableBills = ref.watch(availableBillsProvider(rtData.id));
                      ref.read(selectedBillProvider.notifier).state = newAvailableBills.isNotEmpty ? newAvailableBills.first : null;
                    }
                  },
                  // Optional: Add styling
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: selectedBillType == BillType.regular
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface
                  ),
              ),
              SizedBox(width: 10.w),
              if (asyncBills.value!.any((bill) => bill.billType == BillType.incidental))// Spacing between chips
                ChoiceChip(
                  label: Text("Khusus", style: GoogleFonts.roboto()),
                  selected: selectedBillType == BillType.incidental,
                  checkmarkColor: Colors.white,
                  onSelected: (bool selected) {
                    if (selected) {
                      ref.read(billTypeProvider.notifier).state = BillType.incidental;
                      final newAvailableBills = ref.watch(availableBillsProvider(rtData.id));
                      ref.read(selectedBillProvider.notifier).state = newAvailableBills.isNotEmpty ? newAvailableBills.first : null;
                    }
                  },
                  // Optional: Add styling
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: selectedBillType == BillType.incidental
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface
                  ),
                ),
            ],
          ),
          SizedBox(height: 15.h),
          DropdownMenu<Bill>(
            initialSelection: selectedBill,
            hintText: "Pilih Iuran",
            width: MediaQuery.of(context).size.width * 0.75,
            requestFocusOnTap: false,
            onSelected: (Bill? bill) {
              if (bill != null) {
                ref.read(selectedBillProvider.notifier).state = bill;
              }
            },
            dropdownMenuEntries: availableBills.map<DropdownMenuEntry<Bill>>((Bill bill) {
              return DropdownMenuEntry<Bill>(
                value: bill, // The actual Bill object as the value for this entry
                label: bill.billName, // The text to display for this entry in the list
              );
            }).toList(),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.surface),
              surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
              elevation: WidgetStateProperty.all<double>(3.0),
            ),
          ),
        ],
      ),
    );
  }

}