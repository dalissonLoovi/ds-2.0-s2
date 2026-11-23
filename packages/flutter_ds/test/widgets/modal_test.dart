import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

const _title = 'Cancelar plano?';
const _body = 'Você perde a cobertura a partir da data de cancelamento.';

/// Shell decoration of the first [LooviModal] (the one with the elevation).
BoxDecoration _shell(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviModal), matching: find.byType(DecoratedBox)))
    .map((b) => b.decoration as BoxDecoration)
    .firstWhere((d) => d.boxShadow != null && d.boxShadow!.isNotEmpty);

/// Painted close chip (fill = close-action/background).
Finder _closeChip() => find.byWidgetPredicate(
      (w) =>
          w is DecoratedBox &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).color == _t.component.modalHeader.closeActionBackground,
    );

Widget _bodyText(BuildContext context) {
  final t = LooviTokens.of(context);
  return Text(_body, style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary));
}

/// Seed footer: primary (solid) + secondary (text, destructive here). Platform
/// is inherited from the enclosing LooviModal.
Widget _footer(BuildContext context, {VoidCallback? onKeep, VoidCallback? onCancel}) => LooviModalFooter(
      primaryAction: LooviModalAction(label: 'Manter plano', onPressed: onKeep ?? () => Navigator.of(context).pop(false)),
      secondaryAction: LooviModalAction(
        label: 'Cancelar plano',
        intent: LooviButtonIntent.danger,
        onPressed: onCancel ?? () => Navigator.of(context).pop(true),
      ),
    );

/// Story "Variants": inline panels — same as the Widgetbook story.
class ModalVariants extends StatelessWidget {
  const ModalVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget caption(String s) => Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Text(s, style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
        );
    return ColoredBox(
      color: t.color.backgroundSurface1,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s300),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          caption('Modal · platform=mobile · slot + showFooter'),
          LooviModal(
            title: _title,
            onClose: () {},
            primaryAction: LooviModalAction(label: 'Manter plano', onPressed: () {}),
            secondaryAction: LooviModalAction(label: 'Cancelar plano', intent: LooviButtonIntent.danger, onPressed: () {}),
            child: Builder(builder: _bodyText),
          ),
          SizedBox(height: t.spacing.s300),
          caption('Modal · platform=web · showFooter'),
          LooviModal(
            title: _title,
            platform: LooviModalPlatform.web,
            onClose: () {},
            primaryAction: LooviModalAction(label: 'Manter', onPressed: () {}),
            secondaryAction: LooviModalAction(label: 'Cancelar', intent: LooviButtonIntent.danger, onPressed: () {}),
            child: Builder(builder: _bodyText),
          ),
          SizedBox(height: t.spacing.s300),
          caption('Modal · mobile · alignment=center · showLabel'),
          LooviModal(
            title: _title,
            label: 'Plano Essencial',
            showLabel: true,
            alignment: LooviModalHeaderAlignment.center,
            onClose: () {},
            child: Builder(builder: _bodyText),
          ),
          SizedBox(height: t.spacing.s300),
          caption('ModalHeader · layout=mobile · start / center'),
          ColoredBox(
            color: t.color.backgroundSurface0,
            child: Column(children: [
              LooviModalHeader(title: 'Cancelar plano?', label: 'Plano Essencial', showLabel: true, onClose: () {}),
              LooviModalHeader(
                title: 'Cancelar plano?',
                label: 'Plano Essencial',
                showLabel: true,
                alignment: LooviModalHeaderAlignment.center,
                onClose: () {},
              ),
              LooviModalHeader(title: 'Cancelar plano?', showCloseAction: false),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Opens the dialog from a button.
class _Launcher extends StatelessWidget {
  const _Launcher({this.onResult});
  final ValueChanged<bool?>? onResult;

  @override
  Widget build(BuildContext context) => LooviButton(
        label: 'Abrir',
        onPressed: () async {
          final r = await showLooviModal<bool>(
            context,
            title: _title,
            builder: _bodyText,
            footerBuilder: (c) => _footer(c),
          );
          onResult?.call(r);
        },
      );
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('shell radius = component/modal/container/radius (32), surface/0, elevation/1', (tester) async {
    await pumpLoovi(tester, LooviModal(title: _title, onClose: () {}, child: const Text(_body)));
    final d = _shell(tester);
    expect(_t.component.modal.containerRadius, 32);
    expect(d.borderRadius, BorderRadius.circular(_t.component.modal.containerRadius));
    expect(d.color, _t.color.backgroundSurface0);
    expect(d.boxShadow, LooviEffects.box(_t.effects.elevation1));
  });

  testWidgets('close paints 32 (size-mobile) surface/2 full, hit target 48, calls onClose', (tester) async {
    var closes = 0;
    await pumpLoovi(tester, LooviModal(title: _title, onClose: () => closes++, child: const Text(_body)));
    expect(tester.getSize(_closeChip()), Size.square(_t.component.modalHeader.closeActionSizeMobile));
    expect(tester.getSize(_closeChip()), const Size.square(32));
    final chip = tester.widget<DecoratedBox>(_closeChip()).decoration as BoxDecoration;
    expect(chip.borderRadius, BorderRadius.circular(_t.component.modalHeader.closeActionRadius));
    final target = tester.getSize(find.byType(LooviTapTarget));
    expect(target.width, greaterThanOrEqualTo(48));
    expect(target.height, greaterThanOrEqualTo(48));
    // Tap on the hit-area edge (outside the painted 32) still closes.
    final r = tester.getRect(find.byType(LooviTapTarget));
    await tester.tapAt(r.topLeft + const Offset(2, 2));
    expect(closes, 1);
  });

  testWidgets('desktop close stays spacing/500 (40); title heading/h1', (tester) async {
    await pumpLoovi(
      tester,
      LooviModal(title: _title, platform: LooviModalPlatform.web, onClose: () {}, child: const Text(_body)),
    );
    expect(tester.getSize(_closeChip()), Size.square(_t.spacing.s500));
    expect(tester.widget<Text>(find.text(_title)).style!.fontSize, _t.typography.headingH1SemiBold.fontSize);
  });

  testWidgets('semantics: route named by title, title is header, close "Fechar modal"', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviModal(title: _title, onClose: () {}, child: const Text(_body)));
    expect(
      tester.getSemantics(find.byType(LooviModal)),
      isSemantics(label: _title, scopesRoute: true, namesRoute: true),
    );
    expect(find.bySemanticsLabel('Fechar modal'), findsOneWidget);
    expect(tester.getSemantics(find.text(_title)), isSemantics(label: _title, isHeader: true));
    handle.dispose();
  });

  testWidgets('showLooviModal: opens with overlay barrier; close pops', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: _Launcher()));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviModal), findsOneWidget);
    final barrier = tester.widgetList<ModalBarrier>(find.byType(ModalBarrier)).last;
    expect(barrier.color, _t.color.overlayOverlay);
    await tester.tap(find.bySemanticsLabel('Fechar modal'));
    await tester.pumpAndSettle();
    expect(find.byType(LooviModal), findsNothing);
  });

  testWidgets('showLooviModal: barrier tap, back and Esc close', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: _Launcher()));

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(LooviModal), findsNothing, reason: 'barrier');

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(LooviModal), findsNothing, reason: 'back');

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(LooviModal), findsNothing, reason: 'Esc');
  });

  testWidgets('footer actions call back with the route result', (tester) async {
    bool? result;
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: _Launcher(onResult: (r) => result = r)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar plano'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
    expect(find.byType(LooviModal), findsNothing);

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manter plano'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('footer mobile: vertical, full width, primary on top, md, gap spacing/100', (tester) async {
    await pumpLoovi(
      tester,
      LooviModal(
        title: _title,
        primaryAction: LooviModalAction(label: 'P', onPressed: () {}),
        secondaryAction: LooviModalAction(label: 'S', onPressed: () {}),
        child: const Text(_body),
      ),
    );
    final buttons = tester.widgetList<LooviButton>(find.byType(LooviButton)).where((b) => b.label != '').toList();
    final p = tester.widget<LooviButton>(find.widgetWithText(LooviButton, 'P'));
    final s = tester.widget<LooviButton>(find.widgetWithText(LooviButton, 'S'));
    expect(buttons, isNotEmpty);
    expect(p.variant, LooviButtonVariant.solid);
    expect(s.variant, LooviButtonVariant.text);
    expect(p.size, LooviButtonSize.md);
    expect(p.fullWidth, isTrue);
    final pr = tester.getRect(find.widgetWithText(LooviButton, 'P'));
    final sr = tester.getRect(find.widgetWithText(LooviButton, 'S'));
    expect(pr.bottom, lessThan(sr.top));
    expect(sr.top - pr.bottom, _t.spacing.s100);
    expect(pr.width, sr.width);
    final body = tester.getRect(find.text(_body));
    expect(pr.left, body.left);
  });

  testWidgets('footer web: horizontal, right-aligned, lg, secondary before primary', (tester) async {
    await pumpLoovi(
      tester,
      LooviModal(
        title: _title,
        platform: LooviModalPlatform.web,
        primaryAction: LooviModalAction(label: 'P', onPressed: () {}),
        secondaryAction: LooviModalAction(label: 'S', onPressed: () {}),
        child: const Text(_body),
      ),
    );
    final p = tester.widget<LooviButton>(find.widgetWithText(LooviButton, 'P'));
    expect(p.size, LooviButtonSize.lg);
    expect(p.fullWidth, isFalse);
    final pr = tester.getRect(find.widgetWithText(LooviButton, 'P'));
    final sr = tester.getRect(find.widgetWithText(LooviButton, 'S'));
    expect(sr.right, lessThan(pr.left));
    expect(pr.top, sr.top);
    final shell = tester.getRect(find.byType(LooviModal));
    expect(shell.right - pr.right, _t.spacing.s300);
  });

  testWidgets('no footer by default', (tester) async {
    await pumpLoovi(tester, LooviModal(title: _title, onClose: () {}, child: const Text(_body)));
    expect(find.byType(LooviModalFooter), findsNothing);
  });

  testWidgets('textScaler 2: dialog content scrolls without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    // The dialog route sits above the harness MediaQuery: scale the platform.
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(looviHarness(
      Builder(
        builder: (context) => LooviButton(
          label: 'Abrir',
          onPressed: () => showLooviModal<void>(
            context,
            title: _title,
            builder: (c) => Column(children: [for (var i = 0; i < 8; i++) const Text(_body)]),
            footerBuilder: (c) => _footer(c),
          ),
        ),
      ),
      textScale: 2,
    ));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(MediaQuery.textScalerOf(tester.element(find.text(_title))).scale(10), 20);
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.getRect(find.byType(LooviModal)).bottom, lessThanOrEqualTo(640));
  });

  testWidgets('footer mobile: focus order = visual order (close, primary on top, secondary)', (tester) async {
    await pumpLoovi(
      tester,
      LooviModal(
        title: _title,
        onClose: () {},
        primaryAction: LooviModalAction(label: 'P', onPressed: () {}),
        secondaryAction: LooviModalAction(label: 'S', onPressed: () {}),
        child: const Text(_body),
      ),
    );
    final order = <String>[];
    for (var i = 0; i < 3; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final ctx = FocusManager.instance.primaryFocus!.context!;
      order.add(ctx.findAncestorWidgetOfExactType<LooviButton>()?.label ?? 'close');
    }
    expect(order, ['close', 'P', 'S']);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const ModalVariants(), height: 1140);
    await expectLater(find.byType(ModalVariants), matchesGoldenFile('../goldens/modal_variants.png'));
  });
}
