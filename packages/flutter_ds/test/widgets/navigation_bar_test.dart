import 'dart:ui' show SemanticsRole, Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _four = [
  LooviNavigationBarItem(icon: LooviIcons.homeOutline, selectedIcon: LooviIcons.homeFilled, label: 'Início'),
  LooviNavigationBarItem(icon: LooviIcons.carOutline, label: 'Veículo'),
  LooviNavigationBarItem(icon: LooviIcons.headsetOutline, label: 'Ajuda'),
  LooviNavigationBarItem(icon: LooviIcons.userOutline, selectedIcon: LooviIcons.userFilled, label: 'Perfil'),
];

const _three = [
  LooviNavigationBarItem(icon: LooviIcons.homeOutline, selectedIcon: LooviIcons.homeFilled, label: 'Início'),
  LooviNavigationBarItem(icon: LooviIcons.carOutline, label: 'Veículo'),
  LooviNavigationBarItem(icon: LooviIcons.userOutline, selectedIcon: LooviIcons.userFilled, label: 'Perfil'),
];

const _painel = [
  LooviNavigationBarItem(icon: LooviIcons.homeOutline, selectedIcon: LooviIcons.homeFilled, label: 'Início'),
  LooviNavigationBarItem(icon: LooviIcons.carOutline, label: 'Veículos'),
  LooviNavigationBarItem(icon: LooviIcons.fileTextOutline, label: 'Sinistro', badge: LooviNavigationBarItemBadge.count, count: 2),
  LooviNavigationBarItem(icon: LooviIcons.menu2Outline, label: 'Menu', badge: LooviNavigationBarItemBadge.dot),
];

class _Host extends StatefulWidget {
  const _Host();
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  int index = 0;
  @override
  Widget build(BuildContext context) => LooviNavigationBar(
        items: _four,
        selectedIndex: index,
        onSelected: (i) => setState(() => index = i),
      );
}

Color? _labelColor(WidgetTester tester, String label) => tester.widget<Text>(find.text(label)).style?.color;

LooviIcon _iconOf(WidgetTester tester, String label) => tester.widget<LooviIcon>(
      find.descendant(
        of: find.ancestor(of: find.text(label), matching: find.byType(LooviNavigationBarItemView)),
        matching: find.byType(LooviIcon),
      ),
    );

void main() {
  setUpAll(loadGoldenFonts);
  const t = LooviTokens.appCliente;

  testWidgets('tap switches the selected destination', (tester) async {
    await pumpLoovi(tester, const _Host());
    expect(_labelColor(tester, 'Início'), t.color.actionsPrimary);
    await tester.tap(find.text('Ajuda'));
    await tester.pumpAndSettle();
    expect(_labelColor(tester, 'Ajuda'), t.color.actionsPrimary);
    expect(_labelColor(tester, 'Início'), t.text.secondary);
  });

  testWidgets('selected paints as Figma (default + inverse)', (tester) async {
    await pumpLoovi(tester, const LooviNavigationBar(items: _four, selectedIndex: 0));
    expect(_labelColor(tester, 'Início'), t.color.actionsPrimary);
    expect(_iconOf(tester, 'Início').name, LooviIcons.homeFilled);
    expect(_iconOf(tester, 'Início').color, t.color.actionsPrimary);
    expect(_labelColor(tester, 'Perfil'), t.text.secondary);
    expect(_iconOf(tester, 'Perfil').name, LooviIcons.userOutline);

    await pumpLoovi(
      tester,
      const LooviNavigationBar(items: _four, selectedIndex: 3, appearance: LooviNavigationBarAppearance.inverse),
    );
    expect(_labelColor(tester, 'Perfil'), t.color.actionsTertiary);
    expect(_iconOf(tester, 'Perfil').name, LooviIcons.userFilled);
    expect(_labelColor(tester, 'Início'), t.text.onColorDisabled);
    final surface = tester.widget<DecoratedBox>(
      find.descendant(of: find.byType(LooviNavigationBar), matching: find.byType(DecoratedBox)).first,
    );
    expect((surface.decoration as BoxDecoration).color, t.color.backgroundSurfaceInverse3);
  });

  testWidgets('pressed paints text/primary while held', (tester) async {
    await pumpLoovi(tester, LooviNavigationBar(items: _four, selectedIndex: 0, onSelected: (_) {}));
    final gesture = await tester.startGesture(tester.getCenter(find.text('Veículo')));
    await tester.pump();
    expect(_labelColor(tester, 'Veículo'), t.text.primary);
    await gesture.up();
    await tester.pump();
    expect(_labelColor(tester, 'Veículo'), t.text.secondary);
  });

  testWidgets('semantics: nav landmark, items with selected + label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviNavigationBar(items: _painel, selectedIndex: 0, itemCount: LooviNavigationBarItemCount.five, onSelected: (_) {}, onPrimaryAction: () {}));
    expect(
      tester.getSemantics(find.byType(LooviNavigationBar)),
      matchesSemantics(label: 'Navegação principal', role: SemanticsRole.navigation),
    );
    expect(
      find.bySemanticsLabel('Início'),
      findsOneWidget,
    );
    final inicio = tester.getSemantics(find.bySemanticsLabel('Início'));
    expect(inicio.flagsCollection.isSelected, Tristate.isTrue);
    expect(inicio.flagsCollection.isButton, isTrue);
    final veiculos = tester.getSemantics(find.bySemanticsLabel('Veículos'));
    expect(veiculos.flagsCollection.isSelected, Tristate.isFalse);
    expect(find.bySemanticsLabel('Sinistro, 2 notificações'), findsOneWidget);
    expect(find.bySemanticsLabel('Menu, nova atividade'), findsOneWidget);
    expect(find.bySemanticsLabel('Acionar'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('primary action (itemCount=5) is tappable incl. overhang, touch targets >= 48', (tester) async {
    var primary = 0;
    await pumpLoovi(
      tester,
      LooviNavigationBar(
        items: _painel,
        selectedIndex: 0,
        itemCount: LooviNavigationBarItemCount.five,
        layout: LooviNavigationBarLayout.floating,
        onSelected: (_) {},
        onPrimaryAction: () => primary++,
      ),
    );
    final fab = find.byKey(const Key('loovi-navigation-bar-primary'));
    expect(tester.getSize(fab), Size(t.spacing.s700, t.spacing.s700));
    // Top edge of the FAB sits in the overhang above the bar surface.
    await tester.tapAt(tester.getTopLeft(fab) + Offset(t.spacing.s700 / 2, t.spacing.s050));
    expect(primary, 1);
    // Whole widget = overhang (20) + bar (64).
    expect(tester.getSize(find.byType(LooviNavigationBar)).height, t.spacing.s800 + t.spacing.s250);
    for (final e in find.byType(LooviNavigationBarItemView).evaluate()) {
      final size = (e.renderObject! as RenderBox).size;
      expect(size.width, greaterThanOrEqualTo(t.spacing.s600));
      expect(size.height, greaterThanOrEqualTo(t.spacing.s600));
    }
  });

  testWidgets('bar height = spacing/800 and grows with text scale', (tester) async {
    await pumpLoovi(tester, const LooviNavigationBar(items: _four, selectedIndex: 0));
    expect(tester.getSize(find.byType(LooviNavigationBar)).height, t.spacing.s800);
    await pumpLoovi(tester, const LooviNavigationBar(items: _four, selectedIndex: 0), textScale: 2);
    expect(tester.getSize(find.byType(LooviNavigationBar)).height, greaterThan(t.spacing.s800));
    expect(tester.takeException(), isNull);
  });

  testWidgets('safe area: flush surface runs under the inset; floating sits above', (tester) async {
    Widget withInset(Widget child) => MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(bottom: 34)),
          child: child,
        );
    await pumpLoovi(tester, withInset(const LooviNavigationBar(items: _three, selectedIndex: 0, itemCount: LooviNavigationBarItemCount.three)));
    final bar = find.byType(LooviNavigationBar);
    expect(tester.getSize(bar).height, t.spacing.s800 + 34);
    // Content stays above the inset.
    final itemBottom = tester.getBottomLeft(find.byType(LooviNavigationBarItemView).first).dy;
    expect(itemBottom, tester.getBottomLeft(bar).dy - 34);

    await pumpLoovi(
      tester,
      withInset(const LooviNavigationBar(
        items: _three,
        selectedIndex: 0,
        itemCount: LooviNavigationBarItemCount.three,
        layout: LooviNavigationBarLayout.floating,
      )),
    );
    final surface = find.descendant(of: find.byType(LooviNavigationBar), matching: find.byType(DecoratedBox)).first;
    expect(tester.getBottomLeft(surface).dy, tester.getBottomLeft(find.byType(LooviNavigationBar)).dy - 34);
  });

  testWidgets('golden: variants', (tester) async {
    final focus = WidgetStatesController({WidgetState.focused});
    final pressed = WidgetStatesController({WidgetState.pressed});
    addTearDown(focus.dispose);
    addTearDown(pressed.dispose);

    Widget gap() => const SizedBox(height: 20);
    Widget inset(Widget c) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: c);

    await pumpGolden(
      tester,
      ColoredBox(
        color: t.color.backgroundSurface0,
        child: Column(
          key: const Key('golden'),
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const LooviNavigationBar(items: _three, selectedIndex: 0, itemCount: LooviNavigationBarItemCount.three),
            gap(),
            const LooviNavigationBar(items: _four, selectedIndex: 0),
            gap(),
            LooviNavigationBar(items: _painel, selectedIndex: 0, itemCount: LooviNavigationBarItemCount.five, onPrimaryAction: () {}),
            gap(),
            const LooviNavigationBar(items: _four, selectedIndex: 0, appearance: LooviNavigationBarAppearance.inverse),
            gap(),
            inset(LooviNavigationBar(
              items: _painel,
              selectedIndex: 0,
              itemCount: LooviNavigationBarItemCount.five,
              layout: LooviNavigationBarLayout.floating,
              onPrimaryAction: () {},
            )),
            gap(),
            inset(LooviNavigationBar(
              items: _painel,
              selectedIndex: 0,
              itemCount: LooviNavigationBarItemCount.five,
              layout: LooviNavigationBarLayout.floating,
              appearance: LooviNavigationBarAppearance.inverse,
              onPrimaryAction: () {},
            )),
            gap(),
            Row(
              children: [
                for (final (sel, ctrl) in [(false, null), (true, null), (false, focus), (true, focus), (false, pressed), (true, pressed)])
                  Expanded(
                    child: LooviNavigationBarItemView(
                      item: _four.first,
                      selected: sel,
                      statesController: ctrl,
                      onTap: () {},
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      height: 660,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/navigation_bar_variants.png'));
  });
}
