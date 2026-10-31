/// Тип ошибки без текста: слой данных не знает языка интерфейса,
/// текст выбирает UI (см. AppFailureMessage).
enum AppFailure { connection, timeout, server, notFound, storage, unknown }
