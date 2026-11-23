import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_blend.dart';
import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../checkbox/loovi_checkbox.dart' show LooviFocusRingPainter;

/// Seed `AppHeader.layout`.
enum LooviAppHeaderLayout { smallCentered, small, medium, large }

/// Seed `AppHeader.appearance` (`standard` = seed `default`, reserved in Dart).
enum LooviAppHeaderAppearance { standard, inverse }

/// Seed `AppHeader.hierarchy`.
enum LooviAppHeaderHierarchy { global, specific, superApp }

/// AppHeader (Figma 3143:8822) — top app chrome: identifies the screen,
/// navigation and essential actions. Mode app-cliente.
///
/// Intentional sparse matrix (11 published / 24): `global` only
/// `smallCentered` × standard|inverse; `superApp` only `smallCentered` ×
/// standard; `specific` all layouts × standard|inverse. Other combinations
/// assert (no frame to copy).
///
/// Anatomy / paint:
/// - root fill `color/background-surface/0`; inverse
///   `component/app-header/inverse/background` (app-cliente → brand). The
///   fill extends under the status bar ([useSafeArea]); the Figma frame
///   starts below it.
/// - global (Painel Home): pad `spacing/050` vert + `spacing/200` horiz;
///   leadingCluster = Avatar 40 (`spacing/500`) + gap `spacing/150` +
///   greeting `body/large/medium`; trailing search|bell.
/// - small|smallCentered (specific|superApp): pad `spacing/100` vert +
///   `spacing/200` horiz; leading slot 40 (keeper) + headingContent FILL +
///   trailing slot 40 (keeper, specific) / search|bell|profileMenu (superApp).
///   smallCentered centers the title on the full width: both sides reserve
///   the wider slot width (e.g. 88 on superApp), independent of what they show.
/// - medium|large (specific): headerControls (pt `spacing/100`, px
///   `spacing/050`, SPACE_BETWEEN, 40 keepers) above headingContent (px
///   `spacing/200`); root px `spacing/200`, gap `spacing/100`, pb `spacing/150`.
/// - title: local TextHeader (small → `heading/h3/medium`, medium →
///   `heading/h2/medium`, large → `heading/h1/medium`; description
///   `body/small|medium|large/regular`). On small|smallCentered × standard ×
///   specific the title uses `component/app-header/title/*` (app-cliente:
///   14/20 regular) and is upper-cased (seed `appClienteTitleCase`).
/// - actions: Button text/sm icon-only, 40 painted, icon 16; leadingAction
///   fill `component/app-header/leading-action/background` + radius
///   `/leading-action/radius` (standard only — inverse frames have no fill);
///   trailing radius `component/button/container/radius/sm`. Icons
///   `text/primary` (standard) / `text/on-color` (inverse).
/// - avatar (global × inverse): `component/app-header/avatar/background` +
///   icon `component/app-header/avatar/icon-color`; standard:
///   `color/background-surface/3` + `text/primary`.
///
/// Touch targets: every action keeps its Figma paint (40, profileMenu 48) and
/// gets a 48 (`spacing/600`) hit box centered on the slot, overlapping the
/// header padding, so the layout matches the frame (header heights 56/64 =
/// padding + 48). Adjacent 40 slots (search + bell) overlap their 48 boxes.
///
/// Internal pieces (private here): TextHeader (seed 3667:4129), Avatar
/// placeholder (seed 3669:8605, `content=placeholder`), profileMenu.
class LooviAppHeader extends StatelessWidget {
  const LooviAppHeader({
    super.key,
    this.layout = LooviAppHeaderLayout.smallCentered,
    this.appearance = LooviAppHeaderAppearance.standard,
    this.hierarchy = LooviAppHeaderHierarchy.global,
    this.title,
    this.description,
    this.greeting,
    this.showLabel = true,
    this.showAction = true,
    this.showFirstTrailingAction = false,
    this.showSecondTrailingAction = true,
    this.showProfileMenu = true,
    this.avatar,
    this.onLeadingAction,
    this.onFirstTrailingAction,
    this.onSecondTrailingAction,
    this.onProfileMenu,
    this.onAvatarPressed,
    this.leadingActionLabel,
    this.firstTrailingActionLabel = 'Buscar',
    this.secondTrailingActionLabel = 'Notificações',
    this.profileMenuLabel = 'Menu do perfil',
    this.avatarLabel = 'Perfil',
    this.useSafeArea = true,
  }) : assert(
          hierarchy == LooviAppHeaderHierarchy.specific ||
              (layout == LooviAppHeaderLayout.smallCentered &&
                  (hierarchy == LooviAppHeaderHierarchy.global || appearance == LooviAppHeaderAppearance.standard)),
          'LooviAppHeader: combinação não publicada no Figma (global: smallCentered × standard|inverse; '
          'superApp: smallCentered × standard; specific: todos os layouts × standard|inverse).',
        );

  final LooviAppHeaderLayout layout;
  final LooviAppHeaderAppearance appearance;
  final LooviAppHeaderHierarchy hierarchy;

  /// TextHeader title (specific|superApp).
  final String? title;

  /// TextHeader description (specific|superApp). Hidden when null/empty
  /// (Figma exemplars use showDescription=false).
  final String? description;

  /// Greeting TEXT (global only), e.g. "Olá, Rodrigo".
  final String? greeting;

  /// Seed `showLabel`: headingContent (specific|superApp) or greeting (global).
  final bool showLabel;

  /// Seed `showAction`: leadingAction (specific → arrow-left, superApp →
  /// menu-2). The 40 slot is kept when hidden (optical center).
  final bool showAction;

  /// Seed `showFirstTrailingAction` (search-outline, default false).
  final bool showFirstTrailingAction;

  /// Seed `showSecondTrailingAction` (bell-outline, default true).
  final bool showSecondTrailingAction;

  /// Seed `showProfileMenu` — published on superApp only (ignored elsewhere).
  final bool showProfileMenu;

  /// Avatar slot (global leadingCluster 40; superApp profileMenu 24). Clipped
  /// to a circle. Null = Avatar placeholder (user-outline).
  final Widget? avatar;

  final VoidCallback? onLeadingAction;
  final VoidCallback? onFirstTrailingAction;
  final VoidCallback? onSecondTrailingAction;

  /// profileMenu (superApp) — accessible menu button.
  final VoidCallback? onProfileMenu;

  /// Global avatar tap. Null = Avatar is decorative (seed: not interactive).
  final VoidCallback? onAvatarPressed;

  /// Accessible name of the leadingAction. Default "Voltar" (specific) /
  /// "Menu" (superApp).
  final String? leadingActionLabel;
  final String firstTrailingActionLabel;
  final String secondTrailingActionLabel;
  final String profileMenuLabel;
  final String avatarLabel;

  /// Paints the header fill under the top system inset (status bar).
  final bool useSafeArea;

  bool get _inverse => appearance == LooviAppHeaderAppearance.inverse;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final bg = _inverse ? t.component.appHeader.inverseBackground : t.color.backgroundSurface0;
    final top = useSafeArea ? MediaQuery.paddingOf(context).top : t.spacing.s0;
    final body = switch (layout) {
      LooviAppHeaderLayout.medium || LooviAppHeaderLayout.large => _buildTall(context, t),
      _ => _buildCompact(context, t),
    };
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: ColoredBox(
        color: bg,
        child: Padding(padding: EdgeInsets.only(top: top), child: body),
      ),
    );
  }

  // ---------------------------------------------------------------- pieces

  Color _iconColor(LooviTokens t) => _inverse ? t.text.onColor : t.text.primary;

  /// Pressed paint for actions: Button text/sm pressed (`interactive/pressed`,
  /// Plus Darker over an opaque fill). Inverse has no Figma pressed frame:
  /// `color/elevation/inverse-4` overlay (darkens the brand fill).
  Color _pressed(LooviTokens t, Color? base) {
    if (_inverse) return t.color.elevationInverse4;
    return base == null ? t.interactive.pressed : looviPlusDarker(base, t.interactive.pressed);
  }

  Widget _leadingAction(LooviTokens t) {
    final superApp = hierarchy == LooviAppHeaderHierarchy.superApp;
    final Color? fill = _inverse ? null : t.component.appHeader.leadingActionBackground;
    return LooviHeaderIconAction(
      icon: superApp ? LooviIcons.menu2Outline : LooviIcons.arrowLeftOutline,
      semanticLabel: leadingActionLabel ?? (superApp ? 'Menu' : 'Voltar'),
      onPressed: onLeadingAction,
      size: t.spacing.s500,
      iconSize: t.spacing.s200,
      iconColor: _iconColor(t),
      background: fill,
      pressedBackground: _pressed(t, fill),
      radius: t.component.appHeader.leadingActionRadius,
    );
  }

  Widget _trailingAction(LooviTokens t, {required bool first}) => LooviHeaderIconAction(
        icon: first ? LooviIcons.searchOutline : LooviIcons.bellOutline,
        semanticLabel: first ? firstTrailingActionLabel : secondTrailingActionLabel,
        onPressed: first ? onFirstTrailingAction : onSecondTrailingAction,
        size: t.spacing.s500,
        iconSize: t.spacing.s200,
        iconColor: _iconColor(t),
        background: null,
        pressedBackground: _pressed(t, null),
        radius: t.component.button.containerRadiusSm,
      );

  Widget _profileMenu(LooviTokens t) => LooviHeaderIconAction(
        semanticLabel: profileMenuLabel,
        onPressed: onProfileMenu,
        // Figma profileMenu: 48 frame, radius border/radius/200, Avatar micro 24.
        size: t.spacing.s600,
        background: null,
        pressedBackground: _pressed(t, null),
        radius: t.radius.s200,
        child: _AppHeaderAvatar(size: t.spacing.s300, iconSize: t.spacing.s200, inverse: false, child: avatar),
      );

  /// Trailing slots in visual order (left → right), each with its paint width.
  List<_Slot> _trailingSlots(LooviTokens t) {
    final slot = t.spacing.s500;
    return [
      if (showFirstTrailingAction) _Slot(slot, _trailingAction(t, first: true)),
      if (showSecondTrailingAction) _Slot(slot, _trailingAction(t, first: false)),
      if (hierarchy == LooviAppHeaderHierarchy.superApp && showProfileMenu) _Slot(t.spacing.s600, _profileMenu(t)),
    ];
  }

  /// Positions [slots] (right-aligned, ending [right] px from the right edge)
  /// as 48 hit boxes centered on each painted slot.
  List<Widget> _positionTrailing(BuildContext context, List<_Slot> slots, double right, {double? top}) {
    final min = LooviTapTarget.minSize(context);
    final out = <Widget>[];
    var edge = right;
    for (final s in slots.reversed) {
      final box = s.width > min ? s.width : min;
      out.add(_positioned(right: edge - (box - s.width) / 2, top: top, box: box, child: s.child));
      edge += s.width;
    }
    return out;
  }

  Widget _positioned({double? left, double? right, double? top, required double box, required Widget child}) {
    if (top == null) {
      return Positioned(
        left: left,
        right: right,
        top: 0,
        bottom: 0,
        width: box,
        child: Center(child: child),
      );
    }
    return Positioned(left: left, right: right, top: top, width: box, height: box, child: child);
  }

  Widget _titleBlock(LooviTokens t, _TextHeaderSize size, {required bool center}) {
    final themedTitle = hierarchy == LooviAppHeaderHierarchy.specific &&
        !_inverse &&
        (layout == LooviAppHeaderLayout.small || layout == LooviAppHeaderLayout.smallCentered);
    return _TextHeader(
      size: size,
      center: center,
      title: title ?? '',
      description: description,
      inverse: _inverse,
      themedTitle: themedTitle,
      singleLine: size == _TextHeaderSize.small,
    );
  }

  // --------------------------------------------------------------- layouts

  Widget _buildCompact(BuildContext context, LooviTokens t) {
    final min = LooviTapTarget.minSize(context);
    final global = hierarchy == LooviAppHeaderHierarchy.global;
    final padY = global ? t.spacing.s050 : t.spacing.s100;
    final padX = t.spacing.s200;
    final slot = t.spacing.s500;
    final overhang = (min - slot) / 2;

    final trailing = _trailingSlots(t);
    // specific keeps a 40 trailing keeper when nothing is shown (optical center).
    final keeperWidth = trailing.fold<double>(t.spacing.s0, (sum, s) => sum + s.width);
    var trailingWidth = hierarchy == LooviAppHeaderHierarchy.specific && keeperWidth < slot ? slot : keeperWidth;
    var leadingWidth = slot;
    // smallCentered (seed `centeredTitle`): the title is centered on the full
    // header width, whatever the side slots hold — both sides reserve the
    // wider of the two (Figma balances leadingActions to the trailing width).
    if (!global && layout == LooviAppHeaderLayout.smallCentered) {
      final side = trailingWidth > leadingWidth ? trailingWidth : leadingWidth;
      leadingWidth = side;
      trailingWidth = side;
    }

    final overlays = <Widget>[];
    final Widget leading;
    final Widget heading;
    if (global) {
      final avatarWidget = _AppHeaderAvatar(size: slot, iconSize: t.spacing.s300, inverse: _inverse, child: avatar);
      if (onAvatarPressed != null) {
        leading = SizedBox(width: slot, height: slot);
        overlays.add(_positioned(
          left: padX - overhang,
          box: min,
          child: LooviHeaderIconAction(
            semanticLabel: avatarLabel,
            onPressed: onAvatarPressed,
            size: slot,
            background: null,
            pressedBackground: null,
            radius: t.radius.full,
            child: avatarWidget,
          ),
        ));
      } else {
        leading = ExcludeSemantics(child: avatarWidget);
      }
      heading = Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: t.spacing.s150),
          child: showLabel
              ? Semantics(
                  header: true,
                  child: Text(
                    greeting ?? '',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: t.typography.bodyLargeMedium.copyWith(color: _inverse ? t.text.onColor : t.text.primary),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      );
    } else {
      leading = SizedBox(width: leadingWidth, height: slot);
      if (showAction) overlays.add(_positioned(left: padX - overhang, box: min, child: _leadingAction(t)));
      heading = Expanded(
        child: showLabel
            ? _titleBlock(t, _TextHeaderSize.small, center: layout == LooviAppHeaderLayout.smallCentered)
            : const SizedBox.shrink(),
      );
    }
    overlays.addAll(_positionTrailing(context, trailing, padX));

    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: padY * 2 + min),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padX, vertical: padY),
            child: Row(
              children: [
                leading,
                heading,
                SizedBox(width: trailingWidth, height: slot),
              ],
            ),
          ),
        ),
        ...overlays,
      ],
    );
  }

  Widget _buildTall(BuildContext context, LooviTokens t) {
    final min = LooviTapTarget.minSize(context);
    final slot = t.spacing.s500;
    final overhang = (min - slot) / 2;
    final padX = t.spacing.s200;
    final controlsPadX = t.spacing.s050;
    final controlsTop = t.spacing.s100;
    final inset = padX + controlsPadX;

    final trailing = _trailingSlots(t);
    final trailingWidth = trailing.fold<double>(t.spacing.s0, (sum, s) => sum + s.width);
    final size = layout == LooviAppHeaderLayout.large ? _TextHeaderSize.large : _TextHeaderSize.medium;
    final actionTop = controlsTop - overhang;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: padX, right: padX, bottom: t.spacing.s150),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // headerControls: leadingActions + trailingActions (40 keepers), SPACE_BETWEEN.
              Padding(
                padding: EdgeInsets.only(top: controlsTop, left: controlsPadX, right: controlsPadX),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: slot, height: slot),
                    SizedBox(width: trailingWidth > slot ? trailingWidth : slot, height: slot),
                  ],
                ),
              ),
              if (showLabel) ...[
                SizedBox(height: t.spacing.s100),
                // headingContent px 16 (frame: medium raw padding, large `px-[16px]`).
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: t.spacing.s200),
                  child: _titleBlock(t, size, center: false),
                ),
              ],
            ],
          ),
        ),
        if (showAction) _positioned(left: inset - overhang, top: actionTop, box: min, child: _leadingAction(t)),
        ..._positionTrailing(context, trailing, inset, top: actionTop),
      ],
    );
  }
}

class _Slot {
  const _Slot(this.width, this.child);
  final double width;
  final Widget child;
}

// ------------------------------------------------------------- TextHeader

enum _TextHeaderSize { small, medium, large }

/// Local TextHeader (seed 3667:4129): title + optional description.
/// small `heading/h3/medium` + `body/small/regular`; medium `heading/h2/medium`
/// + `body/medium/regular`; large `heading/h1/medium` + `body/large/regular`;
/// gap `spacing/050`. Colors `text/primary|secondary`, inverse
/// `text/on-color|on-color-disabled`.
class _TextHeader extends StatelessWidget {
  const _TextHeader({
    required this.size,
    required this.center,
    required this.title,
    required this.description,
    required this.inverse,
    required this.themedTitle,
    required this.singleLine,
  });

  final _TextHeaderSize size;
  final bool center;
  final String title;
  final String? description;
  final bool inverse;

  /// app-cliente product-theme title (`component/app-header/title/*`) + uppercase.
  final bool themedTitle;
  final bool singleLine;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    var (titleStyle, descStyle) = switch (size) {
      _TextHeaderSize.small => (t.typography.headingH3Medium, t.typography.bodySmallRegular),
      _TextHeaderSize.medium => (t.typography.headingH2Medium, t.typography.bodyMediumRegular),
      _TextHeaderSize.large => (t.typography.headingH1Medium, t.typography.bodyLargeRegular),
    };
    if (themedTitle) {
      final c = t.component.appHeader;
      titleStyle = titleStyle.copyWith(
        fontSize: c.titleFontSize,
        height: c.titleLineHeight / c.titleFontSize,
        fontWeight: c.titleFontWeight,
      );
    }
    final align = center ? TextAlign.center : TextAlign.start;
    final hasDescription = description != null && description!.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          headingLevel: 1,
          label: title,
          excludeSemantics: true,
          child: Text(
            themedTitle ? title.toUpperCase() : title,
            textAlign: align,
            maxLines: singleLine ? 1 : null,
            softWrap: !singleLine,
            overflow: singleLine ? TextOverflow.ellipsis : null,
            style: titleStyle.copyWith(color: inverse ? t.text.onColor : t.text.primary),
          ),
        ),
        if (hasDescription) ...[
          SizedBox(height: t.spacing.s050),
          Text(
            description!,
            textAlign: align,
            style: descStyle.copyWith(color: inverse ? t.text.onColorDisabled : t.text.secondary),
          ),
        ],
      ],
    );
  }
}

// ----------------------------------------------------------------- Avatar

/// Local Avatar (seed 3669:8605). [child] = consumer identity (image,
/// initials) clipped to a circle; null = `content=placeholder`: fill
/// `color/background-surface/3` + user-outline `text/primary`; on global ×
/// inverse `component/app-header/avatar/background|icon-color`.
class _AppHeaderAvatar extends StatelessWidget {
  const _AppHeaderAvatar({required this.size, required this.iconSize, required this.inverse, this.child});

  final double size;
  final double iconSize;
  final bool inverse;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final app = t.component.appHeader;
    return SizedBox.square(
      dimension: size,
      child: ClipOval(
        child: child ??
            ColoredBox(
              color: inverse ? app.avatarBackground : t.color.backgroundSurface3,
              child: Center(
                child: LooviIcon(LooviIcons.userOutline, size: iconSize, color: inverse ? app.avatarIconColor : t.text.primary),
              ),
            ),
      ),
    );
  }
}

// ----------------------------------------------------------------- Action

/// Icon-only header action (internal to AppHeader / SectionHeader): Button
/// variant=text size=sm icon-only with a themed chip fill. LooviButton is not
/// used because it cannot take the product-theme fill/radius and paints 48
/// wide (padding 16 + icon 16 + 16) where the header slots are 40 / 32.
///
/// Paint: [size] square, [background] + [radius]; pressed → [pressedBackground];
/// keyboard focus → ring `interactive/focus` (`border/width/012`, gap
/// `spacing/025`). Hit box ≥ 48 (`spacing/600`) centered on the paint.
class LooviHeaderIconAction extends StatefulWidget {
  const LooviHeaderIconAction({
    super.key,
    this.icon,
    this.child,
    required this.semanticLabel,
    required this.onPressed,
    required this.size,
    this.iconSize,
    this.iconColor,
    required this.background,
    required this.pressedBackground,
    required this.radius,
    this.alignment = Alignment.center,
    this.statesController,
    this.focusNode,
  }) : assert(icon != null || child != null);

  final String? icon;
  final Widget? child;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final double size;
  final double? iconSize;
  final Color? iconColor;
  final Color? background;
  final Color? pressedBackground;
  final double radius;

  /// Where the paint sits inside the >= 48 hit box (default centered).
  final AlignmentGeometry alignment;

  /// Stories/goldens can force [WidgetState.pressed] / [WidgetState.focused].
  final WidgetStatesController? statesController;
  final FocusNode? focusNode;

  @override
  State<LooviHeaderIconAction> createState() => _LooviHeaderIconActionState();
}

class _LooviHeaderIconActionState extends State<LooviHeaderIconAction> {
  WidgetStatesController? _internal;
  WidgetStatesController get _states => widget.statesController ?? (_internal ??= WidgetStatesController());
  bool _focusHighlight = false;

  bool get _enabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
  }

  @override
  void didUpdateWidget(LooviHeaderIconAction old) {
    super.didUpdateWidget(old);
    if (old.statesController != widget.statesController) {
      (old.statesController ?? _internal)?.removeListener(_onStates);
      _states.addListener(_onStates);
    }
  }

  void _onStates() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _states.removeListener(_onStates);
    _internal?.dispose();
    super.dispose();
  }

  void _setPressed(bool v) {
    if (_enabled) _states.update(WidgetState.pressed, v);
  }

  void _activate() {
    if (_enabled) widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final s = _states.value;
    final pressed = _enabled && s.contains(WidgetState.pressed);
    final focused = _enabled && (_focusHighlight || s.contains(WidgetState.focused));
    final radius = BorderRadius.circular(widget.radius);
    final fill = pressed ? (widget.pressedBackground ?? widget.background) : widget.background;

    Widget paint = SizedBox.square(
      dimension: widget.size,
      child: DecoratedBox(
        decoration: BoxDecoration(color: fill, borderRadius: radius),
        child: Center(
          child: widget.child ?? LooviIcon(widget.icon!, size: widget.iconSize, color: widget.iconColor),
        ),
      ),
    );
    if (pressed && widget.child != null && widget.pressedBackground != null) {
      // Overlay over custom content (avatar / profileMenu).
      paint = Stack(children: [
        paint,
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(color: widget.pressedBackground, borderRadius: radius))),
      ]);
    }
    paint = CustomPaint(
      foregroundPainter: focused
          ? LooviFocusRingPainter(
              color: t.interactive.focus,
              gap: t.spacing.s025,
              strokeWidth: t.borderWidth.s012,
              radius: widget.radius,
            )
          : null,
      child: paint,
    );

    final min = LooviTapTarget.minSize(context);
    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: _enabled ? _activate : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            _activate();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _enabled ? _activate : null,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: min, minHeight: min),
            child: Align(alignment: widget.alignment, widthFactor: 1, heightFactor: 1, child: paint),
          ),
        ),
      ),
    );
  }
}
