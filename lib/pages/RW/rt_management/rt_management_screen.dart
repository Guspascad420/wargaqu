import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/rt_item_card.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/pages/RW/rt_management/new_rt_form.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

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
          'Manajemen Warga RW',
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
        label: Text('Tambah Data RT Baru'),
        icon: Icon(Icons.add),
      ),
      body: Padding(
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
            asyncRtList.when(
                error: (err, stack) => Center(child: Text('Error: $err')),
                loading: () {
                  return CircularProgressIndicator();
                },
                data: (rtList) {
                  return Expanded(
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
                  );
                }
            )
          ],
        ),
      ),
    );
  }

}