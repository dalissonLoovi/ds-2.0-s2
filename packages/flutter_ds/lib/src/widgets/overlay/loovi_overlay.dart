import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `Overlay.type`. `bottom-sheet` → [bottomSheet].
enum LooviOverlayType { modal, bottomSheet }

/// Seed `Overlay.platform`.
enum LooviOverlayPlatform { mobile, web }

/// Overlay (Figma 3768:3886) — full-viewport scrim composition that hosts a
/// [LooviModal] (type=modal) or a [LooviBottomSheet] (type=bottom-sheet) over
/// page content, inline (prototypes, layouts, goldens, custom routes).
///
/// To PRESENT a dialog in the app prefer `showLooviModal` /
/// `showLooviBottomSheet`: their routes paint the same scrim
/// (`color/overlay/overlay`) and add focus trap, back / Esc and focus restore.
///
/// Sparse matrix (seed): bottom-sheet is published only with platform=mobile;
/// bottom-sheet + web is asserted in debug.
///
/// Paint (mode app-cliente):
/// - root: fills the available box; fill `color/overlay/overlay`; vertical,
///   item gap `spacing/100`.
/// - type=modal, platform=mobile: padding `spacing/400` vertical,
///   `spacing/250` horizontal; slot centered.
/// - type=modal, platform=web: padding `spacing/400` vertical, `spacing/1200`
///   horizontal (Figma; not in the seed tokenRules); slot centered.
/// - type=bottom-sheet: padding top `spacing/700`, others `spacing/0`; slot
///   anchored bottom, full width.
///
/// Semantics: the scrim is not focusable and is excluded from semantics; the
/// slotted Modal / BottomSheet owns the dialog semantics. [onScrimTap] (e.g.
/// dismiss) is pointer-only; give the slotted surface its own close action.
class LooviOverlay extends StatelessWidget {
  const LooviOverlay({
    super.key,
    required this.child,
    this.type = LooviOverlayType.modal,
    this.platform = LooviOverlayPlatform.mobile,
    this.onScrimTap,
  }) : assert(
         !(type == LooviOverlayType.bottomSheet && platform == LooviOverlayPlatform.web),
         'Overlay: type=bottom-sheet is published only with platform=mobile (seed sparse matrix)',
       );

  /// Seed `slot`: a [LooviModal] or [LooviBottomSheet] only.
  final Widget child;

  final LooviOverlayType type;
  final LooviOverlayPlatform platform;

  /// Tap on the scrim outside the slotted surface.
  final VoidCallback? onScrimTap;

  /// Root padding of [type] x [platform].
  static EdgeInsets paddingFor(LooviTokens t, LooviOverlayType type, LooviOverlayPlatform platform) =>
      switch ((type, platform)) {
        (LooviOverlayType.modal, LooviOverlayPlatform.mobile) =>
          EdgeInsets.symmetric(vertical: t.spacing.s400, horizontal: t.spacing.s250),
        (LooviOverlayType.modal, LooviOverlayPlatform.web) =>
          EdgeInsets.symmetric(vertical: t.spacing.s400, horizontal: t.spacing.s1200),
        (LooviOverlayType.bottomSheet, _) => EdgeInsets.only(
          top: t.spacing.s700,
          left: t.spacing.s0,
          right: t.spacing.s0,
          bottom: t.spacing.s0,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final sheet = type == LooviOverlayType.bottomSheet;
    final slot = sheet
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(width: double.infinity, child: child),
          )
        : Center(child: child);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ExcludeSemantics(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              excludeFromSemantics: true,
              onTap: onScrimTap,
              child: ColoredBox(color: t.color.overlayOverlay),
            ),
          ),
        ),
        Padding(padding: paddingFor(t, type, platform), child: slot),
      ],
    );
  }
}
