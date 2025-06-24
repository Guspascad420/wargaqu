import 'package:freezed_annotation/freezed_annotation.dart';
part 'generate_code_state.freezed.dart';

@freezed
class GenerateCodeState with _$GenerateCodeState {
  const factory GenerateCodeState.initial() = Initial;
  const factory GenerateCodeState.loading() = Loading;
  const factory GenerateCodeState.success({required String generatedCode, required String role}) = Success;
  const factory GenerateCodeState.error(String message) = Error;
}