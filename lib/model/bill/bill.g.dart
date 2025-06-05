// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bill _$BillFromJson(Map<String, dynamic> json) => _Bill(
      id: json['id'] as String,
      billName: json['billName'] as String,
      billType: json['billType'] as String,
      createdBy: json['createdBy'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
    );

Map<String, dynamic> _$BillToJson(_Bill instance) => <String, dynamic>{
      'id': instance.id,
      'billName': instance.billName,
      'billType': instance.billType,
      'createdBy': instance.createdBy,
      'amount': instance.amount,
      'dueDate': instance.dueDate.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
    };
