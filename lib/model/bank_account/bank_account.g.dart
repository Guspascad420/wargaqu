// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => _BankAccount(
      id: json['id'] as String?,
      bankName: json['bankName'] as String,
      accountNumber: json['accountNumber'] as String,
      accountHolderName: json['accountHolderName'] as String,
      logoAsset: json['logoAsset'] as String?,
    );

Map<String, dynamic> _$BankAccountToJson(_BankAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'accountHolderName': instance.accountHolderName,
      'logoAsset': instance.logoAsset,
    };
