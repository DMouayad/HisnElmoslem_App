import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/src/core/extensions/string_extension.dart';
import 'package:hisnelmoslem/src/core/repos/app_data.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// TODO wire with setting cubit
class FontSettingsToolbox extends StatelessWidget {
  final bool showFontResizeControllers;
  final bool showDiacriticsControllers;

  const FontSettingsToolbox({
    super.key,
    this.showFontResizeControllers = true,
    this.showDiacriticsControllers = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: showFontResizeControllers,
          child: Expanded(
            child: IconButton(
              icon: Icon(MdiIcons.restart),
              onPressed: () {
                AppData.instance.resetFontSize();
              },
            ),
          ),
        ),
        Visibility(
          visible: showFontResizeControllers,
          child: Expanded(
            child: IconButton(
              icon: Icon(MdiIcons.formatFontSizeIncrease),
              onPressed: () {
                AppData.instance.increaseFontSize();
              },
            ),
          ),
        ),
        Visibility(
          visible: showFontResizeControllers,
          child: Expanded(
            child: IconButton(
              icon: Icon(MdiIcons.formatFontSizeDecrease),
              onPressed: () {
                AppData.instance.decreaseFontSize();
              },
            ),
          ),
        ),
        Visibility(
          visible: showDiacriticsControllers,
          child: Expanded(
            child: IconButton(
              icon: Icon(MdiIcons.abjadArabic),
              onPressed: () {
                AppData.instance.toggleDiacriticsStatus();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class TextSample extends StatelessWidget {
  final GetxController controllerToUpdate;

  const TextSample({super.key, required this.controllerToUpdate});
  static String text =
      "سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ، اللَّهُمَّ اغْفِرْ لِي";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              AppData.instance.isDiacriticsEnabled
                  ? text
                  : text.removeDiacritics,
              textAlign: TextAlign.center,
              softWrap: true,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: AppData.instance.fontSize * 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
