import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';

final billTypeProvider = StateProvider<BillType>((ref) => BillType.regular);
final availableBillsProvider = Provider<List<Bill>>((ref) {
  return [
    Bill(id: '1', billName: 'Iuran Januari 2025', billType: BillType.regular,
        createdBy: 'Admin', amount: 50.0, dueDate: DateTime.now().add(const Duration(days: 10)),
        paymentMethod: 'Card', paymentStatus: 'Pending'),
    Bill(id: '2', billName: 'Iuran Februari 2025', billType: BillType.regular,
        createdBy: 'Admin', amount: 75.0, dueDate: DateTime.now().add(const Duration(days: 5)),
        paymentMethod: 'Bank Transfer', paymentStatus: 'Pending'),
    Bill(id: '3', billName: 'Iuran perbaikan portal', billType: BillType.incidental,
        createdBy: 'Admin', amount: 30.0, dueDate: DateTime.now().add(const Duration(days: 15)),
        paymentMethod: 'Card', paymentStatus: 'Paid'),
  ];
});
final selectedBillProvider = StateProvider<Bill?>((ref) => null);

class BillSelector extends ConsumerWidget {
  const BillSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBillType = ref.watch(billTypeProvider);
    final List<Bill> availableBills = ref.watch(availableBillsProvider);
    final Bill? selectedBill = ref.watch(selectedBillProvider);

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
              ChoiceChip(
                label: Text("Bulanan", style: GoogleFonts.roboto()),
                selected: selectedBillType == BillType.regular,
                checkmarkColor: Colors.white,
                onSelected: (bool selected) {
                  if (selected) {
                    ref.read(billTypeProvider.notifier).state = BillType.regular;
                  }
                },
                // Optional: Add styling
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: selectedBillType == BillType.regular
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 10.w), // Spacing between chips
              ChoiceChip(
                label: Text("Khusus", style: GoogleFonts.roboto()),
                selected: selectedBillType == BillType.incidental,
                checkmarkColor: Colors.white,
                onSelected: (bool selected) {
                  if (selected) {
                    ref.read(billTypeProvider.notifier).state = BillType.incidental;
                  }
                },
                // Optional: Add styling
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: selectedBillType == BillType.incidental
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
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