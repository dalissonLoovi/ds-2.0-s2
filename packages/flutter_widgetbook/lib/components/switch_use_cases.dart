import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Switch (seed node 3653:4741) — Playground + States, mode app-cliente.
WidgetbookComponent looviSwitchComponent() => WidgetbookComponent(
      name: 'Switch',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'Switch',
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: _InteractiveSwitch(
                initial: context.knobs.boolean(label: 'checked'),
                size: context.knobs.object.dropdown<LooviSwitchSize>(
                  label: 'size',
                  options: LooviSwitchSize.values,
                  labelBuilder: (v) => v.name,
                ),
                showIcon: context.knobs.boolean(label: 'showIcon (md only)'),
                disabled: context.knobs.boolean(label: 'disabled (state=disabled)'),
                focus: context.knobs.boolean(label: 'focus ring (state=focus)'),
              ),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) {
            final t = LooviTokens.of(context);
            Widget row(String title, LooviSwitchSize size, {bool icon = false}) => Padding(
                  padding: EdgeInsets.only(bottom: t.spacing.s200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
                      Wrap(
                        spacing: t.spacing.s100,
                        children: [
                          for (final (disabled, focus) in [(false, false), (false, true), (true, false)])
                            for (final checked in [false, true])
                              LooviSwitch(
                                checked: checked,
                                onChanged: disabled ? null : (_) {},
                                size: size,
                                showIcon: icon,
                                forceFocusRing: focus,
                                semanticLabel: 'checked=$checked',
                              ),
                        ],
                      ),
                    ],
                  ),
                );
            return SeedStory(
              component: 'Switch',
              showDescription: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('default · focus · disabled — off / on', style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
                  SizedBox(height: t.spacing.s100),
                  row('size=md', LooviSwitchSize.md),
                  row('size=md · showIcon', LooviSwitchSize.md, icon: true),
                  row('size=sm', LooviSwitchSize.sm),
                ],
              ),
            );
          },
        ),
      ],
    );

class _InteractiveSwitch extends StatefulWidget {
  const _InteractiveSwitch({required this.initial, required this.size, required this.showIcon, required this.disabled, required this.focus});

  final bool initial;
  final LooviSwitchSize size;
  final bool showIcon;
  final bool disabled;
  final bool focus;

  @override
  State<_InteractiveSwitch> createState() => _InteractiveSwitchState();
}

class _InteractiveSwitchState extends State<_InteractiveSwitch> {
  late bool _value = widget.initial;

  @override
  void didUpdateWidget(_InteractiveSwitch old) {
    super.didUpdateWidget(old);
    if (old.initial != widget.initial) _value = widget.initial;
  }

  @override
  Widget build(BuildContext context) => LooviSwitch(
        checked: _value,
        onChanged: (v) => setState(() => _value = v),
        size: widget.size,
        showIcon: widget.showIcon,
        disabled: widget.disabled,
        forceFocusRing: widget.focus,
        semanticLabel: 'Notificações',
      );
}
