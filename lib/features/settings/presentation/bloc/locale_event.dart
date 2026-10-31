sealed class LocaleEvent {
  const LocaleEvent();
}

/// Переключить на следующий поддерживаемый язык (у нас их два: ru ↔ en).
class LocaleToggled extends LocaleEvent {
  const LocaleToggled();
}
