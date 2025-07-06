
import 'dart:math';

String generateSimpleRandomId() {
  final random = Random();

  String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
  String randomString = String.fromCharCodes(
    List.generate(
      10,
          (index) => random.nextInt(33) + 89,
    ),
  );
  String combinedId = '$timestamp-$randomString';
  return combinedId;
}