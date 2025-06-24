import 'package:freezed_annotation/freezed_annotation.dart';

part 'unique_code.freezed.dart';
part 'unique_code.g.dart';

@freezed
abstract class UniqueCode with _$UniqueCode {
  const factory UniqueCode({required String code, required String role, required String status}) = _UniqueCode;

  factory UniqueCode.fromJson(Map<String, dynamic> json) => _$UniqueCodeFromJson(json);
}