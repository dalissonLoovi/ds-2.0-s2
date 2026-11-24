import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../loading_spinner/loovi_loading_spinner.dart';

/// Seed `Avatar.content`.
enum LooviAvatarContent { image, initials, placeholder }

/// Seed `Avatar.size`: micro 24 · xs 32 · sm 48 · md 64 · lg 80 · xl 96
/// (Figma 3669:8605 — the React map 16…56 is the Escritório Virtual scale).
enum LooviAvatarSize { micro, xs, sm, md, lg, xl }

/// Avatar (Figma 3669:8605) — identity of a user, customer, driver or account.
///
/// Seed `state` maps to runtime: `hover` only when a pointer reports it (no
/// hover on the mobile app), `focus` from keyboard focus-visible; `disabled`
/// and `loading` are props. The avatar is NOT interactive by default; pass
/// [onPressed] when it is the AvatarButton / AvatarUpload wrapper (button
/// semantics, focus ring, 48 dp target).
///
/// Paint (mode app-cliente):
/// - shell: circle, box `spacing/300|400|600|800|1000|1200`
///   (micro|xs|sm|md|lg|xl), radius `border/radius/full`.
/// - initials | placeholder: fill `color/background-surface/3`.
/// - image: the photo (cover), no surface/3 shell.
/// - initials: `text/primary` (disabled `text/placeholder`); style by size
///   body/small · body/large · heading/h3 · heading/h2 · heading/h1 ·
///   display/large (all regular). Max 2 characters, scaled down if the system
///   text scale would overflow the circle.
/// - placeholder: `user-outline` in `text/placeholder`; icon box
///   `spacing/200|200|300|400|500|700` (micro…xl), same for the upload icon.
/// - hover: `color/elevation/4` overlay (Figma #3A3345 @ 16 %) and the
///   `upload-outline` icon replaces the content — `text/primary` on
///   initials | placeholder; on image an extra `color/elevation/inverse-3`
///   overlay and the icon in `color/background-surface/0` (Figma value).
/// - focus: `border/width/025` ring in `interactive/focus`, `spacing/025` gap
///   outside the shell.
/// - loading: `color/elevation/4` overlay + [LooviLoadingSpinner] (size=sm
///   geometry) at `spacing/200|200|250|300|400|400`; initials / placeholder
///   content hidden, image kept.
/// - disabled: initials in `text/placeholder`; image and placeholder
///   unchanged; no interaction.
class LooviAvatar extends StatefulWidget {
  const LooviAvatar({
    super.key,
    this.content = LooviAvatarContent.placeholder,
    this.size = LooviAvatarSize.md,
    this.image,
    this.initials,
    this.disabled = false,
    this.loading = false,
    this.onPressed,
    this.semanticLabel,
    this.loadingSemanticValue = 'Carregando',
    this.statesController,
    this.focusNode,
    this.autofocus = false,
  });

  /// Seed `content`. Falls back to [LooviAvatarContent.placeholder] when the
  /// matching data ([image] / [initials]) is missing.
  final LooviAvatarContent content;
  final LooviAvatarSize size;

  /// Photo for `content=image`.
  final ImageProvider? image;

  /// Initials for `content=initials` (first 2 characters, upper-cased).
  final String? initials;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Seed `state=loading`.
  final bool loading;

  /// Makes the avatar interactive (AvatarButton / AvatarUpload role).
  final VoidCallback? onPressed;

  /// Accessible name. Static avatar without it = decorative (seed:
  /// "decorative or described by surrounding content"). Interactive avatars
  /// should always set it (e.g. "Alterar foto de perfil").
  final String? semanticLabel;

  /// Semantics value announced while [loading].
  final String loadingSemanticValue;

  /// Optional external interaction states (stories and goldens force
  /// [WidgetState.hovered] / [WidgetState.focused]).
  final WidgetStatesController? statesController;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Shell box of [size].
  static double boxFor(LooviTokens t, LooviAvatarSize size) => switch (size) {
        LooviAvatarSize.micro => t.spacing.s300,
        LooviAvatarSize.xs => t.spacing.s400,
        LooviAvatarSize.sm => t.spacing.s600,
        LooviAvatarSize.md => t.spacing.s800,
        LooviAvatarSize.lg => t.spacing.s1000,
        LooviAvatarSize.xl => t.spacing.s1200,
      };

  /// user / upload icon box of [size].
  static double iconFor(LooviTokens t, LooviAvatarSize size) => switch (size) {
        LooviAvatarSize.micro || LooviAvatarSize.xs => t.spacing.s200,
        LooviAvatarSize.sm => t.spacing.s300,
        LooviAvatarSize.md => t.spacing.s400,
        LooviAvatarSize.lg => t.spacing.s500,
        LooviAvatarSize.xl => t.spacing.s700,
      };

  /// LoadingSpinner box of [size].
  static double spinnerFor(LooviTokens t, LooviAvatarSize size) => switch (size) {
        LooviAvatarSize.micro || LooviAvatarSize.xs => t.spacing.s200,
        LooviAvatarSize.sm => t.spacing.s250,
        LooviAvatarSize.md => t.spacing.s300,
        LooviAvatarSize.lg || LooviAvatarSize.xl => t.spacing.s400,
      };

  /// Initials text style of [size] (seed tokenRules).
  static TextStyle initialsStyleFor(LooviTokens t, LooviAvatarSize size) => switch (size) {
        LooviAvatarSize.micro => t.typography.bodySmallRegular,
        LooviAvatarSize.xs => t.typography.bodyLargeRegular,
        LooviAvatarSize.sm => t.typography.headingH3Regular,
        LooviAvatarSize.md => t.typography.headingH2Regular,
        LooviAvatarSize.lg => t.typography.headingH1Regular,
        LooviAvatarSize.xl => t.typography.displayLargeRegular,
      };

  /// Content actually painted (fallback to placeholder without data).
  LooviAvatarContent get resolvedContent => switch (content) {
        LooviAvatarContent.image when image == null => LooviAvatarContent.placeholder,
        LooviAvatarContent.initials when (initials ?? '').trim().isEmpty => LooviAvatarContent.placeholder,
        _ => content,
      };

  /// First two characters of [initials], upper-cased.
  String get displayInitials => String.fromCharCodes((initials ?? '').trim().runes.take(2)).toUpperCase();

  @override
  State<LooviAvatar> createState() => _LooviAvatarState();
}

class _LooviAvatarState extends State<LooviAvatar> {
  WidgetStatesController? _internalStates;
  WidgetStatesController get _states => widget.statesController ?? (_internalStates ??= WidgetStatesController());
  bool _focusHighlight = false;

  bool get _interactive => widget.onPressed != null && !widget.disabled && !widget.loading;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
  }

  @override
  void didUpdateWidget(LooviAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      (oldWidget.statesController ?? _internalStates)?.removeListener(_onStates);
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

  void _activate() {
    if (_interactive) widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final box = LooviAvatar.boxFor(t, widget.size);
    final iconBox = LooviAvatar.iconFor(t, widget.size);
    final content = widget.resolvedContent;
    final isImage = content == LooviAvatarContent.image;
    final states = _states.value;
    // Hover / focus are interaction feedback: never on disabled or loading.
    final canShowState = !widget.disabled && !widget.loading;
    final hovered = canShowState && states.contains(WidgetState.hovered);
    final focused = canShowState && (_focusHighlight || states.contains(WidgetState.focused));

    final layers = <Widget>[];
    if (isImage) {
      layers.add(Image(image: widget.image!, fit: BoxFit.cover, excludeFromSemantics: true));
    }
    if (hovered && isImage) layers.add(ColoredBox(color: t.color.elevationInverse3));
    if (hovered || widget.loading) layers.add(ColoredBox(color: t.color.elevation4));

    Widget? center;
    if (widget.loading) {
      center = LooviLoadingSpinner(
        size: LooviLoadingSpinnerSize.sm,
        dimension: LooviAvatar.spinnerFor(t, widget.size),
        decorative: true,
      );
    } else if (hovered) {
      center = LooviIcon(
        LooviIcons.uploadOutline,
        size: iconBox,
        color: isImage ? t.color.backgroundSurface0 : t.text.primary,
      );
    } else if (content == LooviAvatarContent.initials) {
      center = Padding(
        padding: EdgeInsets.all(t.spacing.s025),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.displayInitials,
            maxLines: 1,
            softWrap: false,
            textAlign: TextAlign.center,
            style: LooviAvatar.initialsStyleFor(t, widget.size).copyWith(
              color: widget.disabled ? t.text.placeholder : t.text.primary,
            ),
          ),
        ),
      );
    } else if (content == LooviAvatarContent.placeholder) {
      center = LooviIcon(LooviIcons.userOutline, size: iconBox, color: t.text.placeholder);
    }
    if (center != null) layers.add(Center(child: center));

    final stack = Stack(fit: StackFit.expand, children: layers);
    Widget shell = SizedBox.square(
      dimension: box,
      child: ClipOval(
        child: isImage ? stack : ColoredBox(color: t.color.backgroundSurface3, child: stack),
      ),
    );

    if (focused) {
      final gap = t.spacing.s025;
      final ring = t.borderWidth.s025;
      shell = Stack(
        clipBehavior: Clip.none,
        children: [
          shell,
          Positioned(
            left: -(gap + ring),
            top: -(gap + ring),
            right: -(gap + ring),
            bottom: -(gap + ring),
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: t.interactive.focus, width: ring),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (widget.onPressed == null) {
      if (widget.semanticLabel == null && !widget.loading) return ExcludeSemantics(child: shell);
      return Semantics(
        container: true,
        image: widget.semanticLabel != null,
        label: widget.semanticLabel,
        value: widget.loading ? widget.loadingSemanticValue : null,
        liveRegion: widget.loading ? true : null,
        child: ExcludeSemantics(child: shell),
      );
    }

    final min = LooviTapTarget.minSize(context);
    return Semantics(
      container: true,
      button: true,
      enabled: _interactive,
      label: widget.semanticLabel,
      value: widget.loading ? widget.loadingSemanticValue : null,
      liveRegion: widget.loading ? true : null,
      onTap: _interactive ? _activate : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _interactive,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        // Pointer hover only (web / desktop); touch devices never report it.
        onShowHoverHighlight: (v) => _states.update(WidgetState.hovered, v && _interactive),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            _activate();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _interactive ? _activate : null,
          // Touch target >= 48 (spacing/600): micro|xs paint 24|32, the hit
          // area grows outside the paint.
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: min, minHeight: min),
            child: Center(widthFactor: 1, heightFactor: 1, child: shell),
          ),
        ),
      ),
    );
  }
}
