import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';


@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String fullName,
    String? nik,
    String? phoneNumber,
    required String address,
    String? currentOccupation,
    String? residencyStatus,
    required String rwId,
    String? rtId,
    @Default('citizen') String role,
    String? profilePictureUrl,
    @Default({}) Map<String, String> billsStatus,
    DateTime? joinedTimestamp,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}