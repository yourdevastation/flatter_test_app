.PHONY: gen watch icon init_res res loc format

# Генерация *.g.dart: DTO (json_serializable), copyWith, таблицы drift
gen:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

# Иконка приложения из assets/icon (настройки в pubspec.yaml)
icon:
	dart run flutter_launcher_icons

# Один раз: установить генератор класса ресурсов R
init_res:
	dart pub global activate flutter_asset_generator

# Класс R с путями ко всем ассетам
res:
	fgen --output lib/core/resources/resources.g.dart --no-watch --no-preview
	$(MAKE) format

# Классы локализации из l10n/*.arb
loc:
	flutter gen-l10n
	$(MAKE) format

format:
	dart format lib
