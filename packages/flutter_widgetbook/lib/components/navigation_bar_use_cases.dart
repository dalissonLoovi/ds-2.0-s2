import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _destinations = [
  LooviNavigationBarItem(icon: LooviIcons.homeOutline, selectedIcon: LooviIcons.homeFilled, label: 'Início'),
  LooviNavigationBarItem(icon: LooviIcons.carOutline, label: 'Veículo'),
  LooviNavigationBarItem(icon: LooviIcons.headsetOutline, label: 'Ajuda'),
  LooviNavigationBarItem(icon: LooviIcons.userOutline, selectedIcon: LooviIcons.userFilled, label: 'Perfil'),
];

const _threeDestinations = [
  LooviNavigationBarItem(icon: LooviIcons.homeOutline, selectedIcon: LooviIcons.homeFilled, label: 'Início'),
  LooviNavigationBarItem(icon: LooviIcons.carOutline, label: 'Veículo'),
  LooviNavigationBarItem(icon: LooviIcons.userOutline, selectedIcon: LooviIcons.userFilled, label: 'Perfil'),
];

/// Painel Home (itemCount=5): four destinations + Acionar in the middle.
const _painel = [
  LooviNavigationBarItem(icon: LooviIcons.homeOutline, selectedIcon: LooviIcons.homeFilled, label: 'Início'),
  LooviNavigationBarItem(icon: LooviIcons.carOutline, label: 'Veículos'),
  LooviNavigationBarItem(icon: LooviIcons.fileTextOutline, label: 'Seu caso'),
  LooviNavigationBarItem(icon: LooviIcons.menu2Outline, label: 'Menu'),
];

List<LooviNavigationBarItem> _itemsFor(LooviNavigationBarItemCount count) => switch (count) {
      LooviNavigationBarItemCount.three => _threeDestinations,
      LooviNavigationBarItemCount.four => _destinations,
      LooviNavigationBarItemCount.five => _painel,
    };

/// NavigationBar (seed node 3653:14851) + NavigationBarItem (3327:2878).
/// Seed `state` (pressed/focus) comes from touch/keyboard; no hover on mobile.
WidgetbookComponent looviNavigationBarComponent() => WidgetbookComponent(
      name: 'NavigationBar',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final count = k.object.dropdown<LooviNavigationBarItemCount>(
              label: 'itemCount',
              options: LooviNavigationBarItemCount.values,
              initialOption: LooviNavigationBarItemCount.four,
              labelBuilder: (v) => switch (v) {
                LooviNavigationBarItemCount.three => '3',
                LooviNavigationBarItemCount.four => '4',
                LooviNavigationBarItemCount.five => '5 (4 + Acionar)',
              },
            );
            final badge = k.object.dropdown<LooviNavigationBarItemBadge>(
              label: 'badge (2º destino)',
              options: LooviNavigationBarItemBadge.values,
              labelBuilder: (v) => v.name,
            );
            final badgeCount = k.int.slider(label: 'count', initialValue: 3, min: 1, max: 120);
            final showLabel = k.boolean(label: 'showLabel', initialValue: true);
            final base = _itemsFor(count);
            final items = [
              for (var i = 0; i < base.length; i++)
                LooviNavigationBarItem(
                  icon: base[i].icon,
                  selectedIcon: base[i].selectedIcon,
                  label: base[i].label,
                  showLabel: showLabel,
                  badge: i == 1 ? badge : LooviNavigationBarItemBadge.none,
                  count: badgeCount,
                ),
            ];
            return SeedStory(
              component: 'NavigationBar',
              child: _PlaygroundBar(
                items: items,
                itemCount: count,
                appearance: k.object.dropdown<LooviNavigationBarAppearance>(
                  label: 'appearance',
                  options: LooviNavigationBarAppearance.values,
                  labelBuilder: (v) => v == LooviNavigationBarAppearance.standard ? 'default' : v.name,
                ),
                layout: k.object.dropdown<LooviNavigationBarLayout>(
                  label: 'layout',
                  options: LooviNavigationBarLayout.values,
                  labelBuilder: (v) => v.name,
                ),
                primaryLabel: k.string(label: 'primaryLabel', initialValue: 'Acionar'),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) =>
              const SeedStory(component: 'NavigationBar', showDescription: false, child: _NavigationBarVariants()),
        ),
      ],
    );

class _PlaygroundBar extends StatefulWidget {
  const _PlaygroundBar({
    required this.items,
    required this.itemCount,
    required this.appearance,
    required this.layout,
    required this.primaryLabel,
  });

  final List<LooviNavigationBarItem> items;
  final LooviNavigationBarItemCount itemCount;
  final LooviNavigationBarAppearance appearance;
  final LooviNavigationBarLayout layout;
  final String primaryLabel;

  @override
  State<_PlaygroundBar> createState() => _PlaygroundBarState();
}

class _PlaygroundBarState extends State<_PlaygroundBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final index = _index.clamp(0, widget.items.length - 1);
    final bar = LooviNavigationBar(
      items: widget.items,
      itemCount: widget.itemCount,
      appearance: widget.appearance,
      layout: widget.layout,
      primaryLabel: widget.primaryLabel,
      selectedIndex: index,
      onSelected: (i) => setState(() => _index = i),
      onPrimaryAction: () => ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text('${widget.primaryLabel} tocado'))),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Aba atual: ${widget.items[index].label}',
          style: t.typography.bodySmallRegular.copyWith(color: t.text.secondary),
        ),
        SizedBox(height: t.spacing.s400),
        // Floating: horizontal inset is screen composition (not the widget).
        if (widget.layout == LooviNavigationBarLayout.floating)
          Padding(padding: EdgeInsets.symmetric(horizontal: t.spacing.s200), child: bar)
        else
          bar,
      ],
    );
  }
}

class _NavigationBarVariants extends StatelessWidget {
  const _NavigationBarVariants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final caption = t.typography.captionLargeRegular.copyWith(color: t.text.secondary);
    final rows = <Widget>[];
    for (final layout in LooviNavigationBarLayout.values) {
      for (final appearance in LooviNavigationBarAppearance.values) {
        for (final count in LooviNavigationBarItemCount.values) {
          final bar = LooviNavigationBar(
            items: _itemsFor(count),
            itemCount: count,
            appearance: appearance,
            layout: layout,
            selectedIndex: 0,
            onSelected: (_) {},
            onPrimaryAction: () {},
          );
          rows
            ..add(Text(
              'itemCount=${count.index + 3} · appearance=${appearance == LooviNavigationBarAppearance.standard ? 'default' : appearance.name} · layout=${layout.name}',
              style: caption,
            ))
            ..add(SizedBox(height: t.spacing.s100))
            ..add(layout == LooviNavigationBarLayout.floating
                ? Padding(padding: EdgeInsets.symmetric(horizontal: t.spacing.s200), child: bar)
                : bar)
            ..add(SizedBox(height: t.spacing.s400));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...rows,
        Text('NavigationBarItem · badge / showLabel', style: caption),
        SizedBox(height: t.spacing.s100),
        Row(
          children: [
            for (final item in const [
              LooviNavigationBarItem(icon: LooviIcons.bellOutline, label: 'Avisos', badge: LooviNavigationBarItemBadge.count, count: 3),
              LooviNavigationBarItem(icon: LooviIcons.bellOutline, label: 'Avisos', badge: LooviNavigationBarItemBadge.count, count: 120),
              LooviNavigationBarItem(icon: LooviIcons.bellOutline, label: 'Avisos', badge: LooviNavigationBarItemBadge.dot),
              LooviNavigationBarItem(icon: LooviIcons.homeOutline, selectedIcon: LooviIcons.homeFilled, label: 'Início', showLabel: false),
            ])
              Expanded(child: LooviNavigationBarItemView(item: item, selected: !item.showLabel, onTap: () {})),
          ],
        ),
      ],
    );
  }
}

/// NavigationBarItem (seed node 3653:15180) — Playground + States. Building
/// block of [LooviNavigationBar]; `state` pressed/focus is pinned through a
/// [WidgetStatesController] so the frames can be compared with Figma.
WidgetbookComponent looviNavigationBarItemComponent() => WidgetbookComponent(
      name: 'NavigationBarItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final t = LooviTokens.of(context);
            final appearance = k.object.dropdown<LooviNavigationBarItemAppearance>(
              label: 'appearance',
              options: LooviNavigationBarItemAppearance.values,
              labelBuilder: (v) => v == LooviNavigationBarItemAppearance.standard ? 'default' : v.name,
            );
            final item = LooviNavigationBarItem(
              icon: LooviIcons.homeOutline,
              selectedIcon: LooviIcons.homeFilled,
              label: k.string(label: 'label', initialValue: 'Início'),
              showLabel: k.boolean(label: 'showLabel', initialValue: true),
              badge: k.object.dropdown<LooviNavigationBarItemBadge>(
                label: 'badge',
                options: LooviNavigationBarItemBadge.values,
                labelBuilder: (v) => v.name,
              ),
              count: k.int.slider(label: 'count', initialValue: 3, min: 1, max: 120),
            );
            return SeedStory(
              component: 'NavigationBarItem',
              child: ColoredBox(
                color: appearance == LooviNavigationBarItemAppearance.inverse
                    ? t.color.backgroundSurfaceInverse3
                    : t.color.backgroundSurface0,
                child: Center(
                  child: SizedBox(
                    width: t.spacing.s1000,
                    child: LooviNavigationBarItemView(
                      item: item,
                      appearance: appearance,
                      selected: k.boolean(label: 'selected'),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => const SeedStory(
            component: 'NavigationBarItem',
            showDescription: false,
            child: _NavigationBarItemStates(),
          ),
        ),
      ],
    );

/// appearance × state (default · pressed · focus) × selected.
class _NavigationBarItemStates extends StatefulWidget {
  const _NavigationBarItemStates();

  @override
  State<_NavigationBarItemStates> createState() => _NavigationBarItemStatesState();
}

class _NavigationBarItemStatesState extends State<_NavigationBarItemStates> {
  static const _states = <Set<WidgetState>>[{}, {WidgetState.pressed}, {WidgetState.focused}];
  // One controller per cell: appearance (2) × selected (2) × state (3).
  late final List<WidgetStatesController> _controllers = [
    for (var i = 0; i < LooviNavigationBarItemAppearance.values.length * 2; i++)
      for (final s in _states) WidgetStatesController({...s}),
  ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final caption = t.typography.captionLargeRegular.copyWith(color: t.text.secondary);
    const item = LooviNavigationBarItem(icon: LooviIcons.homeOutline, selectedIcon: LooviIcons.homeFilled, label: 'Início');
    var n = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final appearance in LooviNavigationBarItemAppearance.values)
          for (final selected in [false, true]) ...[
            Text(
              'appearance=${appearance == LooviNavigationBarItemAppearance.standard ? 'default' : appearance.name} · selected=$selected · default / pressed / focus',
              style: caption,
            ),
            SizedBox(height: t.spacing.s100),
            ColoredBox(
              color: appearance == LooviNavigationBarItemAppearance.inverse
                  ? t.color.backgroundSurfaceInverse3
                  : t.color.backgroundSurface0,
              child: Row(
                children: [
                  for (var i = 0; i < _states.length; i++)
                    Expanded(
                      child: LooviNavigationBarItemView(
                        item: item,
                        appearance: appearance,
                        selected: selected,
                        statesController: _controllers[n++],
                        onTap: () {},
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: t.spacing.s300),
          ],
      ],
    );
  }
}
