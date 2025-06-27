import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:segmented_progress_bar/segmented_progress_bar.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/model/payment/payment_confirmation_details.dart';
import 'package:wargaqu/pages/RT/citizen_activity/bill_selector.dart';
import 'package:wargaqu/pages/RT/citizen_activity/citizen_activity_screen.dart';
import 'package:wargaqu/pages/RT/citizen_activity/citizen_status_graph.dart';
import 'package:wargaqu/pages/RT/citizen_activity/persistent_header_delegate.dart';
import 'package:wargaqu/pages/RT/citizen_activity/profile/citizen_profile_screen.dart';
import 'package:wargaqu/pages/RT/citizen_activity/search_and_filter_section.dart';
import 'package:wargaqu/pages/RT/confirm_payment/payment_confirmation_screen.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

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


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<ProgressSegment> socialSegments = [
      ProgressSegment(value: 5, color: AppColors.positive, label: '50%',
          labelTextStyle: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface
          )
      ),
      ProgressSegment(
          value: 3, color: Colors.indigo, label: '30%', isAbove: true,
          labelTextStyle: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface
          )
      ),
      ProgressSegment(
          value: 2, color: AppColors.negative, label: '20%',
          labelTextStyle: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface
          )
      ),
    ];

    final paymentDetailBudi = PaymentConfirmationDetails(
      paymentId: 'pym_juni_001',
      residentName: 'Nyoman Ayu Carmenita',
      address: 'Blok C-12, Griya Asri',
      billName: 'Iuran Keamanan - Juni 2025',
      amount: 50000,
      proofOfPaymentImageUrl: 'https://i.imgur.com/8pL4kG6.png', // Contoh URL gambar struk
    );

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
            child: BillSelector()
          ),
          SliverToBoxAdapter(
            child: CitizenStatusGraph(socialSegments: socialSegments)
          ),
          SliverPersistentHeader(
            delegate: MyPersistentHeaderDelegate(
              height: 100.h,
              child: SearchAndFilterSection()
            ),
            pinned: true,
          ),
          SliverList.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>
                          PaymentConfirmationScreen(details: paymentDetailBudi))
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('Warga ke-${index + 1}'),
                  subtitle: const Text('Blok A-12'),
                ),
              );
            },
          ),
        ],
      )
    );
  }
}