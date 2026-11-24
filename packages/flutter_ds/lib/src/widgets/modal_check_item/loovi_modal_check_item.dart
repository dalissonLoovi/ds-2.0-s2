import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// ModalCheckItem S2 (Figma `4372:19371`, mode app-cliente) — guideline /
/// checklist row inside Modal body content: decorative check icon + copy.
/// Not a checkbox: no interaction, no checked state. Inside a BottomSheet
/// use `LooviBottomSheetCheckItem`.
///
/// Paint (mode app-cliente), shared with BottomSheetCheckItem:
/// - leadingIcon 20 (`spacing/250`), `color/actions/primary`, top-aligned;
///   decorative (excluded from semantics).
/// - gap `spacing/100`, padding `spacing/0`.
/// - description `body/medium/regular`, `text/secondary`; every occurrence of
///   an [emphasis] phrase `body/medium/semi-bold`, `text/brand` (4.52:1).
class LooviModalCheckItem extends StatelessWidget {
  const LooviModalCheckItem({
    super.key,
    required this.description,
    this.emphasis = const [],
    this.leadingIcon = LooviIcons.circleCheckFilled,
  });

  /// Seed `description` — guideline copy (multi-line).
  final String description;

  /// Phrases of [description] painted with the seed emphasis style.
  final List<String> emphasis;

  /// Seed `leadingIcon` (INSTANCE_SWAP; preferred `circle-check-filled`).
  final String leadingIcon;

  @override
  Widget build(BuildContext context) =>
      LooviCheckItemRow(description: description, emphasis: emphasis, leadingIcon: leadingIcon);
}

/// Internal anatomy shared by ModalCheckItem and BottomSheetCheckItem (same
/// Figma spec). Not part of the public API.
class LooviCheckItemRow extends StatelessWidget {
  const LooviCheckItemRow({super.key, required this.description, required this.emphasis, required this.leadingIcon});

  final String description;
  final List<String> emphasis;
  final String leadingIcon;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final base = t.typography.bodyMediumRegular.copyWith(color: t.text.secondary);
    final strong = t.typography.bodyMediumSemiBold.copyWith(color: t.text.brand);
    // Line height of the first line keeps the 20 px icon aligned with it.
    final iconBox = MediaQuery.textScalerOf(context).scale(base.fontSize!) * base.height!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: iconBox < t.spacing.s250 ? t.spacing.s250 : iconBox,
          child: Center(
            widthFactor: 1,
            child: LooviIcon(leadingIcon, size: t.spacing.s250, color: t.color.actionsPrimary),
          ),
        ),
        SizedBox(width: t.spacing.s100),
        Expanded(child: Text.rich(TextSpan(style: base, children: _spans(strong)))),
      ],
    );
  }

  List<TextSpan> _spans(TextStyle strong) {
    final phrases = emphasis.where((e) => e.isNotEmpty).toList();
    if (phrases.isEmpty) return [TextSpan(text: description)];
    final pattern = RegExp(phrases.map(RegExp.escape).join('|'));
    final spans = <TextSpan>[];
    var start = 0;
    for (final m in pattern.allMatches(description)) {
      if (m.start > start) spans.add(TextSpan(text: description.substring(start, m.start)));
      spans.add(TextSpan(text: m.group(0), style: strong));
      start = m.end;
    }
    if (start < description.length) spans.add(TextSpan(text: description.substring(start)));
    return spans;
  }
}
