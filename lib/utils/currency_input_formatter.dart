import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SignedAmountFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0', 'id_ID');
  final String sign;

  SignedAmountFormatter({required this.sign});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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

    if (newText.isEmpty || newText == '+' || newText == '-') {
      String prefix = (newText.startsWith('-') || oldValue.text.startsWith('-')) ? '-' : '+';
      if (newText.isEmpty) { // If user deletes everything
        return TextEditingValue(
          text: '${prefix}0',
          selection: TextSelection.collapsed(offset: ('${prefix}0').length),
        );
      }
      // If only a sign is left, keep it
      if (newText == '+' || newText == '-') {
        return newValue;
      }
    }

    print("DEBUG: Formatter: old='${oldValue.text}', new='${newValue.text}', returning='${newText}'");

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static int formatCurrencyStringToInt(String formattedAmount) {
    if (formattedAmount.isEmpty) {
      return 0; // Or throw an error, depending on desired behavior for empty input
    }

    String amountWithoutSign = formattedAmount;
    if (formattedAmount.startsWith('+') || formattedAmount.startsWith('-')) {
      amountWithoutSign = formattedAmount.substring(1);
    }

    String cleanedAmount = amountWithoutSign.replaceAll('.', '');

    // 3. Parse to integer
    try {
      return int.parse(cleanedAmount);
    } catch (e) {
      print("Error parsing amount: '$formattedAmount' -> '$cleanedAmount'. Error: $e");
      return 0;
    }
  }
}