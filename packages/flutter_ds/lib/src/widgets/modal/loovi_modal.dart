import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import 'loovi_modal_header.dart';

/// Seed `Modal.platform`. `mobile-landscape` → [mobileLandscape].
enum LooviModalPlatform { web, mobile, mobileLandscape }

/// Modal (Figma 3306:4278) — dialog surface for a focused task.
///
/// This widget is the panel (inline). Use [showLooviModal] to present it as a
/// dialog route: barrier `color/overlay/overlay`, focus trapped in the route,
/// Esc / back / barrier tap close it.
///
/// Paint (mode app-cliente):
/// - shell: fill `color/background-surface/0`; radius
///   `component/modal/container/radius` (app-cliente → `border/radius/800` = 32;
///   never radius/600 here); elevation `effects/elevation/1`
///   (`color/elevation/6`, y `spacing/100`, blur `spacing/100`).
/// - padding top `spacing/0`, bottom `spacing/400` (mobile|mobile-landscape) |
///   `spacing/500` (web); gap header→content `spacing/050` | `spacing/150`.
/// - sheetContent: horizontal `spacing/200` (mobile|mobile-landscape) |
///   `spacing/300` (web); the slot scrolls when the text scale grows.
/// - header: [LooviModalHeader] with layout mapped from [platform].
/// - [footer] (React `footer`): below the slot, `spacing/300` apart — not in the
///   Figma set (actions usually live inside the slot there).
///
/// Semantics: route scope named by [title] (`scopesRoute` + `namesRoute`), title
/// marked as header, close "Fechar modal".
class LooviModal extends StatelessWidget {
  const LooviModal({
    super.key,
    required this.title,
    this.child,
    this.footer,
    this.platform = LooviModalPlatform.mobile,
    this.alignment = LooviModalHeaderAlignment.start,
    this.label = '',
    this.showLabel = false,
    this.showCloseAction = true,
    this.onClose,
    this.closeSemanticLabel = 'Fechar modal',
  });

  /// Nested ModalHeader `title` — also the accessible name of the dialog.
  final String title;

  /// Seed `slot` (modal body). ModalCheckItem rows go here.
  final Widget? child;

  /// Optional actions row (React `footer`), e.g. two [LooviButton]s.
  final Widget? footer;

  final LooviModalPlatform platform;

  /// Nested ModalHeader `alignment`.
  final LooviModalHeaderAlignment alignment;

  /// Nested ModalHeader `label` / `showLabel`.
  final String label;
  final bool showLabel;

  /// Nested ModalHeader `showCloseAction`.
  final bool showCloseAction;

  /// Close tap (header). [showLooviModal] pops the route by default.
  final VoidCallback? onClose;

  final String closeSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final web = platform == LooviModalPlatform.web;

    final header = LooviModalHeader(
      title: title,
      layout: web ? LooviModalHeaderLayout.desktop : LooviModalHeaderLayout.mobile,
      alignment: alignment,
      label: label,
      showLabel: showLabel,
      showCloseAction: showCloseAction,
      onClose: onClose,
      closeSemanticLabel: closeSemanticLabel,
    );

    final contentPad = EdgeInsets.symmetric(horizontal: web ? t.spacing.s300 : t.spacing.s200);
    final body = child == null
        ? null
        : SingleChildScrollView(padding: contentPad, child: child);

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.color.backgroundSurface0,
          borderRadius: BorderRadius.circular(t.component.modal.containerRadius),
          boxShadow: LooviEffects.box(t.effects.elevation1),
        ),
        // Transparent Material: text styles/ink without a second surface.
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(t.component.modal.containerRadius),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.only(top: t.spacing.s0, bottom: web ? t.spacing.s500 : t.spacing.s400),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bounded = constraints.hasBoundedHeight;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header,
                    if (body != null) ...[
                      SizedBox(height: web ? t.spacing.s150 : t.spacing.s050),
                      bounded ? Flexible(child: body) : body,
                    ],
                    if (footer != null) ...[
                      SizedBox(height: t.spacing.s300),
                      Padding(padding: contentPad, child: footer),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Presents a [LooviModal] as a dialog route (`showGeneralDialog`).
///
/// - Barrier `color/overlay/overlay`; tap on it, Esc and system back close the
///   route ([barrierDismissible]).
/// - Focus is trapped by the route's FocusScope and restored on pop.
/// - [builder] builds the slot; [footerBuilder] the actions (their context can
///   `Navigator.pop(context, value)`).
/// - Inset `spacing/300` from the screen edges; the panel hugs its content and
///   the slot scrolls when it does not fit.
Future<T?> showLooviModal<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  WidgetBuilder? footerBuilder,
  LooviModalPlatform platform = LooviModalPlatform.mobile,
  LooviModalHeaderAlignment alignment = LooviModalHeaderAlignment.start,
  String label = '',
  bool showLabel = false,
  bool showCloseAction = true,
  bool barrierDismissible = true,
  String? barrierLabel,
  bool useRootNavigator = true,
}) {
  final t = LooviTokens.of(context);
  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: t.color.overlayOverlay,
    pageBuilder: (dialogContext, _, _) {
      final dt = LooviTokens.of(dialogContext);
      return SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(dt.spacing.s300),
            child: LooviModal(
              title: title,
              platform: platform,
              alignment: alignment,
              label: label,
              showLabel: showLabel,
              showCloseAction: showCloseAction,
              onClose: () => Navigator.of(dialogContext).maybePop(),
              footer: footerBuilder?.call(dialogContext),
              child: builder(dialogContext),
            ),
          ),
        ),
      );
    },
  );
}
