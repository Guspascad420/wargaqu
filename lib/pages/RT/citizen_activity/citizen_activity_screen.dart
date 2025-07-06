import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wargaqu/pages/RT/citizen_activity/bill_selector.dart';
import 'package:wargaqu/pages/RT/citizen_activity/citizen_status_graph.dart';
import 'package:wargaqu/pages/RT/citizen_activity/persistent_header_delegate.dart';
import 'package:wargaqu/pages/RT/citizen_activity/profile/citizen_profile_screen.dart';
import 'package:wargaqu/pages/RT/citizen_activity/search_and_filter_section.dart';
import 'package:wargaqu/providers/citizen_providers.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/theme/app_colors.dart';
import '../../../model/bill/bill.dart';
import '../../../model/citizen/citizen_with_status.dart';
import '../../../providers/rt_providers.dart';
import '../confirm_payment/payment_confirmation_screen.dart';

class CitizenActivityScreen extends ConsumerWidget {
  const CitizenActivityScreen({super.key});

  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          margin: EdgeInsets.only(left: 15.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color? backgroundColor;
    Color? textColor;
    String? label;

    switch (status) {
      case 'lunas':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'LUNAS';
        break;
      case 'belum_bayar':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        label = 'BELUM BAYAR';
        break;
      case 'ditolak':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        label = 'DITOLAK';
        break;
      case 'perlu_konfirmasi':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        label = 'PERLU KONFIRMASI';
        break;
    }

    return Chip(
      label: Text(
        label!,
        style: GoogleFonts.roboto(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      backgroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }

  Future<bool> _showConfirmCashPaymentDialog(BuildContext context, String name, String bill, int amount) async {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 24.sp),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Konfirmasi Pembayaran Tunai', style: GoogleFonts.roboto(fontSize: 17.sp,
                    fontWeight: FontWeight.w600))
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anda yakin ingin menandai pembayaran berikut sebagai LUNAS (via tunai)?',
                style: GoogleFonts.roboto(fontSize: 13.sp),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nama',
                          style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          name,
                          style: GoogleFonts.roboto(fontSize: 13.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Iuran',
                          style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          bill,
                          style: GoogleFonts.roboto(fontSize: 13.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nominal',
                          style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          currencyFormatter.format(amount),
                          style: GoogleFonts.roboto(fontSize: 13.sp),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: AppColors.negative)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.positive,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.w),
                  )
              ),
              child: Text('Ya, Tandai Lunas', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<bool> _showReactivateDialog(BuildContext context, String name, String bill, int amount) async {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 24.sp),
              const SizedBox(width: 10),
              Expanded(
                  child: Text('Konfirmasi Pengaktifan Ulang', style: GoogleFonts.roboto(fontSize: 17.sp,
                      fontWeight: FontWeight.w600))
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anda yakin ingin mengaktifkan pembayaran ini dan menandai sebagai LUNAS?',
                style: GoogleFonts.roboto(fontSize: 13.sp),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nama',
                          style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          name,
                          style: GoogleFonts.roboto(fontSize: 13.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Iuran',
                          style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          bill,
                          style: GoogleFonts.roboto(fontSize: 13.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nominal',
                          style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          currencyFormatter.format(amount),
                          style: GoogleFonts.roboto(fontSize: 13.sp),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: AppColors.negative)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.positive,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.w),
                  )
              ),
              child: Text('Ya, Tandai Lunas', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  List<Widget> _buildMenuItems(WidgetRef ref, BuildContext context, CitizenWithStatus citizen,
      String selectedBillId, String billName, int amount) {
    List<Widget> menuItems = [];

    if (citizen.paymentStatus == 'belum_bayar') {
      menuItems.add(
        MenuItemButton(
          onPressed: () async {
            final bool shouldConfirm = await _showConfirmCashPaymentDialog(context, citizen.user.fullName, billName, amount);
            if (shouldConfirm) {
              await ref.read(paymentConfirmationNotifierProvider.notifier)
                  .executeConfirmCashPayment(
                  userId: citizen.user.id, billId: selectedBillId, billName: billName,
                  amountPaid: amount, rtId: citizen.user.rtId!
              );
            }
          },
          leadingIcon: const Icon(Icons.payments_outlined),
          child: const Text('Tandai Bayar Tunai'),
        ),
      );
      menuItems.add(
        MenuItemButton(
          onPressed: () {
            String? phoneNumber = citizen.user.phoneNumber;
            if (phoneNumber == null) {
              return;
            }

            if (!phoneNumber.startsWith('0')) {
              phoneNumber = '62${phoneNumber.substring(1)}';
            }
            final url = 'https://wa.me/$phoneNumber';
            launchUrl(Uri.parse(url));
          },
          leadingIcon: const Icon(Icons.chat_bubble_outline_rounded),
          child: const Text('Ingatkan via WA'),
        ),
      );
    }

    if (citizen.paymentStatus  == 'perlu_konfirmasi') {
      menuItems.add(
        MenuItemButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PaymentConfirmationScreen(
                  user: citizen.user,
                  paymentId: citizen.user.billsStatus[selectedBillId]['paymentId']!,
                ),
            ));
          },
          leadingIcon: const Icon(Icons.check_circle_outline_rounded),
          child: const Text('Konfirmasi Pembayaran'),
        ),
      );
    }

    if (citizen.paymentStatus == 'ditolak') {
      menuItems.add(
        MenuItemButton(
          onPressed: () async {
            final bool shouldConfirm = await _showReactivateDialog(context, citizen.user.fullName, billName, amount);
            if (shouldConfirm) {
              await ref.read(paymentConfirmationNotifierProvider.notifier)
                  .executeConfirmPayment(
                  userId: citizen.user.id, billId: selectedBillId, billName: billName,
                  amountPaid: amount, rtId: citizen.user.rtId!,
                  paymentId: citizen.user.billsStatus[selectedBillId]['paymentId']!
              );
            }
          },
          leadingIcon: const Icon(Icons.check_circle_outline_rounded),
          child: const Text('Aktifkan ulang pembayaran'),
        ),
      );
    }

    menuItems.add(const Divider());
    menuItems.add(
      MenuItemButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CitizenProfileScreen(
                  user: citizen.user,
                ),
              ));
        },
        leadingIcon: const Icon(Icons.person_outline_rounded),
        child: const Text('Lihat Profil Lengkap'),
      ),
    );

    if (citizen.paymentStatus == 'lunas') {
      menuItems.add(
        MenuItemButton(
          onPressed: () => print('Tampilkan dialog bukti bayar ${citizen.user.fullName}'),
          leadingIcon: const Icon(Icons.receipt_long_outlined),
          child: const Text('Lihat Bukti Bayar'),
        ),
      );
    }
    return menuItems;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtData = ref.watch(rtDataProvider);
    final asyncAllBills = ref.watch(allBillsProvider(rtData!.id));
    final asyncFilteredList = ref.watch(filteredCitizenListProvider(rtData.id));
    final Bill? selectedBill = ref.watch(selectedBillProvider);

    ref.listenManual(allBillsProvider(rtData.id), (previous, next) {
      if (next.hasValue && next.value != null && next.value!.isNotEmpty) {
        if (ref.read(selectedBillProvider) == null) {
          ref.read(selectedBillProvider.notifier).state = next.value!.first;
          ref.read(billTypeProvider.notifier).state = next.value!.first.billType;
          debugPrint('Set initial selected bill: ${next.value!.first}');
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pantau Aktivitas & Profil Warga',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: asyncAllBills.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Text('Error: $error'),
              data: (bills) {
                if (bills.isEmpty) {
                  return Center(
                    child: Text('Tidak ada data.'),
                  );
                }
                return Column(
                        children: [
                          BillSelector(),
                          CitizenStatusGraph(),
                        ],
                      );
              },
            ),
          ),
          SliverPersistentHeader(
            delegate: MyPersistentHeaderDelegate(
              height: 100.h,
              child: SearchAndFilterSection()
            ),
            pinned: true,
          ),
          asyncFilteredList.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) {
              debugPrint(stackTrace.toString());
              return SliverFillRemaining(
                child: Center(
                  child: Text('Error: $error'),
                ),
              );
            },
            data: (citizensWithStatus) {
              if (citizensWithStatus.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('Tidak ada data tersedia.'),
                  ),
                );
              }
              return SliverList.builder(
                itemCount: citizensWithStatus.length,
                itemBuilder: (context, index) {
                  final item = citizensWithStatus[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row( // <-- Pake Row sebagai fondasi utama
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(Icons.person_outline_rounded, color: Colors.white),
                            ),
                            SizedBox(width: 12.w),

                            Expanded( // <-- Dibungkus Expanded biar dia ngambil semua sisa ruang
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.user.fullName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    item.user.address,
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6.h),
                                  _buildStatusChip(item.paymentStatus),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            MenuAnchor(
                              builder: (context, controller, child) {
                                return InkWell(
                                  onTap: () {
                                    if (controller.isOpen) {
                                      controller.close();
                                    } else {
                                      controller.open();
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Icon(Icons.more_vert, color: Colors.grey.shade600),
                                );
                              },
                              menuChildren: _buildMenuItems(ref, context, item, selectedBill!.id,
                                  selectedBill.billName, selectedBill.amount),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      )
    );
  }
}