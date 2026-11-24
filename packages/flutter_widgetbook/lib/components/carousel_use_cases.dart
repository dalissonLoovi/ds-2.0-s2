// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Demo slide like the Figma slide frames (surface/1, radius/200, 92 tall).
class _Slide extends StatelessWidget {
  const _Slide(this.label);
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

List<Widget> _slides(int n) => [for (var i = 1; i <= n; i++) _Slide('Slide $i')];

/// Carousel (seed node 4152:849): Playground + Default (same as the golden
/// `carousel_default.png`). Swipe to change slides; no chevrons, no autoplay.
WidgetbookComponent looviCarouselComponent() => WidgetbookComponent(
  name: 'Carousel',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final count = k.int.slider(label: 'slides (itemCount)', initialValue: 4, min: 1, max: 5);
        return SeedStory(
          component: 'Carousel',
          child: LooviCarousel(
            key: ValueKey(count),
            showPaginationItem: k.boolean(label: 'showPaginationItem', initialValue: true),
            semanticLabel: k.string(label: 'accessible label', initialValue: 'Ofertas'),
            children: _slides(count),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const SeedStory(component: 'Carousel', showDescription: false, child: _CarouselDefault()),
    ),
  ],
);

class _CarouselDefault extends StatelessWidget {
  const _CarouselDefault();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LooviCarousel(semanticLabel: 'Ofertas', children: _slides(4)),
        SizedBox(height: t.spacing.s300),
        LooviCarousel(semanticLabel: 'Ofertas', initialPage: 3, children: _slides(4)),
        SizedBox(height: t.spacing.s300),
        LooviCarousel(showPaginationItem: false, children: _slides(3)),
      ],
    );
  }
}
