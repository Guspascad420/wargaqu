import 'package:freezed_annotation/freezed_annotation.dart';
part 'bank_account.freezed.dart';
part 'bank_account.g.dart';

@freezed
abstract class BankAccount with _$BankAccount {
  const factory BankAccount({
    required String id,
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required String logoAsset
  }) = _BankAccount;

factory BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);
}
