// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BankAccount {
  String get id;
  String get bankName;
  String get accountNumber;
  String get accountHolderName;
  String get logoAsset;

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BankAccountCopyWith<BankAccount> get copyWith =>
      _$BankAccountCopyWithImpl<BankAccount>(this as BankAccount, _$identity);

  /// Serializes this BankAccount to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BankAccount &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolderName, accountHolderName) ||
                other.accountHolderName == accountHolderName) &&
            (identical(other.logoAsset, logoAsset) ||
                other.logoAsset == logoAsset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, bankName, accountNumber, accountHolderName, logoAsset);

  @override
  String toString() {
    return 'BankAccount(id: $id, bankName: $bankName, accountNumber: $accountNumber, accountHolderName: $accountHolderName, logoAsset: $logoAsset)';
  }
}

/// @nodoc
abstract mixin class $BankAccountCopyWith<$Res> {
  factory $BankAccountCopyWith(
          BankAccount value, $Res Function(BankAccount) _then) =
      _$BankAccountCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String bankName,
      String accountNumber,
      String accountHolderName,
      String logoAsset});
}

/// @nodoc
class _$BankAccountCopyWithImpl<$Res> implements $BankAccountCopyWith<$Res> {
  _$BankAccountCopyWithImpl(this._self, this._then);

  final BankAccount _self;
  final $Res Function(BankAccount) _then;

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountHolderName = null,
    Object? logoAsset = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _self.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountHolderName: null == accountHolderName
          ? _self.accountHolderName
          : accountHolderName // ignore: cast_nullable_to_non_nullable
              as String,
      logoAsset: null == logoAsset
          ? _self.logoAsset
          : logoAsset // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BankAccount implements BankAccount {
  const _BankAccount(
      {required this.id,
      required this.bankName,
      required this.accountNumber,
      required this.accountHolderName,
      required this.logoAsset});
  factory _BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);

  @override
  final String id;
  @override
  final String bankName;
  @override
  final String accountNumber;
  @override
  final String accountHolderName;
  @override
  final String logoAsset;

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BankAccountCopyWith<_BankAccount> get copyWith =>
      __$BankAccountCopyWithImpl<_BankAccount>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BankAccountToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BankAccount &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolderName, accountHolderName) ||
                other.accountHolderName == accountHolderName) &&
            (identical(other.logoAsset, logoAsset) ||
                other.logoAsset == logoAsset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, bankName, accountNumber, accountHolderName, logoAsset);

  @override
  String toString() {
    return 'BankAccount(id: $id, bankName: $bankName, accountNumber: $accountNumber, accountHolderName: $accountHolderName, logoAsset: $logoAsset)';
  }
}

/// @nodoc
abstract mixin class _$BankAccountCopyWith<$Res>
    implements $BankAccountCopyWith<$Res> {
  factory _$BankAccountCopyWith(
          _BankAccount value, $Res Function(_BankAccount) _then) =
      __$BankAccountCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String bankName,
      String accountNumber,
      String accountHolderName,
      String logoAsset});
}

/// @nodoc
class __$BankAccountCopyWithImpl<$Res> implements _$BankAccountCopyWith<$Res> {
  __$BankAccountCopyWithImpl(this._self, this._then);

  final _BankAccount _self;
  final $Res Function(_BankAccount) _then;

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountHolderName = null,
    Object? logoAsset = null,
  }) {
    return _then(_BankAccount(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _self.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountHolderName: null == accountHolderName
          ? _self.accountHolderName
          : accountHolderName // ignore: cast_nullable_to_non_nullable
              as String,
      logoAsset: null == logoAsset
          ? _self.logoAsset
          : logoAsset // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
