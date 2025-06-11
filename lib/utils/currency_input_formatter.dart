import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SignedAmountFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0', 'id_ID');
  final String sign;

  SignedAmountFormatter({required this.sign});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String input = newValue.text;

    final numericOnly = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericOnly.isEmpty) {
      final text = '${sign}0';
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    final cleaned = numericOnly.length > 1 && numericOnly.startsWith('0')
        ? numericOnly.replaceFirst(RegExp(r'^0+'), '')
        : numericOnly;

    final formatted = _formatter.format(int.parse(cleaned));

    final newText = '$sign$formatted';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}