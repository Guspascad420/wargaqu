// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bill {
  String get id;
  String get billName;
  @JsonKey(fromJson: _billTypeFromJson, toJson: _billTypeToJson)
  BillType get billType;
  String get createdBy;
  double get amount;
  DateTime get dueDate;
  String get paymentMethod;
  String get paymentStatus;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BillCopyWith<Bill> get copyWith =>
      _$BillCopyWithImpl<Bill>(this as Bill, _$identity);

  /// Serializes this Bill to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Bill &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billName, billName) ||
                other.billName == billName) &&
            (identical(other.billType, billType) ||
                other.billType == billType) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, billName, billType,
      createdBy, amount, dueDate, paymentMethod, paymentStatus);

  @override
  String toString() {
    return 'Bill(id: $id, billName: $billName, billType: $billType, createdBy: $createdBy, amount: $amount, dueDate: $dueDate, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus)';
  }
}

/// @nodoc
abstract mixin class $BillCopyWith<$Res> {
  factory $BillCopyWith(Bill value, $Res Function(Bill) _then) =
      _$BillCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String billName,
      @JsonKey(fromJson: _billTypeFromJson, toJson: _billTypeToJson)
      BillType billType,
      String createdBy,
      double amount,
      DateTime dueDate,
      String paymentMethod,
      String paymentStatus});
}

/// @nodoc
class _$BillCopyWithImpl<$Res> implements $BillCopyWith<$Res> {
  _$BillCopyWithImpl(this._self, this._then);

  final Bill _self;
  final $Res Function(Bill) _then;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billName = null,
    Object? billType = null,
    Object? createdBy = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      billName: null == billName
          ? _self.billName
          : billName // ignore: cast_nullable_to_non_nullable
              as String,
      billType: null == billType
          ? _self.billType
          : billType // ignore: cast_nullable_to_non_nullable
              as BillType,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      dueDate: null == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _self.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Bill implements Bill {
  const _Bill(
      {required this.id,
      required this.billName,
      @JsonKey(fromJson: _billTypeFromJson, toJson: _billTypeToJson)
      required this.billType,
      required this.createdBy,
      required this.amount,
      required this.dueDate,
      required this.paymentMethod,
      required this.paymentStatus});
  factory _Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  @override
  final String id;
  @override
  final String billName;
  @override
  @JsonKey(fromJson: _billTypeFromJson, toJson: _billTypeToJson)
  final BillType billType;
  @override
  final String createdBy;
  @override
  final double amount;
  @override
  final DateTime dueDate;
  @override
  final String paymentMethod;
  @override
  final String paymentStatus;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BillCopyWith<_Bill> get copyWith =>
      __$BillCopyWithImpl<_Bill>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BillToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Bill &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billName, billName) ||
                other.billName == billName) &&
            (identical(other.billType, billType) ||
                other.billType == billType) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, billName, billType,
      createdBy, amount, dueDate, paymentMethod, paymentStatus);

  @override
  String toString() {
    return 'Bill(id: $id, billName: $billName, billType: $billType, createdBy: $createdBy, amount: $amount, dueDate: $dueDate, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus)';
  }
}

/// @nodoc
abstract mixin class _$BillCopyWith<$Res> implements $BillCopyWith<$Res> {
  factory _$BillCopyWith(_Bill value, $Res Function(_Bill) _then) =
      __$BillCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String billName,
      @JsonKey(fromJson: _billTypeFromJson, toJson: _billTypeToJson)
      BillType billType,
      String createdBy,
      double amount,
      DateTime dueDate,
      String paymentMethod,
      String paymentStatus});
}

/// @nodoc
class __$BillCopyWithImpl<$Res> implements _$BillCopyWith<$Res> {
  __$BillCopyWithImpl(this._self, this._then);

  final _Bill _self;
  final $Res Function(_Bill) _then;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? billName = null,
    Object? billType = null,
    Object? createdBy = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
  }) {
    return _then(_Bill(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      billName: null == billName
          ? _self.billName
          : billName // ignore: cast_nullable_to_non_nullable
              as String,
      billType: null == billType
          ? _self.billType
          : billType // ignore: cast_nullable_to_non_nullable
              as BillType,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      dueDate: null == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _self.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
