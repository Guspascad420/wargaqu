import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';


@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    String? id,
    required String email,
    required String fullName,
    required String rwId,
    required String address,
    String? nik,
    String? phoneNumber,
    String? currentOccupation,
    String? residencyStatus,
    String? rtId,
    String? kkNumber,
    @Default('citizen') String role,
    String? profilePictureUrl,
    @Default({}) Map<String, dynamic> billsStatus,
    @Default('ACTIVE') String status,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? joinedTimestamp,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _timestampToJson(DateTime? date) => Timestamp.fromDate(date!);