import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Matrix": itemCount 2..5 x itemView 1..itemCount (14 published).
class CarouselPaginationItemMatrix extends StatelessWidget {
  const CarouselPaginationItemMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var count = 2; count <= 5; count++)
              Row(
                children: [
                  for (var view = 1; view <= 5; view++)
                    Expanded(
                      child: view <= count
                          ? LooviCarouselPaginationItem(itemCount: count, itemView: view)
                          : const SizedBox.shrink(),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

List<Color> _dotColors(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviCarouselPaginationItem), matching: find.byType(DecoratedBox)))
    .map((d) => (d.decoration as BoxDecoration).color!)
    .toList();

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('dots: active = itemView in actions/primary, others border/2', (tester) async {
    await pumpLoovi(tester, const LooviCarouselPaginationItem(itemCount: 4, itemView: 2));
    expect(_dotColors(tester), [_t.color.border2, _t.color.actionsPrimary, _t.color.border2, _t.color.border2]);
  });

  testWidgets('geometry: dot spacing/100, gap spacing/100, padY spacing/100, centered, full width', (tester) async {
    await pumpLoovi(tester, const LooviCarouselPaginationItem(itemCount: 3, itemView: 1));
    final dots = find.descendant(of: find.byType(LooviCarouselPaginationItem), matching: find.byType(DecoratedBox));
    expect(tester.getSize(dots.first), Size.square(_t.spacing.s100));
    expect(tester.getRect(dots.at(1)).left - tester.getRect(dots.first).right, _t.spacing.s100);
    final root = tester.getRect(find.byType(LooviCarouselPaginationItem));
    expect(root.width, 390);
    expect(root.height, _t.spacing.s100 * 3);
    // Centered: 3 dots + 2 gaps = 40 → starts at 175.
    expect(tester.getRect(dots.first).left, (390 - _t.spacing.s100 * 5) / 2);
  });

  testWidgets('decorative: no semantics nodes', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviCarouselPaginationItem(itemCount: 5, itemView: 3));
    expect(find.ancestor(of: find.byType(Row), matching: find.byType(ExcludeSemantics)), findsWidgets);
    handle.dispose();
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, const CarouselPaginationItemMatrix(), height: 112);
    await expectLater(
      find.byType(CarouselPaginationItemMatrix),
      matchesGoldenFile('../goldens/carousel_pagination_item_matrix.png'),
    );
  });
}
