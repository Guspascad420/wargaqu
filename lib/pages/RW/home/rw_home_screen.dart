import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/reusable_home_screen.dart';
import 'package:wargaqu/model/RW/rw_data.dart';
import 'package:wargaqu/pages/RW/rt_management/rt_management_screen.dart';
import 'package:wargaqu/providers/rw_providers.dart';

class RwHomeScreen extends ConsumerStatefulWidget {
  const RwHomeScreen({super.key, required this.rwData});

  final RwData rwData;

  @override
  ConsumerState<RwHomeScreen> createState() => _RwHomeScreenState();
}

class _RwHomeScreenState extends ConsumerState<RwHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncRwSummary = ref.watch(rwSummaryProvider);

    return SingleChildScrollView(
      child: ReusableHomeScreen(
          subtitle: asyncRwSummary.when(
            loading: () => 'Memuat data RW...',
            error: (err, stack) => 'Gagal memuat data',
            data: (summary) {
              return summary;
            },
          ),
          servicesWidgets: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RtManagementScreen())
                  );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF5D9BF8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Image.asset('images/group_chat.png', width: 140.w,),
                        SizedBox(height: 10.h),
                        Text('Manajemen Data RT', style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                      ],
                    )
                )
            )
          ]
      )
    );
  }

}