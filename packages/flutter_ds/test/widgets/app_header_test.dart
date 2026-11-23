import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

typedef AppHeaderVariantSpec = (LooviAppHeaderLayout, LooviAppHeaderAppearance, LooviAppHeaderHierarchy);

/// The 11 published variants, in Figma order (3143:8822).
const List<AppHeaderVariantSpec> publishedVariants = [
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

LooviAppHeader _header(AppHeaderVariantSpec v, {Key? key}) => LooviAppHeader(
      key: key,
      layout: v.$1,
      appearance: v.$2,
      hierarchy: v.$3,
      greeting: 'Olá, Rodrigo',
      title: v.$3 == LooviAppHeaderHierarchy.superApp ? 'Loovi' : 'Meu veículo',
      onLeadingAction: () {},
      onSecondTrailingAction: () {},
      onProfileMenu: () {},
    );

/// Story "Variants": the 11 published variants stacked. Same as the Widgetbook story.
class AppHeaderVariants extends StatelessWidget {
  const AppHeaderVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final v in publishedVariants) ...[_header(v), SizedBox(height: t.spacing.s100)],
        ],
      ),
    );
  }
}

Finder _title(String text) => find.text(text);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('renders every published variant with Figma heights', (tester) async {
    // Figma: global 56, small|smallCentered 64, medium 102, large 113.
    final expected = <LooviAppHeaderLayout, double>{
      LooviAppHeaderLayout.smallCentered: 64,
      LooviAppHeaderLayout.small: 64,
      LooviAppHeaderLayout.medium: 102,
      LooviAppHeaderLayout.large: 113,
    };
    for (final v in publishedVariants) {
      await pumpLoovi(tester, _header(v, key: const Key('h')));
      final h = tester.getSize(find.byKey(const Key('h'))).height;
      final want = v.$3 == LooviAppHeaderHierarchy.global ? 56.0 : expected[v.$1]!;
      // large: heading/h1 line height 45 → 8 + 40 + 8 + 45 + 12 = 113.
      expect(h, closeTo(want, 0.5), reason: '$v');
    }
  });

  testWidgets('unpublished combinations assert', (tester) async {
    expect(
      () => LooviAppHeader(hierarchy: LooviAppHeaderHierarchy.global, layout: LooviAppHeaderLayout.small),
      throwsAssertionError,
    );
    expect(
      () => LooviAppHeader(hierarchy: LooviAppHeaderHierarchy.superApp, appearance: LooviAppHeaderAppearance.inverse),
      throwsAssertionError,
    );
  });

  testWidgets('app-cliente title on small|smallCentered × standard × specific: 14/20 regular uppercase', (tester) async {
    for (final layout in [LooviAppHeaderLayout.small, LooviAppHeaderLayout.smallCentered]) {
      await pumpLoovi(tester, LooviAppHeader(hierarchy: LooviAppHeaderHierarchy.specific, layout: layout, title: 'Meu veículo'));
      final text = tester.widget<Text>(_title('MEU VEÍCULO'));
      expect(text.style!.fontSize, _t.component.appHeader.titleFontSize);
      expect(text.style!.fontSize, 14);
      expect(text.style!.fontSize! * text.style!.height!, closeTo(20, 0.01));
      expect(text.style!.fontWeight, FontWeight.w400);
      expect(text.style!.color, _t.text.primary);
    }
    // inverse / superApp / medium keep the TextHeader typography, original case.
    await pumpLoovi(
      tester,
      LooviAppHeader(
        hierarchy: LooviAppHeaderHierarchy.specific,
        layout: LooviAppHeaderLayout.small,
        appearance: LooviAppHeaderAppearance.inverse,
        title: 'Coberturas',
      ),
    );
    final inv = tester.widget<Text>(_title('Coberturas'));
    expect(inv.style!.fontSize, _t.typography.headingH3Medium.fontSize);
    expect(inv.style!.color, _t.text.onColor);
    await pumpLoovi(tester, const LooviAppHeader(hierarchy: LooviAppHeaderHierarchy.superApp, title: 'Loovi'));
    expect(tester.widget<Text>(_title('Loovi')).style!.fontWeight, FontWeight.w500);
    await pumpLoovi(tester, const LooviAppHeader(hierarchy: LooviAppHeaderHierarchy.specific, layout: LooviAppHeaderLayout.large, title: 'Coberturas'));
    expect(tester.widget<Text>(_title('Coberturas')).style!.fontSize, _t.typography.headingH1Medium.fontSize);
  });

  testWidgets('inverse fill = brand-strong; standard = surface/0; greeting body/large/medium', (tester) async {
    ColoredBox root() => tester.widget<ColoredBox>(
          find.descendant(of: find.byType(LooviAppHeader), matching: find.byType(ColoredBox)).first,
        );
    await pumpLoovi(tester, const LooviAppHeader(appearance: LooviAppHeaderAppearance.inverse, greeting: 'Olá, Rodrigo'));
    expect(root().color, _t.component.appHeader.inverseBackground);
    expect(root().color, _t.color.backgroundSurfaceBrandStrong);
    final g = tester.widget<Text>(find.text('Olá, Rodrigo'));
    expect(g.style!.color, _t.text.onColor);
    expect(g.style!.fontWeight, _t.typography.bodyLargeMedium.fontWeight);
    expect(g.style!.fontSize, _t.typography.bodyLargeMedium.fontSize);
    // global × inverse avatar placeholder: white 16% + on-color icon.
    final avatarFill = tester.widget<ColoredBox>(find.ancestor(
      of: find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.userOutline),
      matching: find.byType(ColoredBox),
    ).first);
    expect(avatarFill.color, _t.component.appHeader.avatarBackground);
    expect(tester.widget<LooviIcon>(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.userOutline)).color,
        _t.component.appHeader.avatarIconColor);

    await pumpLoovi(tester, const LooviAppHeader(greeting: 'Olá, Rodrigo'));
    expect(root().color, _t.color.backgroundSurface0);
  });

  testWidgets('leading action: surface/2 + radius full (standard), no fill on inverse; 40 paint, icon 16', (tester) async {
    BoxDecoration leadingDeco() {
      final box = find.descendant(
        of: find.bySemanticsLabel('Voltar'),
        matching: find.byType(DecoratedBox),
      );
      return tester.widget<DecoratedBox>(box.first).decoration as BoxDecoration;
    }

    await pumpLoovi(tester, LooviAppHeader(hierarchy: LooviAppHeaderHierarchy.specific, title: 'Meu veículo', onLeadingAction: () {}));
    expect(leadingDeco().color, _t.component.appHeader.leadingActionBackground);
    expect(leadingDeco().color, _t.color.backgroundSurface2);
    expect(leadingDeco().borderRadius, BorderRadius.circular(_t.radius.full));
    final icon = tester.widget<LooviIcon>(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.arrowLeftOutline));
    expect(icon.size, _t.spacing.s200);
    expect(icon.color, _t.text.primary);
    final paint = tester.getSize(find.descendant(of: find.bySemanticsLabel('Voltar'), matching: find.byType(DecoratedBox)).first);
    expect(paint, Size.square(_t.spacing.s500));

    await pumpLoovi(
      tester,
      LooviAppHeader(
        hierarchy: LooviAppHeaderHierarchy.specific,
        appearance: LooviAppHeaderAppearance.inverse,
        title: 'Meu veículo',
        onLeadingAction: () {},
      ),
    );
    expect(leadingDeco().color, isNull);
    expect(
      tester.widget<LooviIcon>(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.arrowLeftOutline)).color,
      _t.text.onColor,
    );
  });

  testWidgets('callbacks fire for leading, search, bell, profile menu', (tester) async {
    final calls = <String>[];
    await pumpLoovi(
      tester,
      LooviAppHeader(
        hierarchy: LooviAppHeaderHierarchy.superApp,
        title: 'Loovi',
        showFirstTrailingAction: true,
        onLeadingAction: () => calls.add('menu'),
        onFirstTrailingAction: () => calls.add('search'),
        onSecondTrailingAction: () => calls.add('bell'),
        onProfileMenu: () => calls.add('profile'),
      ),
    );
    for (final label in ['Menu', 'Buscar', 'Notificações', 'Menu do perfil']) {
      await tester.tap(find.bySemanticsLabel(label));
    }
    expect(calls, ['menu', 'search', 'bell', 'profile']);
  });

  testWidgets('semantics: title is a header; actions are labelled buttons with >= 48 targets', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      LooviAppHeader(
        hierarchy: LooviAppHeaderHierarchy.specific,
        title: 'Meu veículo',
        showFirstTrailingAction: true,
        onLeadingAction: () {},
        onFirstTrailingAction: () {},
        onSecondTrailingAction: () {},
      ),
    );
    expect(tester.getSemantics(find.bySemanticsLabel('Meu veículo')), isSemantics(label: 'Meu veículo', isHeader: true));
    for (final label in ['Voltar', 'Buscar', 'Notificações']) {
      expect(
        tester.getSemantics(find.bySemanticsLabel(label)),
        isSemantics(label: label, isButton: true, hasEnabledState: true, isEnabled: true, hasTapAction: true),
      );
      final size = tester.getSize(find.bySemanticsLabel(label));
      expect(size.width, greaterThanOrEqualTo(48), reason: label);
      expect(size.height, greaterThanOrEqualTo(48), reason: label);
    }
    await pumpLoovi(tester, const LooviAppHeader(greeting: 'Olá, Rodrigo'));
    expect(tester.getSemantics(find.text('Olá, Rodrigo')), isSemantics(label: 'Olá, Rodrigo', isHeader: true));
    handle.dispose();
  });

  testWidgets('smallCentered: title centered on the full width whatever the side slots hold', (tester) async {
    final cases = <LooviAppHeader>[
      // superApp: leading 40 vs trailing bell 40 + profileMenu 48.
      const LooviAppHeader(hierarchy: LooviAppHeaderHierarchy.superApp, title: 'LOOVI'),
      const LooviAppHeader(
          hierarchy: LooviAppHeaderHierarchy.superApp, title: 'LOOVI', showFirstTrailingAction: true),
      // specific: leading 40 vs search + bell 80; and no leading action at all.
      const LooviAppHeader(
          hierarchy: LooviAppHeaderHierarchy.specific, title: 'T', showFirstTrailingAction: true),
      const LooviAppHeader(
          hierarchy: LooviAppHeaderHierarchy.specific, title: 'T', showAction: false, showSecondTrailingAction: false),
    ];
    for (final header in cases) {
      await pumpLoovi(tester, header);
      final width = tester.getSize(find.byType(LooviAppHeader)).width;
      final title = find.text(header.title!.toUpperCase()).evaluate().isEmpty ? find.text(header.title!) : find.text(header.title!.toUpperCase());
      expect(tester.getCenter(title).dx, closeTo(width / 2, 0.5));
    }
  });

  testWidgets('leading action paint keeps the Figma position (20..60 from the left edge)', (tester) async {
    await pumpLoovi(tester, LooviAppHeader(hierarchy: LooviAppHeaderHierarchy.specific, layout: LooviAppHeaderLayout.small, title: 'T', onLeadingAction: () {}));
    final paint = tester.getRect(find.descendant(of: find.bySemanticsLabel('Voltar'), matching: find.byType(DecoratedBox)).first);
    expect(paint.left, _t.spacing.s200);
    expect(paint.top, _t.spacing.s150); // (64 - 40) / 2
    // title starts right after the 40 slot (no gap): 16 + 40.
    expect(tester.getTopLeft(find.text('T')).dx, _t.spacing.s200 + _t.spacing.s500);
  });

  testWidgets('safe area: fill extends under the status bar', (tester) async {
    await tester.pumpWidget(looviHarness(MediaQuery(
      data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
      child: const LooviAppHeader(key: Key('h'), greeting: 'Olá'),
    )));
    expect(tester.getSize(find.byKey(const Key('h'))).height, 56 + 24);
  });

  testWidgets('textScaler 2: no overflow on any published variant', (tester) async {
    for (final v in publishedVariants) {
      await pumpLoovi(tester, _header(v), textScale: 2);
      expect(tester.takeException(), isNull, reason: '$v');
    }
  });

  testWidgets('golden: published variants', (tester) async {
    await pumpGolden(tester, const AppHeaderVariants(), height: 950);
    await expectLater(find.byType(AppHeaderVariants), matchesGoldenFile('../goldens/app_header_variants.png'));
  });
}
