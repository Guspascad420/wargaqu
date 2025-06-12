import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/theme/app_colors.dart';

class AddBillsScreen extends ConsumerStatefulWidget {
  const AddBillsScreen({super.key});

  @override
  ConsumerState<AddBillsScreen> createState() => _AddBillsScreenState();
}

class _AddBillsScreenState extends ConsumerState<AddBillsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk setiap input
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDueDate;
  String? _selectedTargetGroup;

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
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _titleController,
                label: 'Nama Iuran',
                icon: Icons.title_rounded,
                hint: 'Contoh: Iuran Perbaikan Portal Masuk',
                validator: (value) =>
                value!.isEmpty ? 'Nama iuran tidak boleh kosong' : null,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _amountController,
                label: 'Nominal',
                icon: Icons.monetization_on_outlined,
                hint: 'Contoh: 25000',
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
                    fillColor: Colors.white,
                  ),
                  child: Text(
                    _selectedDueDate == null
                        ? 'Pilih tanggal...'
                        : DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDueDate!),
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: _selectedDueDate == null ? Colors.grey.shade700 : Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _descriptionController,
                label: 'Deskripsi (Opsional)',
                icon: Icons.notes_rounded,
                hint: 'Contoh: Dana untuk perbaikan portal...',
                maxLines: 3,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  label: Text(
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