import 'package:loovi_ds/loovi_ds.dart';
// ignore: implementation_imports — direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Button (seed node 3104:3723) — Playground + Matrix.
/// `state` of the seed: pressed/focus come from touch/keyboard; selected,
/// disabled and loading are knobs. Hover is not used on the app.
WidgetbookComponent looviButtonComponent() => WidgetbookComponent(
      name: 'Button',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final fullWidth = k.boolean(label: 'fullWidth');
            final button = LooviButton(
              label: k.string(label: 'label', initialValue: 'Continuar'),
              onPressed: () {},
              variant: k.object.dropdown<LooviButtonVariant>(
                label: 'variant',
                options: LooviButtonVariant.values,
                labelBuilder: (v) => v.name,
              ),
              size: k.object.dropdown<LooviButtonSize>(
                label: 'size',
                options: LooviButtonSize.values,
                initialOption: LooviButtonSize.md,
                labelBuilder: (v) => v.name,
              ),
              intent: k.object.dropdown<LooviButtonIntent>(
                label: 'intent',
                options: LooviButtonIntent.values,
                labelBuilder: (v) => v.name,
              ),
              showLabel: k.boolean(label: 'showLabel', initialValue: true),
              showIcon: k.boolean(label: 'showIcon'),
              leadingIcon: k.object.dropdown<String>(
                label: 'Icon (leadingIcon)',
                options: LooviIcons.all.toList(),
                initialOption: LooviIcons.plusOutline,
              ),
              showTrailingIcon: k.boolean(label: 'showTrailingIcon'),
              trailingIcon: k.object.dropdown<String>(
                label: 'trailingIcon',
                options: LooviIcons.all.toList(),
                initialOption: LooviIcons.chevronRightOutline,
              ),
              selected: k.boolean(label: 'state=selected'),
              loading: k.boolean(label: 'loading'),
              disabled: k.boolean(label: 'disabled'),
              fullWidth: fullWidth,
            );
            return SeedStory(
              component: 'Button',
              child: fullWidth ? button : Align(alignment: Alignment.centerLeft, child: button),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Matrix',
          builder: (context) => const SeedStory(component: 'Button', showDescription: false, child: _ButtonMatrix()),
        ),
      ],
    );

/// variant × intent × state (md) + sizes — what the seed publishes
/// (secondary only on solid; hover omitted). Pressed/focus are forced with a
/// [WidgetStatesController]. Same layout as the golden `button_matrix.png`.
class _ButtonMatrix extends StatelessWidget {
  const _ButtonMatrix();

  static const _states = ['default', 'pressed', 'focus', 'selected', 'disabled', 'loading'];

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget cell(LooviButtonVariant v, LooviButtonIntent i, String state) => LooviButton(
          label: 'Label',
          onPressed: () {},
          variant: v,
          intent: i,
          selected: state == 'selected',
          disabled: state == 'disabled',
          loading: state == 'loading',
          statesController: switch (state) {
            'pressed' => WidgetStatesController({WidgetState.pressed}),
            'focus' => WidgetStatesController({WidgetState.focused}),
            _ => null,
          },
        );

    Widget group(LooviButtonVariant v, LooviButtonIntent i) => Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${v.name} · ${i.name}', style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
            Wrap(spacing: t.spacing.s100, children: [for (final s in _states) cell(v, i, s)]),
          ]),
        );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final size in LooviButtonSize.values)
        Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Row(children: [
            LooviButton(label: 'Continuar', onPressed: () {}, size: size, showIcon: true, showTrailingIcon: true),
            SizedBox(width: t.spacing.s100),
            LooviButton(label: 'Continuar', onPressed: () {}, size: size, loading: true),
          ]),
        ),
      for (final i in LooviButtonIntent.values) group(LooviButtonVariant.solid, i),
      for (final v in [LooviButtonVariant.outline, LooviButtonVariant.text])
        for (final i in [LooviButtonIntent.primary, LooviButtonIntent.success, LooviButtonIntent.danger]) group(v, i),
    ]);
  }
}
