import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';

part 'rw_data.freezed.dart';
part 'rw_data.g.dart';

@freezed
abstract class RwData with _$RwData {
  const factory RwData({
    required String id,
    required String rwName,
    required String registrationUniqueCode,
    String? uniqueCodeStatus,
    String? secretariatAddress,
    String? province,
    String? city,
    String? district,
    String? village,
    @Default(true) bool isActive,
  }) = _RwData;

  factory RwData.fromJson(Map<String, dynamic> json) => _$RwDataFromJson(json);
}