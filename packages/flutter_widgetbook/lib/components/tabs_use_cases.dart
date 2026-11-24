import 'package:loovi_ds/loovi_ds.dart';
// Until lib/loovi_ds.dart exports it (integration step owned by the lead).
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _labels = ['Resumo', 'Pagamentos', 'Documentos', 'Veículo', 'Ajuda'];

List<LooviTab> _tabsFromKnobs(BuildContext context, {bool icons = true}) {
  final k = context.knobs;
  final count = k.int.slider(label: 'itemCount', initialValue: 3, min: 2, max: 5);
  final showIcon = icons && k.boolean(label: 'showIcon');
  final leadingIcon = k.object.dropdown<String>(
    label: 'leadingIcon',
    options: LooviIcons.all.toList(),
    initialOption: LooviIcons.userOutline,
  );
  final attentionAt = k.int.slider(label: 'showAttention on tab # (0 = none)', initialValue: 0, min: 0, max: 5);
  final disabledAt = k.int.slider(label: 'state=disabled on tab # (0 = none)', initialValue: 0, min: 0, max: 5);
  return [
    for (var i = 0; i < count; i++)
      LooviTab(
        label: _labels[i],
        showIcon: showIcon,
        leadingIcon: leadingIcon,
        showAttention: attentionAt == i + 1,
        disabled: disabledAt == i + 1,
      ),
  ];
}

LooviTabsAlignment _alignment(BuildContext context) => context.knobs.object.dropdown<LooviTabsAlignment>(
      label: 'alignment',
      options: LooviTabsAlignment.values,
      labelBuilder: (v) => v.name,
    );

/// TabItem (seed node 3532:6782) — building block; compose via Tabs*.
/// `state`: selected/disabled are knobs; hover is not used on the app.
WidgetbookComponent looviTabItemComponent() => WidgetbookComponent(
      name: 'TabItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final variant = k.object.dropdown<LooviTabItemVariant>(
              label: 'variant',
              options: LooviTabItemVariant.values,
              labelBuilder: (v) => v.name,
            );
            final appearance = k.object.dropdown<LooviTabItemAppearance>(
              label: 'appearance (primary only)',
              options: LooviTabItemAppearance.values,
              labelBuilder: (v) => v.name,
            );
            final t = LooviTokens.of(context);
            final inverse = variant == LooviTabItemVariant.primary && appearance == LooviTabItemAppearance.inverse;
            return SeedStory(
              component: 'TabItem',
              child: ColoredBox(
                color: inverse ? t.color.backgroundSurfaceInverse2 : t.color.backgroundSurface0,
                child: Padding(
                  padding: EdgeInsets.all(t.spacing.s100),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: LooviTabItem(
                      tab: LooviTab(
                        label: k.string(label: 'label', initialValue: 'Label'),
                        showIcon: k.boolean(label: 'showIcon', initialValue: true),
                        leadingIcon: k.object.dropdown<String>(
                          label: 'leadingIcon',
                          options: LooviIcons.all.toList(),
                          initialOption: LooviIcons.userOutline,
                        ),
                        showAttention: k.boolean(label: 'showAttention'),
                        disabled: k.boolean(label: 'state=disabled'),
                      ),
                      variant: variant,
                      appearance: appearance,
                      selected: k.boolean(label: 'state=selected'),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );

/// TabsPrimary (seed node 3532:6900).
WidgetbookComponent looviTabsPrimaryComponent() => WidgetbookComponent(
      name: 'TabsPrimary',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final appearance = context.knobs.object.dropdown<LooviTabsPrimaryAppearance>(
              label: 'appearance',
              options: LooviTabsPrimaryAppearance.values,
              labelBuilder: (v) => v.name,
            );
            final tabs = _tabsFromKnobs(context);
            final alignment = _alignment(context);
            return SeedStory(
              component: 'TabsPrimary',
              child: _Controlled(
                count: tabs.length,
                builder: (index, onChanged) => LooviTabsPrimary(
                  tabs: tabs,
                  selectedIndex: index,
                  onChanged: onChanged,
                  alignment: alignment,
                  appearance: appearance,
                ),
              ),
            );
          },
        ),
      ],
    );

/// TabsSecondary (seed node 3532:7346).
WidgetbookComponent looviTabsSecondaryComponent() => WidgetbookComponent(
      name: 'TabsSecondary',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final tabs = _tabsFromKnobs(context);
            final alignment = _alignment(context);
            return SeedStory(
              component: 'TabsSecondary',
              child: _Controlled(
                count: tabs.length,
                builder: (index, onChanged) =>
                    LooviTabsSecondary(tabs: tabs, selectedIndex: index, onChanged: onChanged, alignment: alignment),
              ),
            );
          },
        ),
      ],
    );

/// TabsSegmented (seed node 4738:825) — e.g. Cartão | Pix.
WidgetbookComponent looviTabsSegmentedComponent() => WidgetbookComponent(
      name: 'TabsSegmented',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final tabs = _tabsFromKnobs(context);
            final alignment = _alignment(context);
            return SeedStory(
              component: 'TabsSegmented',
              child: _Controlled(
                count: tabs.length,
                builder: (index, onChanged) =>
                    LooviTabsSegmented(tabs: tabs, selectedIndex: index, onChanged: onChanged, alignment: alignment),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Cartão | Pix',
          builder: (context) => SeedStory(
            component: 'TabsSegmented',
            showDescription: false,
            child: _Controlled(
              count: 2,
              builder: (index, onChanged) => LooviTabsSegmented(
                tabs: const [LooviTab(label: 'Cartão'), LooviTab(label: 'Pix')],
                selectedIndex: index,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );

/// Holds the selected index so the story is interactive (controlled API).
class _Controlled extends StatefulWidget {
  const _Controlled({required this.count, required this.builder});

  final int count;
  final Widget Function(int index, ValueChanged<int> onChanged) builder;

  @override
  State<_Controlled> createState() => _ControlledState();
}

class _ControlledState extends State<_Controlled> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final index = _index.clamp(0, widget.count - 1);
    return widget.builder(index, (i) => setState(() => _index = i));
  }
}
