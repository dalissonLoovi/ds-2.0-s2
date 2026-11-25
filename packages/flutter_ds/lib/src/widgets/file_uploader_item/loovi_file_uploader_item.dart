import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../loading_spinner/loovi_loading_spinner.dart';

/// Seed `FileUploaderItem.size` — row height lg 48 · md 40 · sm 32.
enum LooviFileUploaderItemSize { sm, md, lg }

/// Seed `FileUploaderItem.state` minus `focus` (runtime: keyboard focus on the
/// remove action). `danger-short` / `danger-long` → [dangerShort] /
/// [dangerLong].
enum LooviFileUploaderItemState { uploaded, loading, success, dangerShort, dangerLong }

/// FileUploaderItem (Figma 3581:5641) — one file row inside an upload list.
/// Renders the state the app reports; uploading, retrying and removing are
/// the app's job ([onRemove]).
///
/// Paint (mode app-cliente):
/// - row: height `spacing/600|500|400` (lg|md|sm, a minimum so a larger text
///   scale grows it), padding `spacing/150` × `spacing/100`, gap
///   `spacing/100`, radius `border/radius/150`.
/// - uploaded | loading | success: fill `color/background-surface/1`.
/// - danger-*: fill `color/background-surface/0`, stroke
///   `color/border-feedback/danger` `border/width/025` (inside); divider
///   `color/border/2` `border/width/012` inset `spacing/025`; error block
///   padding-x `spacing/150`, padding-y per Figma frame (see
///   [errorPaddingY]), gap `spacing/100`.
/// - fileName `body/medium/regular` `text/primary`, ellipsis.
/// - removeAction `x-outline` 16 (`spacing/200`) `text/primary`; focus ring
///   `interactive/focus` `border/width/025`, radius `border/radius/100`.
/// - loading: LoadingSpinner (size=sm geometry) resized to 16, decorative.
/// - success icon `circle-check-filled` 16 `feedback/success` (icon next to
///   the file name).
/// - danger icon `alert-circle-filled` 16 `feedback/danger`.
/// - errorMessage `body/small/regular` `text/danger` (AA); errorDescription
///   (danger-long) `body/small/regular` `text/secondary`.
///
/// Accessibility: the row announces [fileName] plus the status value
/// ([loadingSemanticValue], [successSemanticValue] or the error texts) as a
/// polite live region. The remove action is a separate button named
/// "Remover arquivo {fileName}"; its touch area spans the row height and
/// ~44 dp wide at the right edge without changing the row size (rows are
/// 32/40/48 tall in Figma).
class LooviFileUploaderItem extends StatefulWidget {
  const LooviFileUploaderItem({
    super.key,
    required this.fileName,
    this.size = LooviFileUploaderItemSize.lg,
    this.state = LooviFileUploaderItemState.uploaded,
    this.shortDescription = '',
    this.longDescription = '',
    this.onRemove,
    this.removeSemanticLabel,
    this.loadingSemanticValue = 'Enviando',
    this.successSemanticValue = 'Enviado',
    this.removeStatesController,
    this.removeFocusNode,
  });

  /// Seed `fileName`.
  final String fileName;

  final LooviFileUploaderItemSize size;
  final LooviFileUploaderItemState state;

  /// Seed `shortDescription`: validation message on danger states.
  final String shortDescription;

  /// Seed `longDescription`: secondary detail on [LooviFileUploaderItemState.dangerLong].
  final String longDescription;

  /// Remove action (shown on uploaded and danger states, as in Figma). Null =
  /// the icon is painted but inert.
  final VoidCallback? onRemove;

  /// Accessible name of the remove action. Default "Remover arquivo {fileName}".
  final String? removeSemanticLabel;

  /// Status announced while loading.
  final String loadingSemanticValue;

  /// Status announced on success.
  final String successSemanticValue;

  /// Optional external states of the remove action. Stories and goldens can
  /// force [WidgetState.focused] (seed `state=focus`).
  final WidgetStatesController? removeStatesController;

  final FocusNode? removeFocusNode;

  bool get isDanger =>
      state == LooviFileUploaderItemState.dangerShort || state == LooviFileUploaderItemState.dangerLong;

  bool get showsRemove => state == LooviFileUploaderItemState.uploaded || isDanger;

  /// Row height of [size].
  static double rowHeightFor(LooviTokens t, LooviFileUploaderItemSize size) => switch (size) {
        LooviFileUploaderItemSize.lg => t.spacing.s600,
        LooviFileUploaderItemSize.md => t.spacing.s500,
        LooviFileUploaderItemSize.sm => t.spacing.s400,
      };

  /// Vertical padding of the error block, exactly as the Figma frames
  /// (inconsistent across sizes — reported).
  static double errorPaddingY(LooviTokens t, LooviFileUploaderItemSize size, LooviFileUploaderItemState state) {
    final long = state == LooviFileUploaderItemState.dangerLong;
    return switch (size) {
      LooviFileUploaderItemSize.lg => t.spacing.s200,
      LooviFileUploaderItemSize.md => long ? t.spacing.s150 : t.spacing.s200,
      LooviFileUploaderItemSize.sm => long ? t.spacing.s100 : t.spacing.s150,
    };
  }

  @override
  State<LooviFileUploaderItem> createState() => _LooviFileUploaderItemState();
}

class _LooviFileUploaderItemState extends State<LooviFileUploaderItem> {
  WidgetStatesController? _internalStates;
  WidgetStatesController get _states => widget.removeStatesController ?? (_internalStates ??= WidgetStatesController());
  bool _focusHighlight = false;

  bool get _removeEnabled => widget.showsRemove && widget.onRemove != null;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
  }

  @override
  void didUpdateWidget(LooviFileUploaderItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.removeStatesController != widget.removeStatesController) {
      (oldWidget.removeStatesController ?? _internalStates)?.removeListener(_onStates);
      _states.addListener(_onStates);
    }
  }

  void _onStates() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _states.removeListener(_onStates);
    _internalStates?.dispose();
    super.dispose();
  }

  void _remove() {
    if (_removeEnabled) widget.onRemove?.call();
  }

  String? get _statusValue => switch (widget.state) {
        LooviFileUploaderItemState.uploaded => null,
        LooviFileUploaderItemState.loading => widget.loadingSemanticValue,
        LooviFileUploaderItemState.success => widget.successSemanticValue,
        LooviFileUploaderItemState.dangerShort => widget.shortDescription,
        LooviFileUploaderItemState.dangerLong =>
          [widget.shortDescription, widget.longDescription].where((s) => s.isNotEmpty).join('. '),
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final icon = t.spacing.s200;
    final rowHeight = LooviFileUploaderItem.rowHeightFor(t, widget.size);
    final focused = _removeEnabled && (_focusHighlight || _states.value.contains(WidgetState.focused));

    Widget removeIcon = SizedBox.square(
      key: const Key('loovi-file-uploader-item-remove'),
      dimension: icon,
      child: LooviIcon(LooviIcons.xOutline, size: icon, color: t.text.primary),
    );
    if (focused) {
      removeIcon = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(t.radius.s100),
          border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
        ),
        child: removeIcon,
      );
    }

    final trailing = <Widget>[
      if (widget.state == LooviFileUploaderItemState.loading)
        LooviLoadingSpinner(size: LooviLoadingSpinnerSize.sm, dimension: icon, decorative: true),
      if (widget.state == LooviFileUploaderItemState.success)
        LooviIcon(LooviIcons.circleCheckFilled, size: icon, color: t.feedback.success),
      if (widget.isDanger) LooviIcon(LooviIcons.alertCircleFilled, size: icon, color: t.feedback.danger),
      if (widget.showsRemove) removeIcon,
    ];

    // Figma rows are FIXED 48/40/32 with padding-y spacing/100: on sm the
    // 20 px line + 16 px padding does not fit (Figma lets it overflow), so the
    // height is the minimum and the content is centered (padding-y implied).
    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: rowHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: t.spacing.s150),
        child: Row(
          children: [
            Expanded(
              // Announced by the row semantics label.
              child: ExcludeSemantics(
                child: Text(
                  widget.fileName,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: t.typography.bodyMediumRegular.copyWith(color: t.text.primary),
                ),
              ),
            ),
            for (final w in trailing) ...[SizedBox(width: t.spacing.s100), w],
          ],
        ),
      ),
    );

    // Remove touch area: full row height, from the right edge to ~24 dp past
    // the icon center (48 dp square centered on the icon, clipped to the row).
    Widget topRow = row;
    if (widget.showsRemove) {
      final min = LooviTapTarget.minSize(context);
      final width = t.spacing.s150 + icon / 2 + min / 2;
      topRow = Stack(
        children: [
          row,
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: width,
            child: Semantics(
              container: true,
              button: true,
              enabled: _removeEnabled,
              label: widget.removeSemanticLabel ?? 'Remover arquivo ${widget.fileName}',
              onTap: _removeEnabled ? _remove : null,
              excludeSemantics: true,
              child: FocusableActionDetector(
                enabled: _removeEnabled,
                focusNode: widget.removeFocusNode,
                onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
                actions: {
                  ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
                    _remove();
                    return null;
                  }),
                },
                child: GestureDetector(
                  key: const Key('loovi-file-uploader-item-remove-target'),
                  behavior: HitTestBehavior.opaque,
                  onTap: _removeEnabled ? _remove : null,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final radius = BorderRadius.circular(t.radius.s150);
    final Widget body;
    if (widget.isDanger) {
      final caption = t.typography.bodySmallRegular; // Figma aligned 2026-11-25 (was caption/medium 9 px).
      body = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: t.color.borderFeedbackDanger, width: t.borderWidth.s025),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: t.color.backgroundSurface0, borderRadius: radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              topRow,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: t.spacing.s025),
                child: Divider(height: t.borderWidth.s012, thickness: t.borderWidth.s012, color: t.color.border2),
              ),
              ExcludeSemantics(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: t.spacing.s150,
                    vertical: LooviFileUploaderItem.errorPaddingY(t, widget.size, widget.state),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.shortDescription, style: caption.copyWith(color: t.text.danger)),
                      if (widget.state == LooviFileUploaderItemState.dangerLong && widget.longDescription.isNotEmpty) ...[
                        SizedBox(height: t.spacing.s100),
                        Text(widget.longDescription, style: caption.copyWith(color: t.text.secondary)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      body = DecoratedBox(
        decoration: BoxDecoration(color: t.color.backgroundSurface1, borderRadius: radius),
        child: topRow,
      );
    }

    final status = _statusValue;
    // Row semantics: file name + status. The remove button stays a separate
    // node (explicitChildNodes) so it keeps its own name and action.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.fileName,
      value: status,
      liveRegion: status != null ? true : null,
      child: body,
    );
  }
}
