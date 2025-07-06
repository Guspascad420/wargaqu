import 'package:freezed_annotation/freezed_annotation.dart';
part 'confirmation_state.freezed.dart';

enum ConfirmationAction { confirm, reject }

@freezed
abstract class ConfirmationState with _$ConfirmationState {
  const factory ConfirmationState({
    @Default(false) bool isLoading,
    ConfirmationAction? actionInProgress,
    String? errorMessage,
  }) = _ConfirmationState;
}