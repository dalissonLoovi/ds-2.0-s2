import 'package:loovi_ds/loovi_ds.dart';
// Direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

typedef _V = (LooviAppHeaderLayout, LooviAppHeaderAppearance, LooviAppHeaderHierarchy);

/// The 11 published variants (sparse matrix), Figma order.
const List<_V> _published = [
  (LooviAppHeaderLayout.smallCentered, LooviAppHeaderAppearance.standard, LooviAppHeaderHierarchy.global),
  (LooviAppHeaderLayout.smallCentered, LooviAppHeaderAppearance.standard, LooviAppHeaderHierarchy.superApp),
  (LooviAppHeaderLayout.smallCentered, LooviAppHeaderAppearance.standard, LooviAppHeaderHierarchy.specific),
  (LooviAppHeaderLayout.small, LooviAppHeaderAppearance.standard, LooviAppHeaderHierarchy.specific),
  (LooviAppHeaderLayout.medium, LooviAppHeaderAppearance.standard, LooviAppHeaderHierarchy.specific),
  (LooviAppHeaderLayout.large, LooviAppHeaderAppearance.standard, LooviAppHeaderHierarchy.specific),
  (LooviAppHeaderLayout.smallCentered, LooviAppHeaderAppearance.inverse, LooviAppHeaderHierarchy.global),
  (LooviAppHeaderLayout.smallCentered, LooviAppHeaderAppearance.inverse, LooviAppHeaderHierarchy.specific),
  (LooviAppHeaderLayout.small, LooviAppHeaderAppearance.inverse, LooviAppHeaderHierarchy.specific),
  (LooviAppHeaderLayout.medium, LooviAppHeaderAppearance.inverse, LooviAppHeaderHierarchy.specific),
  (LooviAppHeaderLayout.large, LooviAppHeaderAppearance.inverse, LooviAppHeaderHierarchy.specific),
];

String _kebab(String camel) => camel.replaceAllMapped(RegExp('[A-Z]'), (m) => '-${m[0]!.toLowerCase()}');

/// AppHeader (seed node 3143:8822) — Playground + Variants (11 published).
/// The Playground snaps unpublished combinations to the closest published
/// one (global|superApp → smallCentered; superApp → standard).
WidgetbookComponent looviAppHeaderComponent() => WidgetbookComponent(
      name: 'AppHeader',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final hierarchy = k.object.dropdown<LooviAppHeaderHierarchy>(
              label: 'hierarchy',
              options: LooviAppHeaderHierarchy.values,
              initialOption: LooviAppHeaderHierarchy.specific,
              labelBuilder: (v) => _kebab(v.name),
            );
            var layout = k.object.dropdown<LooviAppHeaderLayout>(
              label: 'layout (specific only)',
              options: LooviAppHeaderLayout.values,
              labelBuilder: (v) => _kebab(v.name),
            );
            var appearance = k.object.dropdown<LooviAppHeaderAppearance>(
              label: 'appearance',
              options: LooviAppHeaderAppearance.values,
              labelBuilder: (v) => v == LooviAppHeaderAppearance.standard ? 'default' : v.name,
            );
            if (hierarchy != LooviAppHeaderHierarchy.specific) layout = LooviAppHeaderLayout.smallCentered;
            if (hierarchy == LooviAppHeaderHierarchy.superApp) appearance = LooviAppHeaderAppearance.standard;
            final description = k.string(label: 'description', initialValue: '');
            return SeedStory(
              component: 'AppHeader',
              child: LooviAppHeader(
                hierarchy: hierarchy,
                layout: layout,
                appearance: appearance,
                title: k.string(label: 'title', initialValue: 'Meu veículo'),
                description: description.isEmpty ? null : description,
                greeting: k.string(label: 'greeting (global)', initialValue: 'Olá, Rodrigo'),
                showLabel: k.boolean(label: 'showLabel', initialValue: true),
                showAction: k.boolean(label: 'showAction', initialValue: true),
                showFirstTrailingAction: k.boolean(label: 'showFirstTrailingAction'),
                showSecondTrailingAction: k.boolean(label: 'showSecondTrailingAction', initialValue: true),
                showProfileMenu: k.boolean(label: 'showProfileMenu (super-app)', initialValue: true),
                useSafeArea: false,
                onLeadingAction: () {},
                onFirstTrailingAction: () {},
                onSecondTrailingAction: () {},
                onProfileMenu: () {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => const SeedStory(component: 'AppHeader', showDescription: false, child: _AppHeaderVariants()),
        ),
      ],
    );

/// The 11 published variants stacked. Same layout as the golden `app_header_variants.png`.
class _AppHeaderVariants extends StatelessWidget {
  const _AppHeaderVariants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final v in _published) ...[
            LooviAppHeader(
              layout: v.$1,
              appearance: v.$2,
              hierarchy: v.$3,
              greeting: 'Olá, Rodrigo',
              title: v.$3 == LooviAppHeaderHierarchy.superApp ? 'Loovi' : 'Meu veículo',
              useSafeArea: false,
              onLeadingAction: () {},
              onSecondTrailingAction: () {},
              onProfileMenu: () {},
            ),
            SizedBox(height: t.spacing.s100),
          ],
        ],
      ),
    );
  }
}
