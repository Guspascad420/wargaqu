import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

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

  bool _didSubmit = false;

  DateTime? _selectedDueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      helpText: 'Pilih Batas Akhir Pembayaran',
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Widget _buildTextField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      style: GoogleFonts.roboto(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rtData = ref.watch(rtDataProvider);
    final formState = ref.watch(billCreationNotifierProvider);

    ref.listen<AsyncValue<void>>(billCreationNotifierProvider, (prev, next) {
      if (!_didSubmit) return;

      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );

      } else if (next is AsyncData<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data iuran baru berhasil disimpan!')),
        );
        Navigator.of(context).pop();
        setState(() {
          _didSubmit = false;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Iuran Baru', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                key: const Key('titleField'),
                controller: _titleController,
                label: 'Nama Iuran',
                icon: Icons.title_rounded,
                validator: (value) =>
                value!.isEmpty ? 'Nama iuran tidak boleh kosong' : null,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                key: const Key('amountField'),
                controller: _amountController,
                label: 'Nominal',
                icon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                value!.isEmpty ? 'Nominal tidak boleh kosong' : null,
              ),
              SizedBox(height: 16.h),
              InkWell(
                onTap: () => _selectDueDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Batas Akhir Pembayaran',
                    prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  child: Text(
                    _selectedDueDate == null
                        ? 'Pilih tanggal...'
                        : DateFormat('d MMMM yyyy').format(_selectedDueDate!),
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: _selectedDueDate == null ? Colors.grey.shade400 : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                key: const Key('descriptionField'),
                controller: _descriptionController,
                label: 'Deskripsi (Opsional)',
                icon: Icons.notes_rounded,
                maxLines: 3,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
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
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _didSubmit = true;
                      });
                      ref.read(billCreationNotifierProvider.notifier).executeNewBill(
                          rtId: rtData!.id,
                          billName: _titleController.text,
                          billType: widget.billType,
                          amount: double.parse(_amountController.text),
                          dueDate: _selectedDueDate!,
                          description: _descriptionController.text
                      );
                    }
                  },
                ),
              )
            ],
          )
        ),
      ),
    );
  }

}