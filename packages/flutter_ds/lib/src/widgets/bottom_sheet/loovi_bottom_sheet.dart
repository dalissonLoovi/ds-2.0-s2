import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import 'loovi_bottom_sheet_header.dart';

/// Seed `BottomSheet.header`. `sheet-header` → [sheetHeader].
///
/// Named `…HeaderVariant` because `LooviBottomSheetHeader` is the nested
/// header widget.
enum LooviBottomSheetHeaderVariant { none, sheetHeader }

/// BottomSheet (Figma 3181:8289) — temporary bottom-anchored surface.
///
/// This widget is the panel (inline). Use [showLooviBottomSheet] to present it
/// as a modal route (barrier `color/overlay/overlay`, drag/Esc/back/barrier
/// close it, focus trapped in the route).
///
/// Paint (mode app-cliente):
/// - root: fill `color/background-surface/0`; top corners `border/radius/600`
///   (24); padding top `spacing/150`, bottom `spacing/500`; no elevation.
/// - header=none: horizontal `spacing/300` on the root; dragHandle
///   `spacing/400` × `spacing/050`, fill `text/placeholder`, radius
///   `border/radius/300` (frame value 12, not tokenized); gap `spacing/300`.
/// - header=sheet-header: root horizontal `spacing/0` (header edge-to-edge);
///   [LooviBottomSheetHeader]; gap `spacing/100`; sheetContent horizontal
///   `spacing/300`. The header's 48 touch target grows 4 px each side over the
///   40 frame; that is taken from the top padding and the gap.
/// - the slot scrolls when the sheet does not fit (textScaler respected).
///
/// Semantics: route scope named by [title] (or [semanticLabel] when
/// header=none / showLabel=false).
class LooviBottomSheet extends StatelessWidget {
  const LooviBottomSheet({
    super.key,
    this.child,
    this.header = LooviBottomSheetHeaderVariant.sheetHeader,
    this.title = 'Label',
    this.showLabel = true,
    this.showOptionsAction = false,
    this.showLeadingAction = false,
    this.showCloseAction = true,
    this.onClose,
    this.onOptions,
    this.onLeadingAction,
    this.semanticLabel,
  });

  /// Seed `slot` / sheetContent. BottomSheetCheckItem rows go here.
  final Widget? child;

  /// Seed `header`.
  final LooviBottomSheetHeaderVariant header;

  /// Nested BottomSheetHeader props (header=sheet-header).
  final String title;
  final bool showLabel;
  final bool showOptionsAction;
  final bool showLeadingAction;
  final bool showCloseAction;
  final VoidCallback? onClose;
  final VoidCallback? onOptions;
  final VoidCallback? onLeadingAction;

  /// Accessible name of the sheet route. Defaults to [title] when the title
  /// is shown.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final hasHeader = header == LooviBottomSheetHeaderVariant.sheetHeader;
    final inset = hasHeader ? LooviBottomSheetHeader.touchInset(context) : t.spacing.s0;
    final radius = BorderRadius.vertical(top: Radius.circular(t.radius.s600));
    final name = semanticLabel ?? (hasHeader && showLabel ? title : null);

    final contentPad = EdgeInsets.symmetric(horizontal: hasHeader ? t.spacing.s300 : t.spacing.s0);
    final body = child == null ? null : SingleChildScrollView(padding: contentPad, child: child);

    final top = hasHeader
        ? LooviBottomSheetHeader(
            title: title,
            showLabel: showLabel,
            showOptionsAction: showOptionsAction,
            showLeadingAction: showLeadingAction,
            showCloseAction: showCloseAction,
            onClose: onClose,
            onOptions: onOptions,
            onLeadingAction: onLeadingAction,
          )
        : ExcludeSemantics(
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: t.text.placeholder,
                  borderRadius: BorderRadius.circular(t.radius.s300),
                ),
                child: SizedBox(width: t.spacing.s400, height: t.spacing.s050),
              ),
            ),
          );

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: name != null,
      explicitChildNodes: true,
      label: name,
      child: Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: BoxDecoration(color: t.color.backgroundSurface0, borderRadius: radius),
          child: ClipRRect(
            borderRadius: radius,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                hasHeader ? t.spacing.s0 : t.spacing.s300,
                math.max(t.spacing.s0, t.spacing.s150 - inset),
                hasHeader ? t.spacing.s0 : t.spacing.s300,
                t.spacing.s500,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bounded = constraints.hasBoundedHeight;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      top,
                      if (body != null) ...[
                        SizedBox(
                          height: hasHeader ? math.max(t.spacing.s0, t.spacing.s100 - inset) : t.spacing.s300,
                        ),
                        bounded ? Flexible(child: body) : body,
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Presents a [LooviBottomSheet] with `showModalBottomSheet` (material_ui).
///
/// - Barrier `color/overlay/overlay`; route shape = top `border/radius/600`,
///   fill `color/background-surface/0`, elevation 0 (no shadow in the frame).
/// - `isScrollControlled` + safe area: the sheet hugs its content up to the
///   screen height and the slot scrolls beyond that.
/// - Drag down, barrier tap, Esc and system back close it; the header close
///   pops the route.
Future<T?> showLooviBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  LooviBottomSheetHeaderVariant header = LooviBottomSheetHeaderVariant.sheetHeader,
  String title = 'Label',
  bool showLabel = true,
  bool showOptionsAction = false,
  bool showLeadingAction = false,
  bool showCloseAction = true,
  VoidCallback? onOptions,
  VoidCallback? onLeadingAction,
  String? semanticLabel,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = true,
}) {
  final t = LooviTokens.of(context);
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: false,
    backgroundColor: t.color.backgroundSurface0,
    barrierColor: t.color.overlayOverlay,
    elevation: t.spacing.s0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(t.radius.s600))),
    clipBehavior: Clip.antiAlias,
    builder: (sheetContext) => Padding(
      // Keeps the sheet above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
      child: LooviBottomSheet(
        header: header,
        title: title,
        showLabel: showLabel,
        showOptionsAction: showOptionsAction,
        showLeadingAction: showLeadingAction,
        showCloseAction: showCloseAction,
        onClose: () => Navigator.of(sheetContext).maybePop(),
        onOptions: onOptions,
        onLeadingAction: onLeadingAction,
        semanticLabel: semanticLabel,
        child: builder(sheetContext),
      ),
    ),
  );
}
