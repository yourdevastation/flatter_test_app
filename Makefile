.PHONY: gen watch

# Генерация *.g.dart для DTO (json_serializable)
gen:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs
