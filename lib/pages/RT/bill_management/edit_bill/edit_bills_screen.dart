import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/bill/bill.dart';

import '../../../../components/bill_form.dart';
import '../../../../providers/providers.dart';
import '../../../../theme/app_colors.dart';

class EditBillsScreen extends ConsumerStatefulWidget {
  final Bill existingBill;
  const EditBillsScreen({super.key, required this.existingBill});

  @override
  ConsumerState<EditBillsScreen> createState() => _EditBillsScreenState();
}

class _EditBillsScreenState extends ConsumerState<EditBillsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data yang sudah ada
    _titleController = TextEditingController(text: widget.existingBill.billName);
    _amountController = TextEditingController(text: widget.existingBill.amount.toString());
    _descriptionController = TextEditingController(text: widget.existingBill.description ?? '');
    _selectedDueDate = widget.existingBill.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose(); _amountController.dispose(); _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDueDate
        ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDueDate) setState(() => _selectedDueDate = picked);
  }

  void _submitForm(String billId) {
    if (_formKey.currentState!.validate()) {
      if (_selectedDueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mohon pilih batas akhir pembayaran!')));
        return;
      }
      ref.read(billNotifierProvider.notifier).executeUpdateBill(
          billId: billId,
          billName: _titleController.text,
          amount: double.parse(_amountController.text),
          dueDate: _selectedDueDate!,
          description: _descriptionController.text
      );
      print("SUBMITTING NEW BILL...");
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(billNotifierProvider);

    ref.listen<AsyncValue<void>>(billNotifierProvider, (prev, next) {
      if (prev is AsyncLoading && !next.isLoading) {
        if (next.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${next.error}')),
          );

        } else if (next is AsyncData) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Iuran berhasil diperbarui!')),
          );
          Navigator.of(context).pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Iuran')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: BillForm(
          formKey: _formKey,
          titleController: _titleController,
          amountController: _amountController,
          descriptionController: _descriptionController,
          selectedDueDate: _selectedDueDate,
          onSelectDueDate: () => _selectDueDate(context),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: ElevatedButton(
          onPressed: () {
            _submitForm(widget.existingBill.id);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary400,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.w),
            ),
            elevation: 2,
          ),
          child: formState.isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Update Iuran',
                style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                ),
              )
        ),
      ),
    );
  }
}