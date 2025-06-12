import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/reusable_home_screen.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/RW/rw_data.dart';
import 'package:wargaqu/pages/RW/citizen_list/rw_citizen_screen.dart';

class RwHomeScreen extends ConsumerStatefulWidget {
  const RwHomeScreen({super.key, required this.rwData, required this.rtDataList});

  final RwData rwData;
  final List<RtData> rtDataList;

  @override
  ConsumerState<RwHomeScreen> createState() => _RwHomeScreenState();
}

class _RwHomeScreenState extends ConsumerState<RwHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ReusableHomeScreen(
          subtitle: '{Name_RW} telah memiliki {jumlah_rt_terhubung} yang terhubung',
          servicesWidgets: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RwCitizenScreen(rtDataList: widget.rtDataList))
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
                        Text('Pantau Profil Warga', style: GoogleFonts.roboto(
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