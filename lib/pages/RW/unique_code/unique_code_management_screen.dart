import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/rt_role_card.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/RT/rt_officials.dart';
import 'package:wargaqu/model/generate_code/generate_code_state.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';
import 'package:wargaqu/theme/app_colors.dart';


class UniqueCodeManagementScreen extends ConsumerStatefulWidget {
  const UniqueCodeManagementScreen({super.key});

  @override
  ConsumerState<UniqueCodeManagementScreen> createState() => _UniqueCodeManagementScreenState();
}

class _UniqueCodeManagementScreenState extends ConsumerState<UniqueCodeManagementScreen> {
  final TextEditingController rtController = TextEditingController();
  bool _didDeleteCode = false;

  @override
  void dispose() {
    rtController.dispose();
    super.dispose();
  }

  Widget _buildRoleManagementCard({
    required BuildContext context,
    required WidgetRef ref,
    required RtManagement rtManagement,
    required RtData selectedRt,
    required String roleName,
    required String roleId,
    required String rolePrefix,
    required List<UserModel> officialsForRole,
  }) {
    final bool isRoleFilled = officialsForRole.isNotEmpty;

    final availableUniqueCode = rtManagement.registrationCodes.where(
          (code) => code.role == roleId && code.status == 'AVAILABLE'
    ).firstOrNull;

    if (isRoleFilled) {
      return RtRoleCard(
        roleName: roleName,
        status: UniqueCodeStatus.used,
        usedBy: officialsForRole.first.fullName,
        usedAt: '01 Juni 2025',
        onRegenerate: () { print('Ganti pengurus untuk $roleName'); },
      );
    } else if (availableUniqueCode != null) {
      return RtRoleCard(
        roleName: roleName,
        status: UniqueCodeStatus.available,
        uniqueCode: availableUniqueCode.code,
        onShare: () { print('Bagikan kode untuk $roleName'); },
        onDeactivate: () {
          _showDeleteConfirmationDialog(context, selectedRt.id, availableUniqueCode.code, roleName);
        },
      );
    } else {
      return RtRoleCard(
        roleName: roleName,
        status: UniqueCodeStatus.notGenerated,
        onGenerate: () => ref.read(generateCodeNotifierProvider.notifier).executeAddNewCode(
          rtId: selectedRt.id,
          rolePrefix: rolePrefix,
          roleName: roleName,
        )
      );
    }
  }

  void _showUniqueCodeDialog(BuildContext context, String uniqueCode, String role, String rtName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kode Berhasil Dibuat!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                  ),

                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h), // Pake .h untuk height responsif
                Text(
                  'Satu kode unik baru untuk peran $role di $rtName telah berhasil dibuat',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SelectableText(
                    uniqueCode,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      letterSpacing: 1.5.w,
                      fontSize: 26.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Berikan kode ini kepada calon $role untuk melakukan pendaftaran melalui aplikasi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: uniqueCode));
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: const Text('Kode berhasil disalin! ✅'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(dialogContext);
                        },
                        icon: Icon(Icons.copy, size: 20.w),
                        label: Text(
                          'Salin',
                          style: GoogleFonts.roboto(fontSize: 16.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          side: const BorderSide(color: AppColors.primary400),
                          foregroundColor: AppColors.primary400,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: const Text('Fitur kirim belum diimplementasi! 🚧'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          Navigator.pop(dialogContext);
                        },
                        icon: Icon(Icons.share, size: 20.w),
                        label: Text(
                          'Kirim',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          backgroundColor: AppColors.primary400,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String selectedRtId, String uniqueCodeToDelete, String role) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Anda yakin ingin menonaktifkan kode pendaftaran untuk peran $role?', // Judul Konfirmasi
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Kode Unik:',
                  style: GoogleFonts.roboto(
                    color: Colors.grey[500],
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  uniqueCodeToDelete,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Kode ini akan dihapus dan tidak bisa digunakan lagi untuk mendaftar',
                  style: GoogleFonts.roboto(
                    color: Colors.grey[500],
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton( // Tombol Batal
                        onPressed: () {
                          Navigator.pop(dialogContext); // Tutup dialog aja
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          side: BorderSide(color: Colors.grey.shade400),
                          foregroundColor: Colors.grey[500],
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton( // Tombol Hapus
                        onPressed: () async {
                          setState(() {
                            _didDeleteCode = true;
                          });
                          try {
                            await ref.read(deleteCodeNotifierProvider.notifier).execute(
                                rtId: selectedRtId, codeToDelete: uniqueCodeToDelete
                            );
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          } finally {
                            setState(() {
                              _didDeleteCode = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Hapus',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rwId = ref.watch(currentRwIdProvider);
    final asyncRtList = ref.watch(rtListStreamProvider(rwId!));
    final asyncManagementData = ref.watch(rtManagementProvider);
    final selectedRt = ref.watch(selectedRtProvider);

    ref.listen<GenerateCodeState>(generateCodeNotifierProvider, (previous, next) {
      switch (next) {
        case Success(generatedCode: final code, role: final role):
          _showUniqueCodeDialog(context, code, role, selectedRt!.rtName);
          break;

        case Error(message: final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          break;

        case Initial():
        case Loading():
          break;
      }
    });

    ref.listen<AsyncValue<void>>(deleteCodeNotifierProvider, (previous, next) {
      if (!_didDeleteCode) return;

      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
      if (previous is AsyncLoading && !next.isLoading && !next.hasError) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Kode berhasil dinonaktifkan!')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
          title: Text('Manajemen Kode RT', style: Theme.of(context).textTheme.titleMedium),
          centerTitle: true
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            asyncRtList.when(
                error: (err, stack) => Center(child: Text('Error: $err')),
                loading: () => const Text('Memuat daftar RT...'),
                data: (rtList) {
                  return DropdownMenu<RtData>(
                    initialSelection: selectedRt,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: rtList.map((rt) =>
                        DropdownMenuEntry(value: rt, label: '${rt.rtName} (RT ${rt.rtNumber})')
                    ).toList(),
                    hintText: 'Pilih RT untuk Dikelola...',
                    onSelected: (RtData? rt) {
                      ref.read(selectedRtProvider.notifier).state = rt;
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
                  );
                }
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: asyncManagementData.when(
                  error: (err, stack) {
                    return Center(child: Text('Error: $err'));
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  data: (rtManagement) {
                    if (rtManagement == null || selectedRt == null) {
                      return Center(child: Text('Silakan pilih RT untuk dikelola.',
                          style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.w600)));
                    }
                    return ListView(
                      children: [
                        _buildRoleManagementCard(
                          context: context,
                          ref: ref,
                          rtManagement: rtManagement,
                          selectedRt: selectedRt,
                          roleName: 'Ketua RT',
                          roleId: 'ketua_rt',
                          rolePrefix: 'KETUA',
                          officialsForRole: [if (rtManagement.chairman != null) rtManagement.chairman!],
                        ),
                        SizedBox(height: 15.h),
                        _buildRoleManagementCard(
                          context: context,
                          ref: ref,
                          rtManagement: rtManagement,
                          selectedRt: selectedRt,
                          roleName: 'Bendahara RT',
                          roleId: 'bendahara_rt',
                          rolePrefix: 'BENDA',
                          officialsForRole: rtManagement.treasurers,
                        ),
                      ],
                    );
                  }
              )
            )
          ],
        )
      ),
    );
  }
}

