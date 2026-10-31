import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test_app/core/resources/resources.g.dart';

abstract final class SvgObjects {
  /// Заранее разбирает SVG и кладёт в кэш flutter_svg, чтобы флаг
  /// не мигал пустым местом при первом показе.
  static void init() {
    const pictures = [R.ASSETS_SVG_RU_SVG, R.ASSETS_SVG_GB_SVG];

    for (final path in pictures) {
      // loadBytes сам кладёт результат в svg.cache, отдельный
      // putIfAbsent, как в лекции, не нужен.
      SvgAssetLoader(path).loadBytes(null);
    }
  }
}

class SvgRu extends StatelessWidget {
  const SvgRu({super.key});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(R.ASSETS_SVG_RU_SVG);
}

class SvgGb extends StatelessWidget {
  const SvgGb({super.key});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(R.ASSETS_SVG_GB_SVG);
}
