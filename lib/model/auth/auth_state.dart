import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_state.freezed.dart';

enum AuthStateStatus { initial, loading, success, error }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStateStatus.initial) AuthStateStatus status,
    String? errorMessage,
  }) = _AuthState;
}