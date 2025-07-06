import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/payment/payment_confirmation_details/payment_confirmation_details.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/providers/citizen_providers.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/rt_providers.dart';

import '../../../model/confirmation/confirmation_state.dart';

class PaymentConfirmationScreen extends ConsumerStatefulWidget {
  final UserModel user;
  final String paymentId;

  const PaymentConfirmationScreen({super.key, required this.user, required this.paymentId});

  @override
  ConsumerState<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends ConsumerState<PaymentConfirmationScreen> {
  final _rtNoteController = TextEditingController();

  @override
  void dispose() {
    _rtNoteController.dispose();
    super.dispose();
  }

  Widget _buildTransactionDetailsCard({
    required BuildContext context,
    required String residentName,
    required String address,
    required String billName,
    required int amount,
  }) {
    final currencyFormatter =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      elevation: 5.0,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pembayaran dari:',
              style: GoogleFonts.roboto(
                  fontSize: 14.sp, color: Colors.grey.shade600),
            ),
            Text(
              residentName,
              style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            Text(
              address,
              style: GoogleFonts.roboto(
                  fontSize: 14.sp, color: Colors.grey.shade700),
            ),
            const Divider(height: 24.0),
            Text(
              'Untuk Iuran:',
              style: GoogleFonts.roboto(
                  fontSize: 14.sp, color: Colors.grey.shade600),
            ),
            Text(
              billName,
              style:
              GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12.h),
            Text(
              'Jumlah Ditransfer:',
              style: GoogleFonts.roboto(
                  fontSize: 14.sp, color: Colors.grey.shade600),
            ),
            Text(
              currencyFormatter.format(amount),
              style: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProofOfPaymentSection({required BuildContext context, required String imageUrl}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bukti Pembayaran Terlampir',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: InteractiveViewer(
                  child: Image.network(imageUrl),
                ),
              ),
            );
          },
          child: Container(
            height: 250.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fitHeight,
              ),
            ),
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12.r),
                  topLeft: Radius.circular(12.r),
                ),
              ),
              child: Text(
                'Ketuk untuk perbesar',
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRtNoteField({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tambahkan Catatan (Opsional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _rtNoteController,
          maxLines: 2,
          decoration: InputDecoration(
              hintText: 'Misal: Bukti pembayaran kurang jelas...',
              filled: true,
              hintStyle: GoogleFonts.roboto(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500
              ),
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300)
              )
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncPaymentDetails = ref.watch(paymentDetailsProvider((user: widget.user, paymentId: widget.paymentId)));
    final rtData = ref.watch(rtDataProvider);
    final selectedBill = ref.watch(selectedBillProvider);
    final confirmationState = ref.watch(paymentConfirmationNotifierProvider);

    final isConfirming = confirmationState.isLoading && confirmationState.actionInProgress == ConfirmationAction.confirm;
    final isRejecting = confirmationState.isLoading && confirmationState.actionInProgress == ConfirmationAction.reject;

    ref.listen<ConfirmationState>(paymentConfirmationNotifierProvider, (prev, next) {
      if (next.errorMessage != null && prev?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alamak: ${next.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (prev?.isLoading == true && !next.isLoading && next.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Aksi berhasil diselesaikan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    });

    return asyncPaymentDetails.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
      data: (paymentDetail) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Konfirmasi Pembayaran',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTransactionDetailsCard(
                    context: context,
                    residentName: paymentDetail.name,
                    address: paymentDetail.address,
                    billName: paymentDetail.billName,
                    amount: paymentDetail.amount
                ),
                SizedBox(height: 24.h),
                _buildProofOfPaymentSection(
                  context: context,
                  imageUrl: paymentDetail.proofOfPaymentImageUrl,
                ),
                SizedBox(height: 24.h),
                _buildRtNoteField(context: context), // Input catatan RT
                SizedBox(height: 24.h),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: isRejecting
                        ? const SizedBox.shrink()
                        : const Icon(Icons.close_rounded),
                    label: isRejecting
                        ? const SizedBox.shrink()
                        : Text('TOLAK', style: GoogleFonts.roboto()),
                    onPressed: () {
                      final rtNote = _rtNoteController.text;
                      ref.read(paymentConfirmationNotifierProvider.notifier).executeRejectPayment(
                          userId: widget.user.id, billId: selectedBill!.id,
                          paymentId: widget.paymentId, rejectionReason: rtNote
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade700, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: isConfirming
                        ? const SizedBox.shrink() // Sembunyikan ikon saat loading
                        : const Icon(Icons.check_rounded),
                    label: isConfirming
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('KONFIRMASI', style: GoogleFonts.roboto()),
                    onPressed: () {
                      final rtNote = _rtNoteController.text;
                      ref.read(paymentConfirmationNotifierProvider.notifier).executeConfirmPayment(
                          userId: widget.user.id, billId: selectedBill!.id, billName: paymentDetail.billName, paymentId: widget.paymentId,
                          amountPaid: paymentDetail.amount, rtId: rtData!.id, rtNote: rtNote.isEmpty ? null : rtNote
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

}