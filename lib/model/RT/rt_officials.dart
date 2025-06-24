import 'package:flutter/cupertino.dart';
import 'package:wargaqu/model/unique_code/unique_code.dart';
import 'package:wargaqu/model/user/user.dart';

@immutable
class RtManagement {
  final UserModel? chairman;
  final List<UserModel> treasurers;
  final List<UniqueCode> registrationCodes;

  const RtManagement({this.chairman, required this.treasurers, required this.registrationCodes});
}