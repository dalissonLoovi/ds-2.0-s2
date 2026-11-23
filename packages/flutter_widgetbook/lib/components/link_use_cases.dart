import 'package:loovi_ds/loovi_ds.dart';
// ignore: implementation_imports — direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Link (seed node 3820:13913) — Playground + Matrix.
/// `state` of the seed: active/focus come from touch/keyboard; visited and
/// disabled are knobs. Hover is not used on the app.
WidgetbookComponent looviLinkComponent() => WidgetbookComponent(
      name: 'Link',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final t = LooviTokens.of(context);
            final appearance = k.object.dropdown<LooviLinkAppearance>(
              label: 'appearance',
              options: LooviLinkAppearance.values,
              labelBuilder: (v) => v == LooviLinkAppearance.defaultAppearance ? 'default' : v.name,
            );
            return SeedStory(
              component: 'Link',
              child: ColoredBox(
                color: appearance == LooviLinkAppearance.inverse ? t.color.backgroundSurfaceInverse3 : t.color.backgroundSurface0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LooviLink(
                    label: k.string(label: 'label', initialValue: 'Ver detalhes'),
                    onPressed: () {},
                    appearance: appearance,
                    size: k.object.dropdown<LooviLinkSize>(
                      label: 'size',
                      options: LooviLinkSize.values,
                      labelBuilder: (v) => v.name,
                    ),
                    inline: k.boolean(label: 'inline'),
                    showIcon: k.boolean(label: 'showIcon', initialValue: true),
                    trailingIcon: k.object.dropdown<String>(
                      label: 'trailingIcon',
                      options: LooviIcons.all.toList(),
                      initialOption: LooviIcons.arrowNarrowRightOutline,
                    ),
                    visited: k.boolean(label: 'state=visited'),
                    disabled: k.boolean(label: 'state=disabled'),
                  ),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Matrix',
          builder: (context) => const SeedStory(component: 'Link', showDescription: false, child: _LinkMatrix()),
        ),
      ],
    );

/// size × state × appearance (+ inline md) — hover omitted. Active/focus are
/// forced with a [WidgetStatesController]. Same layout as the golden `link_matrix.png`.
class _LinkMatrix extends StatelessWidget {
  const _LinkMatrix();

  static const _states = ['default', 'focus', 'active', 'visited', 'disabled'];

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget cell(LooviLinkSize size, LooviLinkAppearance a, String state, {bool inline = false}) => LooviLink(
          label: 'Link',
          onPressed: () {},
          size: size,
          appearance: a,
          inline: inline,
          visited: state == 'visited',
          disabled: state == 'disabled',
          statesController: switch (state) {
            'active' => WidgetStatesController({WidgetState.pressed}),
            'focus' => WidgetStatesController({WidgetState.focused}),
            _ => null,
          },
        );

    Widget block(LooviLinkAppearance a) => ColoredBox(
          color: a == LooviLinkAppearance.inverse ? t.color.backgroundSurfaceInverse3 : t.color.backgroundSurface0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.s100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (final size in LooviLinkSize.values)
                Wrap(spacing: t.spacing.s100, children: [for (final s in _states) cell(size, a, s)]),
              Wrap(spacing: t.spacing.s100, children: [
                for (final s in _states) cell(LooviLinkSize.md, a, s, inline: true),
              ]),
            ]),
          ),
        );

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      block(LooviLinkAppearance.defaultAppearance),
      block(LooviLinkAppearance.inverse),
    ]);
  }
}
