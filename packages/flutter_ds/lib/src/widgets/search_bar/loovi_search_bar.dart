import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../avatar/loovi_avatar.dart';

/// Seed `SearchBar.content` — derived at runtime: [value] when [LooviSearchBar.query]
/// is non-empty, else [placeholder].
enum LooviSearchBarContent { placeholder, value }

/// Seed `SearchBar` (Figma 3881:6002) — compact pill entry that shows a
/// search hint or the current query and launches a SearchView
/// ([onPressed] → compose `LooviSearchViewFullscreen`). It is not a text
/// field. Mode app-cliente.
///
/// Anatomy / paint:
/// - stateLayer: height 56 (`spacing/700`), radius `border/radius/full`,
///   padding horizontal `spacing/050`. Fill `color/background-surface/0`;
///   pressed `interactive/pressed`; disabled `interactive/disabled-surface`.
///   state=focus (real keyboard focus) adds a `interactive/focus` stroke
///   `border/width/025`. Hover does not exist on the app.
/// - leadingAction / firstTrailingAction / secondTrailingAction: 48 × 48
///   (`spacing/600`) text-Button slots with a 24 (`spacing/300`) overlay icon.
///   Leading icon `text/primary`; trailing icons `text/secondary`; disabled
///   `text/placeholder` (all icons).
/// - searchTrigger: padding horizontal `spacing/200`, `body/large/regular`;
///   placeholder `text/secondary` (Figma binding), query `text/primary`,
///   disabled `text/placeholder`.
/// - profileAction: 48-wide slot with Avatar xs (32) — [profileAvatar] or an
///   initials Avatar.
///
/// Nested actions keep their own state (no state layer of their own, as in
/// Figma); each is a named button with a 48 dp target. The bar itself is a
/// named button inside a search container.
class LooviSearchBar extends StatefulWidget {
  const LooviSearchBar({
    super.key,
    this.placeholder = 'Pesquisar',
    this.query,
    this.onPressed,
    this.disabled = false,
    this.showLeadingAction = true,
    this.showFirstTrailingAction = true,
    this.showSecondTrailingAction = false,
    this.showProfileAction = false,
    this.leadingIcon = LooviIcons.menu2Outline,
    this.firstTrailingIcon = LooviIcons.searchOutline,
    this.secondTrailingIcon = LooviIcons.xOutline,
    this.profileAvatar,
    this.profileInitials,
    this.onLeadingAction,
    this.onFirstTrailingAction,
    this.onSecondTrailingAction,
    this.onProfileAction,
    this.leadingActionLabel = 'Menu',
    this.firstTrailingActionLabel = 'Buscar',
    this.secondTrailingActionLabel = 'Limpar busca',
    this.profileActionLabel = 'Perfil',
    this.focusNode,
    this.autofocus = false,
  });

  /// Seed `placeholder` (content=placeholder).
  final String placeholder;

  /// Seed `query` (content=value when non-empty).
  final String? query;

  /// Opens the SearchView.
  final VoidCallback? onPressed;

  /// Seed `state=disabled`.
  final bool disabled;

  final bool showLeadingAction;
  final bool showFirstTrailingAction;
  final bool showSecondTrailingAction;
  final bool showProfileAction;

  /// Seed `leadingIcon` (INSTANCE_SWAP, default `menu-2-outline`).
  final String leadingIcon;

  /// Seed `firstTrailingIcon` (default `search-outline`).
  final String firstTrailingIcon;

  /// Seed `secondTrailingIcon` (default `x-outline`).
  final String secondTrailingIcon;

  /// Seed `profileAvatar` — painted at Avatar xs (32). Null = initials Avatar.
  final Widget? profileAvatar;

  /// Initials of the default Avatar (null/empty = Avatar placeholder).
  final String? profileInitials;

  /// Action taps. Null on the search action falls back to [onPressed].
  final VoidCallback? onLeadingAction;
  final VoidCallback? onFirstTrailingAction;
  final VoidCallback? onSecondTrailingAction;
  final VoidCallback? onProfileAction;

  final String leadingActionLabel;
  final String firstTrailingActionLabel;
  final String secondTrailingActionLabel;
  final String profileActionLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  LooviSearchBarContent get content =>
      (query ?? '').isNotEmpty ? LooviSearchBarContent.value : LooviSearchBarContent.placeholder;

  @override
  State<LooviSearchBar> createState() => _LooviSearchBarState();
}

class _LooviSearchBarState extends State<LooviSearchBar> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => !widget.disabled && widget.onPressed != null;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  void didUpdateWidget(LooviSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _pressed = false;
      _focused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final disabled = widget.disabled;
    final isValue = widget.content == LooviSearchBarContent.value;

    final Color fill;
    if (disabled) {
      fill = t.interactive.disabledSurface;
    } else if (_pressed) {
      fill = t.interactive.pressed;
    } else {
      fill = t.color.backgroundSurface0;
    }
    final leadingColor = disabled ? t.text.placeholder : t.text.primary;
    final trailingColor = disabled ? t.text.placeholder : t.text.secondary;
    final textColor = disabled ? t.text.placeholder : (isValue ? t.text.primary : t.text.secondary);

    Widget action(String icon, Color color, String label, VoidCallback? onTap) =>
        _SearchBarAction(icon: icon, color: color, label: label, enabled: !disabled && onTap != null, onTap: onTap);

    final trigger = Expanded(
      child: ExcludeSemantics(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: t.spacing.s200),
          child: Text(
            isValue ? widget.query! : widget.placeholder,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.typography.bodyLargeRegular.copyWith(color: textColor),
          ),
        ),
      ),
    );

    final row = Row(
      children: [
        if (widget.showLeadingAction)
          action(widget.leadingIcon, leadingColor, widget.leadingActionLabel, widget.onLeadingAction),
        // The trigger text is read through the bar's own label.
        trigger,
        if (widget.showFirstTrailingAction)
          action(
            widget.firstTrailingIcon,
            trailingColor,
            widget.firstTrailingActionLabel,
            widget.onFirstTrailingAction ?? widget.onPressed,
          ),
        if (widget.showSecondTrailingAction)
          action(
            widget.secondTrailingIcon,
            trailingColor,
            widget.secondTrailingActionLabel,
            widget.onSecondTrailingAction,
          ),
        if (widget.showProfileAction)
          Semantics(
            container: true,
            button: true,
            enabled: !disabled && widget.onProfileAction != null,
            label: widget.profileActionLabel,
            excludeSemantics: true,
            onTap: disabled ? null : widget.onProfileAction,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: disabled ? null : widget.onProfileAction,
              child: SizedBox(
                width: t.spacing.s600,
                height: t.spacing.s700,
                child: Center(
                  child: widget.profileAvatar == null
                      ? LooviAvatar(
                          content: LooviAvatarContent.initials,
                          size: LooviAvatarSize.xs,
                          initials: widget.profileInitials,
                          disabled: disabled,
                        )
                      : ClipOval(
                          child: SizedBox.square(
                            dimension: LooviAvatar.boxFor(t, LooviAvatarSize.xs),
                            child: FittedBox(fit: BoxFit.cover, child: widget.profileAvatar),
                          ),
                        ),
                ),
              ),
            ),
          ),
      ],
    );

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(t.radius.full),
        border: (_focused && _enabled) ? Border.all(color: t.interactive.focus, width: t.borderWidth.s025) : null,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.spacing.s700),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: t.spacing.s050),
          child: row,
        ),
      ),
    );

    // The whole pill is the SearchView entry; the nested actions are deeper
    // gesture detectors and win the arena on their own area.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      button: true,
      enabled: _enabled,
      label: isValue ? widget.query : widget.placeholder,
      onTap: _enabled ? widget.onPressed : null,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTapDown: _enabled ? (_) => _setPressed(true) : null,
          onTapUp: _enabled ? (_) => _setPressed(false) : null,
          onTapCancel: _enabled ? () => _setPressed(false) : null,
          onTap: _enabled ? widget.onPressed : null,
          child: bar,
        ),
      ),
    );
  }
}

/// Text Button slot (48 × 48) with the overlay icon (24).
class _SearchBarAction extends StatelessWidget {
  const _SearchBarAction({
    required this.icon,
    required this.color,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String icon;
  final Color color;
  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      onTap: enabled ? onTap : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: SizedBox.square(
          dimension: t.spacing.s600,
          child: Center(
            child: LooviIcon(icon, size: t.spacing.s300, color: color),
          ),
        ),
      ),
    );
  }
}
