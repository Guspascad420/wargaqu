enum BillType {
  regular('regular'),
  incidental('incidental');

  const BillType(this.displayName);
  final String displayName;

  // Helper to convert from a string (e.g., from JSON) to BillType
  static BillType fromString(String typeString) {
    return BillType.values.firstWhere(
          (e) => e.name.toLowerCase() == typeString.toLowerCase() || e.displayName.toLowerCase() == typeString.toLowerCase(),
      orElse: () => BillType.regular,
    );
  }
}