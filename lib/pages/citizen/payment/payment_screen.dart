import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:path/path.dart' as path;
import 'package:wargaqu/pages/citizen/payment/success/payment_success_screen.dart';
import 'package:wargaqu/theme/app_colors.dart';

final paymentProofImageProvider = StateProvider<File?>((ref) => null);

class PaymentScreen extends ConsumerStatefulWidget {
  final BankAccount selectedBankAccount;

  const PaymentScreen({super.key, required this.selectedBankAccount});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Kompresi sedikit biar gak kegedean
      );

      if (pickedFile != null) {
        ref.read(paymentProofImageProvider.notifier).state = File(pickedFile.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih gambar: $e')),
      );
    }
  }

  void _showImageSourceDialog(BuildContext context, File? currentImageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Pilih Sumber Gambar', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    const Icon(Icons.photo_library_rounded, color: AppColors.primary90),
                    SizedBox(width: 10.w),
                    Text('Pilih dari Galeri', style: GoogleFonts.roboto(fontSize: 15.sp)),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt_rounded, color: Colors.blueAccent),
                    SizedBox(width: 10.w),
                    Text('Ambil Foto dari Kamera', style: GoogleFonts.roboto(fontSize: 15.sp)),
                  ],
                ),
              ),
            ),
            if (currentImageFile != null)
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(paymentProofImageProvider.notifier).state = null;
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, color: Colors.red.shade600),
                      SizedBox(width: 10.w),
                      Text('Hapus Gambar', style: GoogleFonts.roboto(fontSize: 15.sp, color: Colors.red.shade600)),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = ref.watch(paymentProofImageProvider);
    final String? fileName = imageFile != null ? path.basename(imageFile.path) : null;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80.h,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h,),
              Text('Lakukan Pembayaran', style: Theme.of(context).textTheme.titleLarge),
              Text('Lakukan pembayaran pada rekening bank berikut', style: Theme.of(context).textTheme.bodyLarge, maxLines: 2,),
            ],
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Row(
                          children: [
                            Image.asset(widget.selectedBankAccount.logoAsset, width: 50.w),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.selectedBankAccount.bankName,
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    widget.selectedBankAccount.accountNumber,
                                    style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.grey.shade700),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'a/n ${widget.selectedBankAccount.accountHolderName}',
                                    style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text('Unggah Bukti Pembayaran', style: Theme.of(context).textTheme.titleLarge),
                Text('Mohon untuk mencantumkan bukti pembayaran', style: Theme.of(context).textTheme.bodyLarge, maxLines: 2,),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () => _showImageSourceDialog(context, imageFile),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: Theme.of(context).colorScheme.onSurface, // Warna border putus-putus
                      strokeWidth: 1.5, // Ketebalan border
                      dashPattern: const [6, 5],
                      radius: Radius.circular(12.r), // Radius untuk RRect
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: imageFile != null && fileName != null ? 80.h : 180.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade100 : Colors.black,
                        borderRadius: BorderRadius.circular(11.r),
                      ),
                      child: imageFile != null && fileName != null
                          ? Padding( // Padding untuk konten di dalam
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_rounded, // Ikon gambar
                              size: 40.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                fileName, // Tampilkan nama file
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis, // Jika nama file terlalu panjang
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 50.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Ketuk untuk memilih gambar',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '(JPG, PNG, maks. 5MB)',
                            style: GoogleFonts.roboto(
                              fontSize: 11.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    label: Text(
                      'Konfirmasi Bukti Pembayaran',
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
                    onPressed: imageFile == null ? null : () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PaymentSuccessScreen(
                            amount: 20000,
                            destinationBank: widget.selectedBankAccount.bankName,
                            transactionDate: DateTime.now(),
                          ))
                      );
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: AppColors.primary90, width: 1.5.w), // Lebar border dengan .w
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Ganti Metode Pembayaran',
                      textAlign: TextAlign.center, // Menambahkan text align center
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp, // Ukuran font disesuaikan
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary90,
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }
}