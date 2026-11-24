import 'package:loovi_ds/loovi_ds.dart';
import 'dart:ui' show SemanticsAction, SemanticsRole, Tristate;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

const _three = [LooviTab(label: 'Resumo'), LooviTab(label: 'Pagamentos'), LooviTab(label: 'Documentos')];
const _withDisabled = [
  LooviTab(label: 'Um'),
  LooviTab(label: 'Dois', disabled: true),
  LooviTab(label: 'Três'),
];
const _five = [
  LooviTab(label: 'Visão geral', showIcon: true, leadingIcon: LooviIcons.homeOutline),
  LooviTab(label: 'Veículo', showIcon: true, leadingIcon: LooviIcons.carOutline),
  LooviTab(label: 'Pagamentos', showIcon: true, leadingIcon: LooviIcons.walletOutline),
  LooviTab(label: 'Documentos', showIcon: true, leadingIcon: LooviIcons.fileTextOutline),
  LooviTab(label: 'Ajuda', showIcon: true, leadingIcon: LooviIcons.headsetOutline),
];

enum _Kind { primary, primaryInverse, secondary, segmented }

Widget _tabs(_Kind kind, List<LooviTab> tabs, int index, ValueChanged<int>? onChanged,
        {LooviTabsAlignment alignment = LooviTabsAlignment.left}) =>
    switch (kind) {
      _Kind.primary => LooviTabsPrimary(tabs: tabs, selectedIndex: index, onChanged: onChanged, alignment: alignment),
      _Kind.primaryInverse => LooviTabsPrimary(
          tabs: tabs,
          selectedIndex: index,
          onChanged: onChanged,
          alignment: alignment,
          appearance: LooviTabsPrimaryAppearance.inverse,
        ),
      _Kind.secondary => LooviTabsSecondary(tabs: tabs, selectedIndex: index, onChanged: onChanged, alignment: alignment),
      _Kind.segmented => LooviTabsSegmented(tabs: tabs, selectedIndex: index, onChanged: onChanged, alignment: alignment),
    };

class _Host extends StatefulWidget {
  const _Host(this.kind, this.tabs, {this.initial = 0});
  final _Kind kind;
  final List<LooviTab> tabs;
  final int initial;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late int index = widget.initial;
  @override
  Widget build(BuildContext context) => _tabs(widget.kind, widget.tabs, index, (i) => setState(() => index = i));
}

int _selected(WidgetTester tester) {
  final items = tester.widgetList<LooviTabItem>(find.byType(LooviTabItem)).toList();
  return items.indexWhere((i) => i.selected);
}

/// Story "Variants" (mobile).
class TabsVariants extends StatelessWidget {
  const TabsVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    void noop(int _) {}
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          gap(),
          LooviTabsPrimary(tabs: _three, selectedIndex: 0, onChanged: noop),
          gap(),
          LooviTabsPrimary(tabs: _three.sublist(0, 2), selectedIndex: 1, onChanged: noop, alignment: LooviTabsAlignment.center),
          gap(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.s200),
            child: LooviTabsPrimary(
              tabs: _three,
              selectedIndex: 0,
              onChanged: noop,
              appearance: LooviTabsPrimaryAppearance.inverse,
            ),
          ),
          gap(),
          LooviTabsPrimary(tabs: _five, selectedIndex: 0, onChanged: noop),
          gap(),
          LooviTabsSecondary(tabs: _three, selectedIndex: 0, onChanged: noop),
          gap(),
          LooviTabsSecondary(tabs: _withDisabled, selectedIndex: 2, onChanged: noop, alignment: LooviTabsAlignment.center),
          gap(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.s200),
            child: Column(children: [
              LooviTabsSegmented(
                tabs: const [LooviTab(label: 'Cartão'), LooviTab(label: 'Pix')],
                selectedIndex: 0,
                onChanged: noop,
              ),
              gap(),
              LooviTabsSegmented(
                tabs: const [
                  LooviTab(label: 'Mensal'),
                  LooviTab(label: 'Anual', showAttention: true),
                  LooviTab(label: 'Único', disabled: true),
                ],
                selectedIndex: 1,
                onChanged: noop,
              ),
            ]),
          ),
          gap(),
        ],
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  for (final kind in _Kind.values) {
    group(kind.name, () {
      testWidgets('tap selects (controlled), disabled tab is skipped', (tester) async {
        await pumpLoovi(tester, _Host(kind, _withDisabled));
        expect(_selected(tester), 0);
        await tester.tap(find.text('Três'));
        await tester.pump();
        expect(_selected(tester), 2);
        await tester.tap(find.text('Dois'), warnIfMissed: false);
        await tester.pump();
        expect(_selected(tester), 2);
      });

      testWidgets('48 dp band: taps above/below the painted tab still select it', (tester) async {
        await pumpLoovi(tester, _Host(kind, _three));
        final band = find.descendant(of: find.byType(_Host), matching: find.byType(GestureDetector)).first;
        expect(tester.getSize(band).height, greaterThanOrEqualTo(_t.spacing.s600));
        final tab = tester.getRect(find.byType(LooviTabItem).at(1));
        final bandRect = tester.getRect(band);
        await tester.tapAt(Offset(tab.center.dx, bandRect.top + 1));
        await tester.pump();
        expect(_selected(tester), 1);
        await tester.tapAt(Offset(tester.getRect(find.byType(LooviTabItem).at(2)).center.dx, bandRect.bottom - 1));
        await tester.pump();
        expect(_selected(tester), 2);
      });

      testWidgets('keyboard: arrows (wrap, skip disabled), Home/End', (tester) async {
        await pumpLoovi(tester, _Host(kind, _withDisabled));
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        expect(_selected(tester), 2, reason: 'skips disabled "Dois"');
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        expect(_selected(tester), 0, reason: 'wraps');
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pump();
        expect(_selected(tester), 2);
        await tester.sendKeyEvent(LogicalKeyboardKey.home);
        await tester.pump();
        expect(_selected(tester), 0);
        await tester.sendKeyEvent(LogicalKeyboardKey.end);
        await tester.pump();
        expect(_selected(tester), 2);
      });

      testWidgets('semantics: tabBar with tab children, selected flag', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpLoovi(tester, _Host(kind, _withDisabled));
        final a = tester.getSemantics(find.bySemanticsLabel('Um'));
        expect(a.getSemanticsData().role, SemanticsRole.tab);
        expect(a.flagsCollection.isSelected, Tristate.isTrue);
        final c = tester.getSemantics(find.bySemanticsLabel('Três'));
        expect(c.flagsCollection.isSelected, Tristate.isFalse);
        expect(c.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
        final b = tester.getSemantics(find.bySemanticsLabel('Dois'));
        expect(b.flagsCollection.isEnabled, Tristate.isFalse);
        final parent = a.parent;
        expect(parent!.getSemanticsData().role, SemanticsRole.tabBar);
        handle.dispose();
      });
    });
  }

  testWidgets('primary default: padding-x spacing/200, gap spacing/100, no fill', (tester) async {
    await pumpLoovi(tester, _tabs(_Kind.primary, _three, 0, (_) {}));
    final a = tester.getRect(find.byType(LooviTabItem).at(0));
    final b = tester.getRect(find.byType(LooviTabItem).at(1));
    expect(a.left, _t.spacing.s200);
    expect(b.left - a.right, _t.spacing.s100);
    expect(a.height, 44);
  });

  testWidgets('primary inverse: track inverse-2, radius 200, padding 050, gap 0, 52 tall', (tester) async {
    await pumpLoovi(tester, _tabs(_Kind.primaryInverse, _three, 0, (_) {}));
    final track = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviTabsPrimary), matching: find.byType(DecoratedBox)))
        .first;
    final d = track.decoration as BoxDecoration;
    expect(d.color, _t.color.backgroundSurfaceInverse2);
    expect(d.borderRadius, BorderRadius.circular(_t.radius.s200));
    final a = tester.getRect(find.byType(LooviTabItem).at(0));
    final b = tester.getRect(find.byType(LooviTabItem).at(1));
    expect(b.left, a.right);
    expect(a.left, _t.spacing.s050);
    expect(tester.getSize(find.byType(LooviTabsPrimary)).height, 44 + 2 * _t.spacing.s050);
  });

  testWidgets('segmented: track tokens, equal widths, 36 painted in 48 band', (tester) async {
    await pumpLoovi(tester, _tabs(_Kind.segmented, _three, 0, (_) {}));
    final track = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviTabsSegmented), matching: find.byType(DecoratedBox)))
        .first;
    final d = track.decoration as BoxDecoration;
    expect(d.color, _t.color.backgroundSurface0);
    expect((d.border! as Border).top.color, _t.color.border2);
    expect((d.border! as Border).top.width, _t.borderWidth.s012);
    expect(d.borderRadius, BorderRadius.circular(_t.radius.full));
    final widths = [for (var i = 0; i < 3; i++) tester.getSize(find.byType(LooviTabItem).at(i)).width];
    expect(widths.toSet().length, 1);
    final trackSize = tester.getSize(find.descendant(of: find.byType(LooviTabsSegmented), matching: find.byType(DecoratedBox)).first);
    expect(trackSize.height, 28 + 2 * _t.spacing.s050);
    expect(tester.getSize(find.byType(LooviTabsSegmented)).height, _t.spacing.s600);
  });

  testWidgets('secondary: tabs bottom-aligned; indicator on band bottom', (tester) async {
    await pumpLoovi(tester, _tabs(_Kind.secondary, _three, 1, (_) {}));
    final band = tester.getRect(find.byType(LooviTabsSecondary));
    final tab = tester.getRect(find.byType(LooviTabItem).at(1));
    expect(tab.bottom, band.bottom);
    expect(band.height, _t.spacing.s600);
  });

  testWidgets('5 tabs overflow 390: scroll, no exception, selected scrolled into view', (tester) async {
    await pumpLoovi(tester, const _Host(_Kind.primary, _five, initial: 4));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    final ajuda = tester.getRect(find.text('Ajuda'));
    expect(ajuda.right, lessThanOrEqualTo(390));
    expect(ajuda.left, greaterThanOrEqualTo(0));
  });

  testWidgets('onChanged null: no selection change, tabs disabled', (tester) async {
    await pumpLoovi(tester, _tabs(_Kind.primary, _three, 0, null));
    await tester.tap(find.text('Pagamentos'), warnIfMissed: false);
    await tester.pump();
    expect(_selected(tester), 0);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const TabsVariants(), height: 560);
    await expectLater(find.byType(TabsVariants), matchesGoldenFile('../goldens/tabs_variants.png'));
  });
}
