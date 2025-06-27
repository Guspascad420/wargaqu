import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/user_providers.dart';
import '../../../../providers/rt_providers.dart';
import '../../../../theme/app_colors.dart';

class NewBankAccountForm extends ConsumerStatefulWidget {
  const NewBankAccountForm({super.key});

  @override
  ConsumerState<NewBankAccountForm> createState() => _NewBankAccountFormState();
}

class _NewBankAccountFormState extends ConsumerState<NewBankAccountForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBank;
  bool _didSubmit = false;

  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Key? key,
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
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final rtData = ref.watch(rtDataProvider);
    final bankList = ref.watch(bankListProvider);
    final formState = ref.watch(addNewBankAccountNotifierProvider);

    ref.listen<AsyncValue<void>>(addNewBankAccountNotifierProvider, (prev, next) {
      if (!_didSubmit) return;

      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );

      } else if (next is AsyncData<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data rekening baru berhasil disimpan!')),
        );
        Navigator.of(context).pop();
        setState(() {
          _didSubmit = false;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Rekening Bank',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownMenu<String>(
                initialSelection: _selectedBank,
                hintText: "Pilih Bank",
                width: MediaQuery.of(context).size.width * 0.75,
                requestFocusOnTap: false,
                onSelected: (String? bank) {
                  if (bank != null) {
                    setState(() {
                      _selectedBank = bank;
                    });
                  }
                },
                dropdownMenuEntries: bankList.map<DropdownMenuEntry<String>>((String bank) {
                  return DropdownMenuEntry<String>(
                    value: bank,
                    label: bank,
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
              SizedBox(height: 16.h),
              _buildTextField(
                key: const Key('accountNumberField'),
                context: context,
                controller: _accountNumberController,
                label: 'Nomor Rekening',
                icon: Icons.tag_rounded,
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Nomor Rekening tidak boleh kosong' : null,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                key: const Key('accountHolderField'),
                context: context,
                controller: _accountNumberController,
                label: 'Atas Nama',
                icon: Icons.tag_rounded,
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Nama pemilik rekening tidak boleh kosong' : null,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: const Key('submitButton'),
                  label: formState.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
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
                      ref.read(addNewBankAccountNotifierProvider.notifier).executeAddNewBankAccount(
                          rtId: rtData!.id,
                          bankName: _selectedBank!,
                          accountNumber: _accountNumberController.text,
                          accountHolderName: _accountHolderController.text
                      );
                    }
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }

}