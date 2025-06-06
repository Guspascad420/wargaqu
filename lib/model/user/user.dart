import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';


@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String fullName,
    required String nik,
    String? phoneNumber,
    required String address,
    String? currentOccupation,
    String? residencyStatus,
    required String rwId,
    required String rtId,
    @Default('citizen') String role,
    String? profilePictureUrl,
    @Default({}) Map<String, String> duesStatusByPeriod,
    DateTime? joinedTimestamp,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}