// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bill _$BillFromJson(Map<String, dynamic> json) => _Bill(
      id: json['id'] as String,
      rtId: json['rtId'] as String,
      billName: json['billName'] as String,
      billType: _billTypeFromJson(json['billType'] as String),
      amount: (json['amount'] as num).toDouble(),
      dueDate: _timestampFromJson(json['dueDate'] as Timestamp),
    );

Map<String, dynamic> _$BillToJson(_Bill instance) => <String, dynamic>{
      'id': instance.id,
      'rtId': instance.rtId,
      'billName': instance.billName,
      'billType': _billTypeToJson(instance.billType),
      'amount': instance.amount,
      'dueDate': _timestampToJson(instance.dueDate),
    };
