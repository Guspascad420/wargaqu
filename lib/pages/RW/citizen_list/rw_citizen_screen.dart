import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/RT/rt_data.dart';

class RwCitizenScreen extends StatefulWidget{
  const RwCitizenScreen({super.key, required this.rtDataList});

  final List<RtData> rtDataList;

  @override
  State<RwCitizenScreen> createState() => _RwCitizenScreenState();
}

class _RwCitizenScreenState extends State<RwCitizenScreen> {
  final TextEditingController rtController = TextEditingController();
  // State untuk menyimpan data RT yang dipilih
  RtData? selectedRt;

  @override
  void dispose() {
    rtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<RtData> activeRtList = widget.rtDataList.where((rt) => rt.isActive).toList();
    final List<DropdownMenuEntry<RtData>> rtEntries = activeRtList.map((RtData rt) {
      return DropdownMenuEntry<RtData>(
        value: rt,
        label: '${rt.rtName} (RT ${rt.rtNumber})',
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manajemen Warga RW',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              SizedBox(
                height: 50.h,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari nama warga...',
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
              SizedBox(height: 15.h),
              DropdownMenu<RtData>(
                controller: rtController,
                expandedInsets: EdgeInsets.zero,
                dropdownMenuEntries: rtEntries,
                hintText: 'Cari atau pilih RT...',
                onSelected: (RtData? rt) {
                  setState(() {
                    selectedRt = rt;
                    // Teks di field dropdown akan otomatis diisi dengan label dari entri yang dipilih
                  });
                  if (rt != null) {
                    print('RT yang dipilih: ${rt.rtName} (ID: ${rt.id})');
                  }
                },
                // Styling untuk text field dropdown
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

}