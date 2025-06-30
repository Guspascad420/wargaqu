import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/payment/payment_confirmation_details/payment_confirmation_details.dart';
import 'package:wargaqu/pages/RT/citizen_activity/bill_selector.dart';
import 'package:wargaqu/pages/RT/citizen_activity/citizen_status_graph.dart';
import 'package:wargaqu/pages/RT/citizen_activity/persistent_header_delegate.dart';
import 'package:wargaqu/pages/RT/citizen_activity/profile/citizen_profile_screen.dart';
import 'package:wargaqu/pages/RT/citizen_activity/search_and_filter_section.dart';
import 'package:wargaqu/providers/citizen_providers.dart';
import 'package:wargaqu/providers/providers.dart';
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

  List<Widget> _buildMenuItems(BuildContext context, CitizenWithStatus citizen) {
    List<Widget> menuItems = [];

    if (citizen.paymentStatus == 'belum_bayar') {
      menuItems.add(
        MenuItemButton(
          onPressed: () {

          },
          leadingIcon: const Icon(Icons.payments_outlined),
          child: const Text('Tandai Bayar Tunai'),
        ),
      );
      menuItems.add(
        MenuItemButton(
          onPressed: () {

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
                  paymentId: citizen.user.billsStatus['paymentId']!,
                ),
            ));
          },
          leadingIcon: const Icon(Icons.check_circle_outline_rounded),
          child: const Text('Konfirmasi Pembayaran'),
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
    final asyncAllBills = ref.watch(allBillsProvider);
    final asyncFilteredList = ref.watch(filteredCitizenListProvider(rtData!.id));

    ref.listenManual(allBillsProvider, (previous, next) {
      if (next.hasValue && next.value != null && next.value!.isNotEmpty) {
        if (ref.read(selectedBillProvider) == null) {
          ref.read(selectedBillProvider.notifier).state = next.value!.first;
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
            error: (error, stackTrace) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $error'),
              ),
            ),
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
                              menuChildren: _buildMenuItems(context, item),
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