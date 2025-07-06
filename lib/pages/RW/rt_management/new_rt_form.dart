import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

class NewRtForm extends ConsumerStatefulWidget {
  const NewRtForm({super.key});

  @override
  ConsumerState<NewRtForm> createState() => _NewRtFormState();
}

class _NewRtFormState extends ConsumerState<NewRtForm> {
  final _formKey = GlobalKey<FormState>();

  bool _didSubmit = false;

  final _rtNumberController = TextEditingController();
  final _rtNameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _rtNumberController.dispose();
    _rtNameController.dispose();
    _addressController.dispose();
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
    final rwId = ref.watch(currentRwIdProvider);
    final formState = ref.watch(rtCreationNotifierProvider);

    ref.listen<AsyncValue<void>>(rtCreationNotifierProvider, (prev, next) {
      if (!_didSubmit) return;

      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );

      } else if (next is AsyncData<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data RT baru berhasil disimpan!')),
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
          'Tambah Data RT Baru',
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
                _buildTextField(
                  key: const Key('rtNumberField'),
                  context: context,
                  controller: _rtNumberController,
                  label: 'Nomor RT',
                  icon: Icons.tag_rounded,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? 'Nomor RT tidak boleh kosong' : null,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  key: const Key('rtNameField'),
                  context: context,
                  controller: _rtNameController,
                  label: 'Nama Wilayah/Blok RT',
                  icon: Icons.maps_home_work_outlined,
                  validator: (value) =>
                  value!.isEmpty ? 'Nama Wilayah/Blok RT tidak boleh kosong' : null,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  key: const Key('addressField'),
                  context: context,
                  controller: _addressController,
                  label: 'Alamat Sekretariat RT',
                  icon: Icons.location_on_outlined,
                  validator: (value) =>
                  value!.isEmpty ? 'Alamat Sekretariat RT tidak boleh kosong' : null,
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
                        ref.read(rtCreationNotifierProvider.notifier).executeAddNewRt(
                            rtNumber: int.parse(_rtNumberController.text),
                            rtName: _rtNameController.text, rwId: rwId!,
                            address: _addressController.text
                        );
                      }
                    },
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}