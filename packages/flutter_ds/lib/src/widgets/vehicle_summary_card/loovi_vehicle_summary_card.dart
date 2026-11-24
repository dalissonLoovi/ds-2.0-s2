import 'package:flutter_svg/flutter_svg.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../chip_tag/loovi_chip_tag.dart';

/// Seed `VehicleSummaryCard.appearance`. `default` is a reserved word in
/// Dart, so the seed value `default` maps to [standard].
enum LooviVehicleSummaryCardAppearance {
  /// Seed `default`: surface/0 card with brand + model, plate and status tag.
  standard,

  /// Seed `secondary`: informational brand strip (no tag, not clickable).
  secondary,
}

/// Seed `VehicleSummaryCard.status` (meaningful on
/// [LooviVehicleSummaryCardAppearance.standard] only).
enum LooviVehicleSummaryCardStatus { active, inactive }

/// Seed `VehicleSummaryCard.illustration` — local illustrations
/// `illustration / vehicle-icon / sedan|van|suv` (Figma 4468:121 / 4468:122 /
/// 4468:123), exported as SVG into `assets/illustrations/vehicle/`.
enum LooviVehicleIllustration { sedan, van, suv }

/// Vehicle illustration (seed `illustration / vehicle-icon / *`), drawn at the
/// asset's intrinsic 52 × 52 (illustration geometry, not layout — no token).
///
/// The illustration palette is hardcoded in the asset on purpose (seed:
/// "dedicated illustration palette — intentional exception; do not remap to
/// semantic tokens"). Decorative by default.
class LooviVehicleIllustrationView extends StatelessWidget {
  const LooviVehicleIllustrationView(this.illustration, {super.key, this.semanticLabel});

  final LooviVehicleIllustration illustration;

  /// Null = decorative (adjacent text names the vehicle).
  final String? semanticLabel;

  /// Asset path inside package `loovi_ds`.
  static String assetFor(LooviVehicleIllustration i) => 'assets/illustrations/vehicle/${i.name}.svg';

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(assetFor(illustration), package: 'loovi_ds', excludeFromSemantics: true);
    if (semanticLabel == null) return ExcludeSemantics(child: svg);
    return Semantics(label: semanticLabel, image: true, child: svg);
  }
}

/// VehicleSummaryCard (Figma 4581:1451) — Home/Painel compact card for a user
/// vehicle.
///
/// appearance=default ([LooviVehicleSummaryCardAppearance.standard]):
/// - surface `color/background-surface/0`, radius `border/radius/400`,
///   padding `spacing/200` (h) / `spacing/100` (v), root gap `spacing/200`.
/// - leading: illustration + `spacing/100` + text (nameRow = [brandModel]
///   body/medium/regular + `spacing/050` + [model] body/medium/semi-bold,
///   `text/primary`; [plate] heading/h3/regular `text/secondary`, AA since 2026-11-24).
/// - spacer + statusChip ([showStatus] toggles both): [LooviChipTag]
///   outline/sm with a `circle-dot-filled` dot — active
///   `color/background-feedback-primary/success`, inactive
///   `color/background-feedback-primary/warning` (intentional, not danger).
///   The ChipTag is not restyled: the colored dot rides in its avatar slot
///   (same 20 dp frame as leadingIcon) because ChipTag paints its leading
///   icon with the label color.
/// - optional [onPressed] (product wires it to the vehicle detail): button
///   semantics + `interactive/pressed` wash (runtime only; no Figma variant).
///
/// appearance=secondary: informational only — surface
/// `color/background-surface/brand-muted` (72 % alpha baked in the token),
/// radius `border/radius/300`, gap `spacing/150`; [title] body/large/semi-bold
/// and [plate] body/medium/regular in `text/on-color`, text gap `spacing/025`.
/// No tag, never clickable ([onPressed] is ignored).
class LooviVehicleSummaryCard extends StatefulWidget {
  const LooviVehicleSummaryCard({
    super.key,
    this.appearance = LooviVehicleSummaryCardAppearance.standard,
    this.status = LooviVehicleSummaryCardStatus.active,
    this.brandModel = 'Marca',
    this.model = 'Modelo',
    this.title = '',
    required this.plate,
    this.illustration = LooviVehicleIllustration.sedan,
    this.showStatus = true,
    this.activeLabel = 'Ativo',
    this.inactiveLabel = 'Inativo',
    this.onPressed,
    this.semanticLabel,
  });

  final LooviVehicleSummaryCardAppearance appearance;

  /// Seed `status` (standard only).
  final LooviVehicleSummaryCardStatus status;

  /// Seed `brandModel` — brand label (standard only).
  final String brandModel;

  /// Seed `model` — model label (standard only).
  final String model;

  /// Seed `title` — model + year line composed by the product (secondary only).
  final String title;

  /// Seed `plate` (both appearances).
  final String plate;

  /// Seed `illustration` (both appearances), default sedan.
  final LooviVehicleIllustration illustration;

  /// Seed `showStatus` (standard only) — toggles statusChip + spacer.
  final bool showStatus;

  /// ChipTag label for status=active (seed "Ativo").
  final String activeLabel;

  /// ChipTag label for status=inactive (seed "Inativo").
  final String inactiveLabel;

  /// Standard only: makes the card a button to the vehicle detail.
  final VoidCallback? onPressed;

  /// Overrides the accessible name (default: visible texts joined).
  final String? semanticLabel;

  @override
  State<LooviVehicleSummaryCard> createState() => _LooviVehicleSummaryCardState();
}

class _LooviVehicleSummaryCardState extends State<LooviVehicleSummaryCard> {
  bool _pressed = false;
  bool _focused = false;

  bool get _secondary => widget.appearance == LooviVehicleSummaryCardAppearance.secondary;
  bool get _interactive => !_secondary && widget.onPressed != null;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  void didUpdateWidget(LooviVehicleSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive) {
      _pressed = false;
      _focused = false;
    }
  }

  String get _statusLabel =>
      widget.status == LooviVehicleSummaryCardStatus.active ? widget.activeLabel : widget.inactiveLabel;

  String get _label {
    if (widget.semanticLabel != null) return widget.semanticLabel!;
    if (_secondary) return '${widget.title}, ${widget.plate}';
    return [
      '${widget.brandModel} ${widget.model}',
      widget.plate,
      if (widget.showStatus) _statusLabel,
    ].join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final secondary = _secondary;
    final radius = BorderRadius.circular(secondary ? t.radius.s300 : t.radius.s400);

    final Widget text;
    if (secondary) {
      final style = TextStyle(color: t.text.onColor);
      text = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.typography.bodyLargeSemiBold.merge(style)),
          SizedBox(height: t.spacing.s025),
          Text(widget.plate, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.typography.bodyMediumRegular.merge(style)),
        ],
      );
    } else {
      text = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(children: [
              TextSpan(text: widget.brandModel, style: t.typography.bodyMediumRegular.copyWith(color: t.text.primary)),
              // nameRow gap spacing/050 between the two TEXT nodes.
              WidgetSpan(child: SizedBox(width: t.spacing.s050)),
              TextSpan(text: widget.model, style: t.typography.bodyMediumSemiBold.copyWith(color: t.text.primary)),
            ]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(widget.plate, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.typography.headingH3Regular.copyWith(color: t.text.secondary)),
        ],
      );
    }

    final leadingGap = secondary ? t.spacing.s150 : t.spacing.s100;
    final leading = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LooviVehicleIllustrationView(widget.illustration),
        SizedBox(width: leadingGap),
        Flexible(child: text),
      ],
    );

    final showChip = !secondary && widget.showStatus;
    final rowChildren = <Widget>[
      if (showChip) ...[
        // spacer (fill) + root gap spacing/200 before the chip.
        Expanded(child: leading),
        SizedBox(width: t.spacing.s200),
        LooviChipTag(
          label: _statusLabel,
          size: LooviChipTagSize.sm,
          intent: LooviChipTagIntent.outline,
          avatar: LooviIcon(
            LooviIcons.circleDotFilled,
            size: t.spacing.s250,
            color: widget.status == LooviVehicleSummaryCardStatus.active
                ? t.color.backgroundFeedbackPrimarySuccess
                : t.color.backgroundFeedbackPrimaryWarning,
          ),
        ),
      ] else
        Flexible(child: leading),
    ];

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: secondary ? t.color.backgroundSurfaceBrandMuted : t.color.backgroundSurface0,
        borderRadius: radius,
      ),
      child: Stack(
        children: [
          if (_pressed)
            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(color: t.interactive.pressed, borderRadius: radius))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: t.spacing.s100),
            child: Row(children: rowChildren),
          ),
          if (_focused)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (_interactive) {
      card = FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onPressed,
          excludeFromSemantics: true,
          child: card,
        ),
      );
    }

    return Semantics(
      container: true,
      button: _interactive,
      focusable: _interactive,
      focused: _interactive ? _focused : null,
      label: _label,
      onTap: _interactive ? widget.onPressed : null,
      child: ExcludeSemantics(child: card),
    );
  }
}
