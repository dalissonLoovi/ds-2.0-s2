import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../modal_check_item/loovi_modal_check_item.dart' show LooviCheckItemRow;

/// BottomSheetCheckItem S2 (Figma `4389:80`, mode app-cliente) — guideline /
/// checklist row inside BottomSheet body content: decorative check icon +
/// copy. Not a checkbox: no interaction, no checked state. Inside a Modal use
/// `LooviModalCheckItem`.
///
/// Paint (mode app-cliente), same spec as ModalCheckItem:
/// - leadingIcon 20 (`spacing/250`), `color/actions/primary`, top-aligned;
///   decorative (excluded from semantics).
/// - gap `spacing/100`, padding `spacing/0`.
/// - description `body/medium/regular`, `text/secondary`; every occurrence of
///   an [emphasis] phrase `body/medium/semi-bold`, `text/brand` (4.52:1).
class LooviBottomSheetCheckItem extends StatelessWidget {
  const LooviBottomSheetCheckItem({
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
