import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wargaqu/model/user/user.dart';
part 'citizen_with_status.freezed.dart';

@freezed
abstract class CitizenWithStatus with _$CitizenWithStatus {
  const factory CitizenWithStatus({
    required UserModel user,
    required String paymentStatus, // "lunas", "belum_bayar", "perlu_konfirmasi"
  }) = _CitizenWithStatus;
}