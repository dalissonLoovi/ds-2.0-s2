import 'dart:ui' show SemanticsRole, Tristate;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  BoxDecoration fill(WidgetTester tester) => tester
      .widget<Container>(find.descendant(of: find.byType(LooviListActionDropdownItem), matching: find.byType(Container)).first)
      .decoration! as BoxDecoration;

  testWidgets('renders label + 20 dp icon with seed tokens', (tester) async {
    await pumpLoovi(tester, LooviListActionDropdownItem(label: 'Editar', onSelect: () {}));
    expect(find.text('Editar'), findsOneWidget);
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.editOutline);
    expect(icon.size, t.spacing.s250);
    expect(icon.color, t.text.secondary);
    final label = tester.widget<Text>(find.text('Editar'));
    expect(label.style!.color, t.text.primary);
    expect(label.style!.fontSize, t.typography.bodyMediumRegular.fontSize);
    expect(fill(tester).color, t.color.backgroundSurface0);
    expect(fill(tester).borderRadius, BorderRadius.circular(t.radius.s100));
  });

  testWidgets('showIcon=false hides the icon', (tester) async {
    await pumpLoovi(tester, LooviListActionDropdownItem(label: 'Editar', showIcon: false, onSelect: () {}));
    expect(find.byType(LooviIcon), findsNothing);
  });

  testWidgets('tap fires onSelect, pressed paints interactive/pressed, height >= 48', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, LooviListActionDropdownItem(label: 'Editar', onSelect: () => taps++));
    expect(tester.getSize(find.byType(LooviListActionDropdownItem)).height, greaterThanOrEqualTo(48));
    final gesture = await tester.startGesture(tester.getCenter(find.byType(LooviListActionDropdownItem)));
    await tester.pump();
    expect(fill(tester).color, t.interactive.pressed);
    await gesture.up();
    await tester.pump();
    expect(taps, 1);
    expect(fill(tester).color, t.color.backgroundSurface0);
  });

  testWidgets('selected paints interactive/selected and exposes selected', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviListActionDropdownItem(label: 'Editar', selected: true, onSelect: () {}));
    expect(fill(tester).color, t.interactive.selected);
    final node = tester.getSemantics(find.byType(LooviListActionDropdownItem));
    expect(node.getSemanticsData().flagsCollection.isSelected, isNot(false));
    handle.dispose();
  });

  testWidgets('disabled: disabled-surface, placeholder ink, no tap, not focusable', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(tester, LooviListActionDropdownItem(label: 'Editar', disabled: true, onSelect: () => taps++));
    expect(fill(tester).color, t.interactive.disabledSurface);
    expect(tester.widget<Text>(find.text('Editar')).style!.color, t.text.placeholder);
    expect(tester.widget<LooviIcon>(find.byType(LooviIcon)).color, t.text.placeholder);
    await tester.tap(find.byType(LooviListActionDropdownItem), warnIfMissed: false);
    expect(taps, 0);
    expect(find.byType(FocusableActionDetector), findsNothing);
    final data = tester.getSemantics(find.byType(LooviListActionDropdownItem)).getSemanticsData();
    expect(data.flagsCollection.isFocused, Tristate.none);
    handle.dispose();
  });

  testWidgets('keyboard focus shows the interactive/focus ring; Enter activates', (tester) async {
    var taps = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);
    await pumpLoovi(tester, LooviListActionDropdownItem(label: 'Editar', focusNode: node, onSelect: () => taps++));
    node.requestFocus();
    await tester.pump();
    await tester.pump(); // focus highlight callback runs post-frame
    final ring = tester
        .widget<Container>(find.descendant(of: find.byType(LooviListActionDropdownItem), matching: find.byType(Container)).first)
        .foregroundDecoration as BoxDecoration?;
    expect((ring!.border! as Border).top.color, t.interactive.focus);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('semantics: button outside a menu, menuItem inside the dropdown', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviListActionDropdownItem(key: const Key('a'), label: 'Editar', onSelect: () {}));
    var data = tester.getSemantics(find.byKey(const Key('a'))).getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.label, 'Editar');

    await pumpLoovi(
      tester,
      LooviListActionDropdown(children: [LooviListActionDropdownItem(key: const Key('b'), label: 'Editar', onSelect: () {})]),
    );
    data = tester.getSemantics(find.byKey(const Key('b'))).getSemanticsData();
    expect(data.role, SemanticsRole.menuItem);
    handle.dispose();
  });

  testWidgets('golden: states', (tester) async {
    await pumpGolden(
      tester,
      Column(
        key: const Key('golden'),
        mainAxisSize: MainAxisSize.min,
        children: [
          LooviListActionDropdownItem(label: 'Editar', onSelect: () {}),
          LooviListActionDropdownItem(label: 'Selecionado', icon: LooviIcons.checkOutline, selected: true, onSelect: () {}),
          LooviListActionDropdownItem(label: 'Indisponível', icon: LooviIcons.uploadOutline, disabled: true, onSelect: () {}),
          LooviListActionDropdownItem(label: 'Sem ícone', showIcon: false, onSelect: () {}),
        ],
      ),
      height: 200,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_action_dropdown_item_states.png'));
  });
}
