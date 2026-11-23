// ignore_for_file: deprecated_member_use
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'components/component_use_cases.dart';
import 'foundation/foundation_use_cases.dart';

/// Loovi DS — Flutter catalog (Widgetbook). Mode app-cliente only in this stage.
void main() => runApp(const LooviWidgetbook());

/// Logical viewport used by every story (390 × 844, app-cliente reference).
const looviAppViewport = ViewportData(
  name: 'App Cliente · 390',
  width: 390,
  height: 844,
  pixelRatio: 3,
  platform: TargetPlatform.iOS,
);

/// Stories run inside a `material_ui` MaterialApp with the DS theme — the same
/// Material library a Flutter 3.50 app uses. Widgetbook 3.25 itself still uses
/// `package:flutter/material.dart`, so its own addons get the official
/// [MaterialUiCompatibilityBridge] (catalog only; the DS packages don't use it).
Widget looviAppBuilder(BuildContext context, Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: LooviTheme.light(),
    home: MaterialUiCompatibilityBridge(child: Material(child: child)),
  );
}

class LooviWidgetbook extends StatelessWidget {
  const LooviWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      appBuilder: looviAppBuilder,
      directories: [
        foundationFolder(),
        componentsFolder(),
      ],
      addons: [
        ViewportAddon([looviAppViewport]),
        TextScaleAddon(min: 1.0, max: 2.0, divisions: 4),
      ],
    );
  }
}
