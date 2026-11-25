import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../generated/loovi_illustration_names.g.dart';

/// DS illustration (`illustration / <group> / <name>`, Figma page
/// "Ilustrações e animações" 4326:1764) by catalog name, e.g.
/// [LooviIllustrations.claimReasonTheft].
///
/// Sizing keeps the artboard aspect ratio:
/// - no size → artboard size (e.g. 156 × 156);
/// - only [width] or only [height] → the other side follows the ratio;
/// - both → the art is fitted into the box with [fit] (default contain).
///
/// The illustration palette is hardcoded in the asset on purpose (dedicated
/// illustration palette — not remapped to semantic tokens), so there is no
/// color parameter.
///
/// Decorative by default (excluded from semantics); pass [semanticLabel] when
/// the art carries meaning not stated by adjacent text.
class LooviIllustration extends StatelessWidget {
  const LooviIllustration(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.semanticLabel,
    this.fit = BoxFit.contain,
  });

  /// Catalog name `<group>/<name>` — see [LooviIllustrations].
  final String name;

  final double? width;
  final double? height;

  /// Accessible label. Null = decorative.
  final String? semanticLabel;

  final BoxFit fit;

  /// Resolved box for [spec] given optional [width]/[height].
  static Size sizeFor(LooviIllustrationSpec spec, {double? width, double? height}) {
    if (width != null && height != null) return Size(width, height);
    if (width != null) return Size(width, width / spec.aspectRatio);
    if (height != null) return Size(height * spec.aspectRatio, height);
    return Size(spec.width, spec.height);
  }

  @override
  Widget build(BuildContext context) {
    final spec = LooviIllustrations.specOf(name);
    assert(spec != null, 'LooviIllustration: "$name" is not in the package. Add it to tool/illustrations.json and run tool/generate_illustrations.mjs.');
    if (spec == null) return SizedBox(width: width, height: height);
    final size = sizeFor(spec, width: width, height: height);
    final svg = SvgPicture.asset(
      spec.asset,
      package: 'loovi_ds',
      width: size.width,
      height: size.height,
      fit: fit,
      excludeFromSemantics: true,
    );
    if (semanticLabel == null) return ExcludeSemantics(child: svg);
    return Semantics(label: semanticLabel, image: true, child: svg);
  }
}
