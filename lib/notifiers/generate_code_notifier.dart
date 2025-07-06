import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/generate_code/generate_code_state.dart';
import 'package:wargaqu/model/unique_code/unique_code.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/utils/generate_unique_code.dart';

class GenerateCodeNotifier extends Notifier<GenerateCodeState> {
  @override
  GenerateCodeState build() {
    return const GenerateCodeState.initial(); // State awal
  }

  Future<void> executeAddNewCode({
    required String rtId,
    required String rolePrefix, required String roleName
  }) async {
    state = const GenerateCodeState.loading();
    try {
      final rtService = ref.read(rtServiceProvider);
      final newGeneratedCode = generateUniqueCode(prefix: rolePrefix, entityId: rtId);
      final newCodeObject = UniqueCode(
        code: newGeneratedCode,
        role: roleName.toLowerCase().replaceAll(' ', '_'),
        status: 'AVAILABLE',
      );
      
      await rtService.generateAndSaveCode(rtId: rtId, newCode: newCodeObject);
      state = GenerateCodeState.success(generatedCode: newGeneratedCode, role: roleName);
    } catch (e) {
      state = GenerateCodeState.error(e.toString());
    }
  }
}