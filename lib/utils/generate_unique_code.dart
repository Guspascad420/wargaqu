import 'dart:math';

/// Generates a unique registration code with a specific format.
///
/// Example: `generateUniqueCode(prefix: 'KETUA', entityId: 'RT01')`
/// might return "KETUA-RT01-A4B9K2".
String generateUniqueCode({
  required String prefix,
  required String entityId,
  int randomPartLength = 6,
}) {

  const String chars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  final Random random = Random.secure();

  final String randomPart = String.fromCharCodes(
    Iterable.generate(
      randomPartLength,
          (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );

  final String finalCode = '${prefix.toUpperCase()}-${entityId.toUpperCase()}-$randomPart';

  return finalCode;
}