import 'dart:ui' show SemanticsAction;
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Demo slide like the Figma slide frames (surface/1, radius/200, 92 tall).
class CarouselDemoSlide extends StatelessWidget {
  const CarouselDemoSlide(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Container(
      height: t.spacing.s1100 + t.spacing.s050,
      decoration: BoxDecoration(color: t.color.backgroundSurface1, borderRadius: BorderRadius.circular(t.radius.s200)),
      alignment: Alignment.center,
      child: Text(label, style: t.typography.bodyMediumMedium.copyWith(color: t.text.primary)),
    );
  }
}

List<Widget> _slides(int n) => [for (var i = 1; i <= n; i++) CarouselDemoSlide('Slide $i')];

/// Story "Default": 4 slides with dots, then page 3 of 4, then without dots.
class CarouselDefault extends StatelessWidget {
  const CarouselDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LooviCarousel(semanticLabel: 'Ofertas', children: _slides(4)),
            SizedBox(height: t.spacing.s300),
            LooviCarousel(semanticLabel: 'Ofertas', initialPage: 3, children: _slides(4)),
            SizedBox(height: t.spacing.s300),
            LooviCarousel(showPaginationItem: false, children: _slides(3)),
          ],
        ),
      ),
    );
  }
}

Finder _carouselSemantics() =>
    find.byWidgetPredicate((w) => w is Semantics && (w.properties.value ?? '').startsWith('Slide '));

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('layout: slide = width - peek(spacing/900) - gap(spacing/100); hugs slide height; dots', (tester) async {
    await pumpLoovi(tester, LooviCarousel(children: _slides(4)));
    final slide = tester.getRect(find.byType(CarouselDemoSlide).first);
    final second = tester.getRect(find.byType(CarouselDemoSlide).at(1));
    expect(slide.width, 390 - _t.spacing.s900 - _t.spacing.s100);
    expect(second.left - slide.right, _t.spacing.s100);
    expect(slide.left, 0);
    final pag = tester.widget<LooviCarouselPaginationItem>(find.byType(LooviCarouselPaginationItem));
    expect(pag.itemCount, 4);
    expect(pag.itemView, 1);
    // slot height = slide (92) + pagination (8 + 8 + 8).
    expect(tester.getSize(find.byType(LooviCarousel)).height, 92 + _t.spacing.s100 * 3);
  });

  testWidgets('swipe snaps one slide and updates dots + onPageChanged', (tester) async {
    final pages = <int>[];
    await pumpLoovi(tester, LooviCarousel(onPageChanged: pages.add, children: _slides(4)));
    await tester.fling(find.byType(CarouselDemoSlide).first, const Offset(-120, 0), 800);
    await tester.pumpAndSettle();
    final stride = 390 - _t.spacing.s900;
    expect(tester.getRect(find.byType(CarouselDemoSlide).at(1)).left, closeTo(0, 0.5));
    expect(tester.getRect(find.byType(CarouselDemoSlide).first).right, closeTo(-_t.spacing.s100, 0.5));
    expect(stride, greaterThan(0));
    expect(pages.last, 1);
    expect(tester.widget<LooviCarouselPaginationItem>(find.byType(LooviCarouselPaginationItem)).itemView, 2);
  });

  testWidgets('small drag without velocity snaps back', (tester) async {
    await pumpLoovi(tester, LooviCarousel(children: _slides(3)));
    await tester.drag(find.byType(CarouselDemoSlide).first, const Offset(-40, 0));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(CarouselDemoSlide).first).left, closeTo(0, 0.5));
  });

  testWidgets('last slide rests flush with the end edge', (tester) async {
    await pumpLoovi(tester, LooviCarousel(initialPage: 3, children: _slides(4)));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(CarouselDemoSlide).last).right, closeTo(390, 0.5));
    expect(tester.widget<LooviCarouselPaginationItem>(find.byType(LooviCarouselPaginationItem)).itemView, 4);
  });

  testWidgets('semantics: "Slide X de Y" with increase / decrease', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviCarousel(semanticLabel: 'Ofertas', children: _slides(3)));
    final node = tester.getSemantics(_carouselSemantics());
    expect(node.label, 'Ofertas');
    expect(node.value, 'Slide 1 de 3');
    expect(node.increasedValue, 'Slide 2 de 3');
    expect(node.getSemanticsData().hasAction(SemanticsAction.increase), isTrue);
    expect(node.getSemanticsData().hasAction(SemanticsAction.decrease), isFalse);
    node.owner!.performAction(node.id, SemanticsAction.increase);
    await tester.pumpAndSettle();
    expect(tester.getSemantics(_carouselSemantics()).value, 'Slide 2 de 3');
    // Dots are decorative.
    expect(
      find.descendant(of: find.byType(LooviCarouselPaginationItem), matching: find.byType(ExcludeSemantics)),
      findsWidgets,
    );
    handle.dispose();
  });

  testWidgets('reduced motion: programmatic page change jumps (no animation)', (tester) async {
    final key = GlobalKey<LooviCarouselState>();
    await tester.pumpWidget(
      looviHarness(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: LooviCarousel(key: key, children: _slides(3)),
          ),
        ),
      ),
    );
    await tester.pump();
    key.currentState!.animateToPage(1);
    await tester.pump();
    expect(tester.getRect(find.byType(CarouselDemoSlide).at(1)).left, closeTo(0, 0.5));
    expect(key.currentState!.page, 1);
  });

  testWidgets('showPaginationItem=false hides dots; one slide takes the full width', (tester) async {
    await pumpLoovi(
      tester,
      Column(children: [
        LooviCarousel(showPaginationItem: false, children: _slides(2)),
        const LooviCarousel(children: [CarouselDemoSlide('Única')]),
      ]),
    );
    expect(find.byType(LooviCarouselPaginationItem), findsNothing);
    expect(tester.getSize(find.byType(CarouselDemoSlide).last).width, 390);
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(tester, LooviCarousel(children: _slides(3)), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: default', (tester) async {
    await pumpGolden(tester, const CarouselDefault(), height: 420);
    await expectLater(find.byType(CarouselDefault), matchesGoldenFile('../goldens/carousel_default.png'));
  });
}
