import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

import '../../../components/bill_form.dart';
import '../../../providers/rt_providers.dart';

class AddBillsScreen extends ConsumerStatefulWidget {
  const AddBillsScreen({super.key, required this.billType});

  final BillType billType;

  @override
  ConsumerState<AddBillsScreen> createState() => _AddBillsScreenState();
}

class _AddBillsScreenState extends ConsumerState<AddBillsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;

  @override
  void dispose() {
    _titleController.dispose(); _amountController.dispose(); _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDueDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDueDate) setState(() => _selectedDueDate = picked);
  }

  void _submitForm(String rtId) {
    if (_formKey.currentState!.validate()) {
      if (_selectedDueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mohon pilih batas akhir pembayaran!')));
        return;
      }
      ref.read(billNotifierProvider.notifier).executeNewBill(
          rtId: rtId,
          billName: _titleController.text,
          billType: widget.billType,
          amount: double.parse(_amountController.text),
          dueDate: _selectedDueDate!,
          description: _descriptionController.text
      );
      print("SUBMITTING NEW BILL...");
    }
  }

  @override
  Widget build(BuildContext context) {
    final rtData = ref.watch(rtDataProvider);
    final formState = ref.watch(billNotifierProvider);

    ref.listen<AsyncValue<void>>(billNotifierProvider, (prev, next) {
      if (prev is AsyncLoading && !next.isLoading) {
        if (next.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${next.error}')),
          );

        } else if (next is AsyncData) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data iuran baru berhasil disimpan!')),
          );
          Navigator.of(context).pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Iuran Baru')),
      body: SingleChildScrollView( // <-- Pake SingleChildScrollView biar gak overflow
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
        child: ElevatedButton.icon(
            label: formState.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  'Simpan',
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
            onPressed: () {
              _submitForm(rtData!.id);
            }
        )
      ),
    );
  }

}