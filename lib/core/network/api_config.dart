abstract final class ApiConfig {
  /// 10.0.2.2 — адрес компьютера-хоста изнутри Android-эмулятора.
  /// Для другого устройства:
  /// `flutter run --dart-define=API_BASE_URL=http://<ip>:8080`
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const apiPath = '/api/1.0';
}
