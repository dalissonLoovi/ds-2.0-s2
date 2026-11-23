import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

List<String> _icons(WidgetTester tester) => tester.widgetList<LooviIcon>(find.byType(LooviIcon)).map((i) => i.name).toList();

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('composes LooviInput with seed defaults (Senha, lock-outline, eye-closed)', (tester) async {
    await pumpLoovi(tester, const LooviInputPassword());
    expect(find.byType(LooviInput), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Digite sua senha'), findsOneWidget);
    expect(_icons(tester), containsAll([LooviIcons.lockOutline, LooviIcons.eyeClosedOutline]));
  });

  testWidgets('typing updates value; value is obscured while hidden', (tester) async {
    final controller = TextEditingController();
    await pumpLoovi(tester, LooviInputPassword(controller: controller));
    await tester.enterText(find.byType(TextField), 'segredo1');
    await tester.pump();
    expect(controller.text, 'segredo1');
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
  });

  testWidgets('toggle reveals/hides the value and renames the action', (tester) async {
    final handle = tester.ensureSemantics();
    final changes = <LooviInputPasswordVisibility>[];
    await pumpLoovi(tester, LooviInputPassword(onVisibilityChange: changes.add));
    expect(find.bySemanticsLabel('Mostrar senha'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Mostrar senha'));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isFalse);
    expect(_icons(tester), contains(LooviIcons.eyeOutline));
    expect(find.bySemanticsLabel('Ocultar senha'), findsOneWidget);
    expect(changes, [LooviInputPasswordVisibility.visible]);

    await tester.tap(find.bySemanticsLabel('Ocultar senha'));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
    expect(changes.last, LooviInputPasswordVisibility.hidden);
    handle.dispose();
  });

  testWidgets('semantics: obscured text field with label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviInputPassword(controller: TextEditingController(text: 'abc')));
    final data = tester.getSemantics(find.byType(TextField)).getSemanticsData();
    expect(data.label, contains('Senha'));
    expect(data.flagsCollection.isTextField, isTrue);
    expect(data.flagsCollection.isObscured, isTrue);
    handle.dispose();
  });

  testWidgets('error shows alert beside the action and danger message', (tester) async {
    await pumpLoovi(tester, const LooviInputPassword(errorText: 'Senha incorreta'));
    expect(tester.widget<Text>(find.text('Senha incorreta')).style!.color, _t.feedback.danger);
    final icons = _icons(tester);
    expect(icons.indexOf(LooviIcons.alertCircleOutline), lessThan(icons.indexOf(LooviIcons.eyeClosedOutline)));
  });

  testWidgets('disabled: not editable and action disabled', (tester) async {
    final controller = TextEditingController(text: 'x');
    var changed = 0;
    await pumpLoovi(tester, LooviInputPassword(controller: controller, enabled: false, onVisibilityChange: (_) => changed++));
    await tester.enterText(find.byType(TextField), 'novo');
    await tester.tap(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.eyeClosedOutline));
    await tester.pump();
    expect(controller.text, 'x');
    expect(changed, 0);
  });

  testWidgets('visibility action keeps a 48 dp target; radius is app-cliente full', (tester) async {
    await pumpLoovi(tester, const LooviInputPassword());
    final eye = find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.eyeClosedOutline);
    expect(tester.getSize(eye), Size.square(_t.spacing.s200));
    final target = find.ancestor(of: eye, matching: find.byType(GestureDetector)).first;
    expect(tester.getSize(target).height, greaterThanOrEqualTo(48));
    expect(tester.getSize(target).width, greaterThanOrEqualTo(48));
    final deco = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((d) => d.decoration as BoxDecoration)
        .firstWhere((d) => d.border != null);
    expect(deco.borderRadius, BorderRadius.circular(_t.component.input.fieldRadius));
    expect(_t.component.input.fieldRadius, _t.radius.full);
  });

  testWidgets('golden: InputPassword states (app-cliente)', (tester) async {
    await pumpGolden(tester, const _PasswordStates(), height: 520);
    await expectLater(find.byType(_PasswordStates), matchesGoldenFile('../goldens/input_password_states.png'));
  });
}

class _PasswordStates extends StatelessWidget {
  const _PasswordStates();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    return Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LooviInputPassword(),
          gap(),
          LooviInputPassword(controller: TextEditingController(text: 'Password123')),
          gap(),
          LooviInputPassword(controller: TextEditingController(text: 'Password123'), visibility: LooviInputPasswordVisibility.visible),
          gap(),
          LooviInputPassword(controller: TextEditingController(text: 'Password123'), autofocus: true, showCursor: false),
          gap(),
          LooviInputPassword(
            controller: TextEditingController(text: 'Password123'),
            visibility: LooviInputPasswordVisibility.visible,
            errorText: 'Supporting text',
          ),
          gap(),
          LooviInputPassword(controller: TextEditingController(text: 'Password123'), enabled: false),
        ],
      ),
    );
  }
}
