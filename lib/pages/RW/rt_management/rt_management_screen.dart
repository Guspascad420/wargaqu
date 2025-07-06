import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/rt_item_card.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/pages/RW/rt_management/new_rt_form.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

import '../../../theme/app_colors.dart';

class RtManagementScreen extends ConsumerStatefulWidget{
  const RtManagementScreen({super.key});

  @override
  ConsumerState<RtManagementScreen> createState() => _RwCitizenScreenState();
}

class _RwCitizenScreenState extends ConsumerState<RtManagementScreen> {
  final TextEditingController rtController = TextEditingController();
  RtData? selectedRt;

  @override
  void dispose() {
    rtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rwId = ref.watch(currentRwIdProvider);
    final asyncRtList = ref.watch(rtListStreamProvider(rwId!));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manajemen Data RT',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewRtForm())
          );
        },
        label: Text('Tambah Data RT Baru', style: GoogleFonts.roboto(color: Colors.white,
            fontWeight: FontWeight.w500)),
        icon: Icon(Icons.add, color: Colors.white),
      ),
      body: asyncRtList.when(
        error: (err, stack) {
          debugPrint(stack.toString());
          return Center(child: Text('Error: $err'));
        },
        loading: () {
          return CircularProgressIndicator();
        },
        data: (rtList) {
          return rtList.isEmpty
            ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_home_work_outlined, size: 125.w),
              SizedBox(height: 10.h),
              Text('Belum ada data RT yang tersimpan', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              Text('Anda belum mendaftarkan satu pun unit RT di bawah naungan RW Anda. ',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF74696D),
                  ),
                  textAlign: TextAlign.center),
              SizedBox(height: 15.h),
              Text('Tekan tombol + di bawah untuk memulai',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF74696D),
                  ),
                  textAlign: TextAlign.center)
            ],
          )
            : Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                SizedBox(
                  height: 50.h,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari RT...',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        final rt = rtList[index];
                        return RtItemCard(
                          rtId: rt.id,
                          rtName: rt.rtName,
                          population: rt.population ?? 0,
                          isActive: rt.isActive,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10.h),
                      itemCount: rtList.length
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }

}