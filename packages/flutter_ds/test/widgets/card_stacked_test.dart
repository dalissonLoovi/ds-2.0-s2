import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('media-and-text anatomy: avatar, menu, media ratio, texts, actions', (tester) async {
    await pumpLoovi(tester, const LooviCardStacked(avatarInitials: 'AB'));
    expect(tester.widget<LooviAvatar>(find.byType(LooviAvatar)).size, LooviAvatarSize.sm);
    final buttons = tester.widgetList<LooviButton>(find.byType(LooviButton)).toList();
    expect(buttons, hasLength(3));
    expect(buttons[0].variant, LooviButtonVariant.text);
    expect(buttons[0].showLabel, isFalse);
    expect(buttons[0].leadingIcon, LooviIcons.dotsVerticalOutline);
    expect(buttons[1].variant, LooviButtonVariant.outline);
    expect(buttons[1].size, LooviButtonSize.sm);
    expect(buttons[2].variant, LooviButtonVariant.solid);
    expect(tester.widget<AspectRatio>(find.byType(AspectRatio)).aspectRatio, LooviCardStacked.mediaAspectRatio);
    expect(tester.widget<Text>(find.text('Title')).style!.color, _t.text.primary);
    expect(tester.widget<Text>(find.text('Subtitle')).style!.color, _t.text.secondary);
    // Actions end-aligned (Figma actions primaryAxisAlign MAX).
    final card = tester.getRect(find.byType(LooviCardStacked));
    expect(tester.getRect(find.byWidget(buttons[2])).right, closeTo(card.right - _t.spacing.s200, 0.5));
  });

  testWidgets('showSecondaryAction=false hides the outline action; showMenuAction=false hides the menu', (tester) async {
    await pumpLoovi(tester, const LooviCardStacked(showSecondaryAction: false, showMenuAction: false));
    final buttons = tester.widgetList<LooviButton>(find.byType(LooviButton)).toList();
    expect(buttons, hasLength(1));
    expect(buttons.single.variant, LooviButtonVariant.solid);
  });

  testWidgets('actions fire; menu is named for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    var primary = 0, secondary = 0, menu = 0;
    await pumpLoovi(
      tester,
      LooviCardStacked(
        onPrimaryPressed: () => primary++,
        onSecondaryPressed: () => secondary++,
        onMenuPressed: () => menu++,
      ),
    );
    await tester.tap(find.text('Primary'));
    await tester.tap(find.text('Secondary'));
    await tester.tap(find.bySemanticsLabel('Mais opções'));
    expect((primary, secondary, menu), (1, 1, 1));
    handle.dispose();
  });

  testWidgets('slot layout renders the custom child only', (tester) async {
    await pumpLoovi(tester, const LooviCardStacked(layout: LooviCardStackedLayout.slot, slot: Text('custom')));
    expect(find.text('custom'), findsOneWidget);
    expect(find.byType(LooviButton), findsNothing);
  });

  testWidgets('style maps to the Card*Item surface', (tester) async {
    for (final (style, color) in [
      (LooviCardStackedStyle.outlined, _t.color.backgroundSurface0),
      (LooviCardStackedStyle.elevated, _t.color.backgroundSurface1),
      (LooviCardStackedStyle.filled, _t.color.backgroundSurface2),
    ]) {
      await pumpLoovi(tester, LooviCardStacked(style: style, layout: LooviCardStackedLayout.slot, slot: const SizedBox(height: 40)));
      final deco = tester
          .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviCardStacked), matching: find.byType(DecoratedBox)))
          .first
          .decoration as BoxDecoration;
      expect(deco.color, color);
    }
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(tester, const SingleChildScrollView(child: LooviCardStacked()), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: outlined media-and-text + elevated slot', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LooviCardStacked(avatarInitials: 'AB', onMenuPressed: () {}, onPrimaryPressed: () {}, onSecondaryPressed: () {}),
            SizedBox(height: _t.spacing.s200),
            LooviCardStacked(
              style: LooviCardStackedStyle.elevated,
              layout: LooviCardStackedLayout.slot,
              slot: Container(
                height: _t.spacing.s1000,
                padding: EdgeInsets.all(_t.spacing.s100),
                decoration: BoxDecoration(color: _t.color.backgroundSurface2, borderRadius: BorderRadius.circular(_t.radius.s200)),
                child: Text('Slot content', style: _t.typography.bodyMediumRegular.copyWith(color: _t.text.secondary)),
              ),
            ),
          ],
        ),
      ),
      height: 680,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/card_stacked_variants.png'));
  });
}
