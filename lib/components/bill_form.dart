import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BillForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final DateTime? selectedDueDate;
  final VoidCallback onSelectDueDate;

  const BillForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.amountController,
    required this.descriptionController,
    required this.selectedDueDate,
    required this.onSelectDueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TextField Nama Iuran
          TextFormField(
            controller: titleController,
            validator: (value) => value!.isEmpty ? 'Nama iuran tidak boleh kosong' : null,
            decoration: InputDecoration(
                labelText: 'Nama Iuran',
                prefixIcon: Icon(Icons.title_rounded),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface
            ),
          ),
          SizedBox(height: 16.h),

          // TextField Nominal
          TextFormField(
            controller: amountController,
            validator: (value) => value!.isEmpty ? 'Nominal tidak boleh kosong' : null,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                labelText: 'Nominal',
                prefixIcon: Icon(Icons.monetization_on_outlined),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface
            ),
          ),
          SizedBox(height: 16.h),

          // Pemilih Tanggal
          InkWell(
            onTap: onSelectDueDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Batas Akhir Pembayaran',
                labelStyle: GoogleFonts.roboto(color: Colors.grey),
                prefixIcon: Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface
              ),
              child: Text(
                selectedDueDate == null
                    ? 'Pilih tanggal...'
                    : DateFormat('d MMMM yyyy', 'id_ID').format(selectedDueDate!),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // TextField Deskripsi
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Deskripsi (Opsional)',
                prefixIcon: Icon(Icons.notes_rounded),
                filled: true, fillColor: Theme.of(context).colorScheme.surface),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}