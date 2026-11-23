import 'package:flutter_svg/flutter_svg.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../generated/loovi_icon_names.g.dart';

/// Icon slot with the DS contract name (`*-outline` / `*-filled`).
///
/// Mode app-cliente resolves to the Hugeicons geometry of the alias component
/// in Figma `[DS] Icons — App Cliente` (section 7003:12884). The native
/// Hugeicons name never reaches the slot. Color defaults to the ambient
/// [IconTheme] color, else `text/primary`.
class LooviIcon extends StatelessWidget {
  const LooviIcon(this.name, {super.key, this.size, this.color, this.semanticLabel});

  /// DS contract name, e.g. [LooviIcons.arrowLeftOutline].
  final String name;

  /// Logical size. Defaults to the ambient [IconTheme] size, else 24 (master).
  final double? size;

  final Color? color;

  /// Accessible label. Null = decorative (excluded from semantics).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(LooviIcons.all.contains(name), 'LooviIcon: "$name" não está no pacote. Exporte o alias e rode tool/extract_icons.mjs.');
    final iconTheme = IconTheme.of(context);
    final t = LooviTokens.of(context);
    final s = size ?? iconTheme.size ?? t.spacing.s300;
    final c = color ?? iconTheme.color ?? t.text.primary;
    final svg = SvgPicture.asset(
      'assets/icons/app-cliente/$name.svg',
      package: 'loovi_ds',
      width: s,
      height: s,
      // Only DS ink (currentColor) takes the color; white knock-outs and
      // luminance masks drawn in the alias stay as designed.
      theme: SvgTheme(currentColor: c),
      excludeFromSemantics: true,
    );
    if (semanticLabel == null) return ExcludeSemantics(child: svg);
    return Semantics(label: semanticLabel, image: true, child: svg);
  }
}
