import 'dart:ui' show SemanticsRole;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  Widget menu({bool showScroll = false, bool showDivider = true}) => LooviListActionDropdown.grouped(
        showScroll: showScroll,
        showDivider: showDivider,
        semanticLabel: 'Ações do veículo',
        groups: [
          [
            LooviListActionDropdownItem(label: 'Editar apelido', onSelect: () {}),
            LooviListActionDropdownItem(label: 'Adicionar motorista', icon: LooviIcons.plusOutline, onSelect: () {}),
          ],
          [
            LooviListActionDropdownItem(label: 'Ver documentos', icon: LooviIcons.fileTextOutline, onSelect: () {}),
          ],
        ],
      );

  testWidgets('shell: surface/0, list-action radius, elevation/2, 8 dp vertical padding', (tester) async {
    await pumpLoovi(tester, menu());
    final deco = tester
        .widget<DecoratedBox>(find.descendant(of: find.byType(LooviListActionDropdown), matching: find.byType(DecoratedBox)).first)
        .decoration as BoxDecoration;
    expect(deco.color, t.color.backgroundSurface0);
    expect(deco.borderRadius, BorderRadius.circular(t.component.listAction.containerRadius));
    expect(t.component.listAction.containerRadius, t.radius.s500);
    expect(deco.boxShadow, LooviEffects.box(t.effects.elevation2));
    final items = tester.getSize(find.byType(LooviListActionDropdownItem).first).height * 3;
    final divider = tester.getSize(find.byType(LooviListItemDivider)).height;
    expect(tester.getSize(find.byType(LooviListActionDropdown)).height, items + divider + 2 * t.spacing.s100);
  });

  testWidgets('showDivider toggles the group divider; showScroll paints the thumb', (tester) async {
    await pumpLoovi(tester, menu(showDivider: false));
    expect(find.byType(LooviListItemDivider), findsNothing);
    await pumpLoovi(tester, menu(showScroll: true));
    expect(find.byType(LooviListItemDivider), findsOneWidget);
    final thumb = tester.widgetList<Container>(find.descendant(of: find.byType(LooviListActionDropdown), matching: find.byType(Container))).where(
          (c) => (c.decoration as BoxDecoration?)?.color == t.color.paletteGraph,
        );
    expect(thumb, hasLength(1));
  });

  testWidgets('semantics: menu with label, items are menuItem', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, menu());
    final node = tester.getSemantics(find.bySemanticsLabel('Ações do veículo'));
    expect(node.getSemanticsData().role, SemanticsRole.menu);
    final item = tester.getSemantics(find.bySemanticsLabel('Editar apelido'));
    expect(item.getSemanticsData().role, SemanticsRole.menuItem);
    handle.dispose();
  });

  testWidgets('ArrowDown / ArrowUp move focus between items', (tester) async {
    final a = FocusNode(), b = FocusNode();
    addTearDown(a.dispose);
    addTearDown(b.dispose);
    await pumpLoovi(
      tester,
      LooviListActionDropdown(
        children: [
          LooviListActionDropdownItem(label: 'Editar', focusNode: a, onSelect: () {}),
          LooviListActionDropdownItem(label: 'Adicionar', icon: LooviIcons.plusOutline, focusNode: b, onSelect: () {}),
        ],
      ),
    );
    a.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(b.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(a.hasFocus, isTrue);
  });

  testWidgets('showLooviListActionDropdown: anchored below trigger, item pops with value, Escape and barrier dismiss', (tester) async {
    String? result = 'unset';
    await pumpLoovi(
      tester,
      Builder(
        builder: (context) => Align(
          alignment: Alignment.topLeft,
          child: Builder(
            builder: (triggerContext) => GestureDetector(
              key: const Key('trigger'),
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                result = await showLooviListActionDropdown<String>(
                  context: triggerContext,
                  builder: (menuContext) => LooviListActionDropdown(
                    children: [
                      LooviListActionDropdownItem(label: 'Editar', onSelect: () => Navigator.pop(menuContext, 'edit')),
                    ],
                  ),
                );
              },
              child: const SizedBox(width: 48, height: 48),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    expect(find.byType(LooviListActionDropdown), findsOneWidget);
    final trigger = tester.getRect(find.byKey(const Key('trigger')));
    final panel = tester.getRect(find.byType(LooviListActionDropdown));
    expect(panel.top, greaterThan(trigger.bottom - 0.01));
    expect(panel.left, greaterThanOrEqualTo(t.spacing.s200));
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviListActionDropdown), findsNothing);
    expect(result, 'edit');

    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(LooviListActionDropdown), findsNothing);
    expect(result, isNull);

    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(380, 500));
    await tester.pumpAndSettle();
    expect(find.byType(LooviListActionDropdown), findsNothing);
  });

  testWidgets('golden: grouped with divider and scroll thumb', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: const EdgeInsets.all(24),
        child: Align(alignment: Alignment.topLeft, child: SizedBox(width: 240, child: menu(showScroll: true))),
      ),
      height: 260,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_action_dropdown.png'));
  });
}
