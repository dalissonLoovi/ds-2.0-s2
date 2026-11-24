import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Content": dot (sm) · count (lg) · overflow (lg), standalone and
/// attached to a bell icon. Same as the Widgetbook story.
class BadgeMatrix extends StatelessWidget {
  const BadgeMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    const badges = [
      LooviBadge(),
      LooviBadge.count(3),
      LooviBadge.count(42),
      LooviBadge.overflow(),
    ];
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              for (final b in badges) ...[b, SizedBox(width: t.spacing.s300)],
            ]),
            SizedBox(height: t.spacing.s300),
            Row(children: [
              for (final b in badges) ...[
                // Attached to an icon: anchored on the top-end corner.
                SizedBox.square(
                  dimension: t.spacing.s500,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(child: LooviIcon(LooviIcons.bellOutline, size: t.spacing.s300)),
                      PositionedDirectional(top: t.spacing.s050, start: t.spacing.s250, child: b),
                    ],
                  ),
                ),
                SizedBox(width: t.spacing.s300),
              ],
            ]),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _pill(WidgetTester tester, Finder badge) => tester
    .widget<Container>(find.descendant(of: badge, matching: find.byType(Container)))
    .decoration as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('dot: player-record-filled 16 in palette/tangerine-1, no text', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviBadge()));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.playerRecordFilled);
    expect(icon.size, _t.spacing.s200);
    expect(icon.color, _t.color.paletteTangerine1);
    expect(find.byType(Text), findsNothing);
    expect(tester.getSize(find.byType(LooviBadge)), Size.square(_t.spacing.s200));
  });

  testWidgets('count: 16 circle, tangerine-1, caption/large/regular text/primary', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviBadge.count(7)));
    final badge = find.byType(LooviBadge);
    final d = _pill(tester, badge);
    expect(d.color, _t.color.paletteTangerine1);
    expect(d.borderRadius, BorderRadius.circular(_t.radius.full));
    expect(tester.getSize(badge), Size.square(_t.spacing.s200));
    final txt = tester.widget<Text>(find.text('7'));
    expect(txt.style!.color, _t.text.primary);
    expect(txt.style!.fontSize, _t.typography.captionLargeRegular.fontSize);
    expect(txt.style!.fontWeight, _t.typography.captionLargeRegular.fontWeight);
  });

  testWidgets('overflow: height 16, padding-x spacing/050, label 999+', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviBadge.overflow()));
    final badge = find.byType(LooviBadge);
    expect(find.text('999+'), findsOneWidget);
    expect(tester.getSize(badge).height, _t.spacing.s200);
    final text = tester.getRect(find.text('999+'));
    expect(text.left - tester.getRect(badge).left, _t.spacing.s050);
    final c = tester.widget<Container>(find.descendant(of: badge, matching: find.byType(Container)));
    expect(c.padding, EdgeInsets.symmetric(horizontal: _t.spacing.s050));
  });

  testWidgets('never focusable or tappable', (tester) async {
    await pumpLoovi(tester, const LooviBadge.count(2));
    expect(find.descendant(of: find.byType(LooviBadge), matching: find.byType(GestureDetector)), findsNothing);
    expect(find.descendant(of: find.byType(LooviBadge), matching: find.byType(Focus)), findsNothing);
  });

  testWidgets('semantics: count / overflow / dot labels; decorative hidden; override', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const Column(children: [
        LooviBadge(key: Key('dot')),
        LooviBadge.count(5, key: Key('count')),
        LooviBadge.overflow(key: Key('over')),
        LooviBadge.count(9, decorative: true),
        LooviBadge.count(3, key: Key('named'), semanticLabel: '3 notificações não lidas'),
      ]),
    );
    expect(tester.getSemantics(find.byKey(const Key('dot'))).label, 'Nova notificação');
    expect(tester.getSemantics(find.byKey(const Key('count'))).label, '5');
    expect(tester.getSemantics(find.byKey(const Key('over'))).label, '999+');
    expect(tester.getSemantics(find.byKey(const Key('named'))).label, '3 notificações não lidas');
    expect(find.bySemanticsLabel('9'), findsNothing);
    handle.dispose();
  });

  testWidgets('textScaler 2: pill grows, no overflow', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviBadge.overflow()), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(LooviBadge)).height, greaterThan(_t.spacing.s200));
  });

  testWidgets('golden: content matrix', (tester) async {
    await pumpGolden(tester, const BadgeMatrix(), height: 140);
    await expectLater(find.byType(BadgeMatrix), matchesGoldenFile('../goldens/badge_matrix.png'));
  });
}
