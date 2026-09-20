extension StringExtension on String {
  String trimmed() => trim();

  bool get isBlank => trimmed().isEmpty;

  bool get isNotBlank => !isBlank;
}