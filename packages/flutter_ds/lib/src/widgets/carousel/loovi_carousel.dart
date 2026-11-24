import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../carousel_pagination_item/loovi_carousel_pagination_item.dart';

/// Builds the "page X of Y" announcement (1-based [page]).
typedef LooviCarouselPageLabel = String Function(int page, int count);

String _defaultPageLabel(int page, int count) => 'Slide $page de $count';

/// Carousel (Figma 4152:849) — horizontal swipeable content shell with
/// pagination dots ([LooviCarouselPaginationItem]).
///
/// Interaction (seed): horizontal swipe with peek of the next slide + dots.
/// No prev/next chevrons and no autoplay (the seed defines none). Swipes snap
/// to one slide; the last slide snaps flush with the end edge.
///
/// Paint (mode app-cliente):
/// - shell: vertical, gap `spacing/0`; width Fill (Figma demo 360).
/// - slot: horizontal, gap `spacing/100` between slides, clips content, hugs
///   the slide height. The slides are [children] (seed `slot`; prefer
///   ImageItem or product cards).
/// - slide width = shell width - [peek] - `spacing/100`. Frame: 280 slides in
///   a 360 shell, so 72 of the next slide is visible (frame not tokenized:
///   `spacing/900`). A single slide takes the full width.
/// - pagination: [LooviCarouselPaginationItem] (`itemCount` = slide count,
///   `itemView` = current slide), toggled by [showPaginationItem].
///
/// Semantics: adjustable container named [semanticLabel] with the value
/// "Slide X de Y" ([pageLabel]); screen-reader increase / decrease moves one
/// slide. Slide content keeps its own semantics (give slides accessible
/// names). The dots are excluded from semantics.
///
/// Reduced motion: programmatic page changes ([LooviCarouselState.animateToPage],
/// semantic increase / decrease) jump without animation when
/// `MediaQuery.disableAnimations` is on.
class LooviCarousel extends StatefulWidget {
  const LooviCarousel({
    super.key,
    required this.children,
    this.showPaginationItem = true,
    this.initialPage = 0,
    this.onPageChanged,
    this.peek,
    this.semanticLabel,
    this.pageLabel = _defaultPageLabel,
  });

  /// Seed `slot`: the slides.
  final List<Widget> children;

  /// Seed `showPaginationItem` (default true). Dots only render with 2+ slides.
  final bool showPaginationItem;

  /// First slide shown (0-based).
  final int initialPage;

  /// Called with the 0-based index when the current slide changes.
  final ValueChanged<int>? onPageChanged;

  /// Visible width of the next slide. Null = `spacing/900` (Figma 72).
  final double? peek;

  /// Accessible name of the carousel (e.g. "Ofertas").
  final String? semanticLabel;

  /// Current-slide announcement (1-based page). Default "Slide X de Y".
  final LooviCarouselPageLabel pageLabel;

  @override
  State<LooviCarousel> createState() => LooviCarouselState();
}

/// State of [LooviCarousel]; reach it with a `GlobalKey<LooviCarouselState>`
/// to change the slide from code.
class LooviCarouselState extends State<LooviCarousel> {
  final ScrollController _controller = ScrollController();
  late int _page = _clampPage(widget.initialPage);
  double? _stride;
  bool _positioned = false;

  /// Current slide (0-based).
  int get page => _page;

  int get _count => widget.children.length;

  int _clampPage(int p) => p.clamp(0, _count - 1);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(LooviCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _page = _clampPage(_page);
      _positioned = false;
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  int _pageForOffset(double offset) {
    final stride = _stride;
    if (stride == null || stride <= 0 || !_controller.hasClients) return _page;
    final max = _controller.position.maxScrollExtent;
    // The last slide rests at maxScrollExtent (flush end), short of n * stride.
    if (_count > 1 && offset >= max - 0.5) return _count - 1;
    return _clampPage((offset / stride).round());
  }

  double _offsetForPage(int page) {
    final stride = _stride ?? 0;
    if (!_controller.hasClients) return page * stride;
    return math.min(page * stride, _controller.position.maxScrollExtent);
  }

  void _onScroll() {
    final p = _pageForOffset(_controller.offset);
    if (p != _page) {
      setState(() => _page = p);
      widget.onPageChanged?.call(p);
    }
  }

  /// Moves to [page] (0-based). Jumps when the platform asks for reduced motion.
  Future<void> animateToPage(int page) async {
    final target = _clampPage(page);
    if (!_controller.hasClients) return;
    final offset = _offsetForPage(target);
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _controller.jumpTo(offset);
      return;
    }
    await _controller.animateTo(offset, duration: kThemeAnimationDuration, curve: Curves.easeOutCubic);
  }

  void _syncPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      _controller.jumpTo(_offsetForPage(_page));
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final gap = t.spacing.s100;
    final peek = widget.peek ?? t.spacing.s900;
    final count = _count;
    assert(count > 0, 'Carousel needs at least one slide');
    assert(
      !widget.showPaginationItem || count <= 5,
      'CarouselPaginationItem supports 2 to 5 dots (seed); hide it or use at most 5 slides',
    );

    final slot = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final single = count == 1;
        final stride = single ? width + gap : math.max(width - peek, gap * 2);
        final slideWidth = single ? width : stride - gap;
        if (_stride != stride || !_positioned) {
          _stride = stride;
          _positioned = true;
          if (_page > 0) _syncPosition();
        }
        return SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.hardEdge,
          physics: _LooviCarouselSnapPhysics(stride: stride),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < count; i++) ...[
                if (i > 0) SizedBox(width: gap),
                SizedBox(width: slideWidth, child: widget.children[i]),
              ],
            ],
          ),
        );
      },
    );

    final hasPrev = _page > 0;
    final hasNext = _page < count - 1;
    final semanticSlot = Semantics(
      container: true,
      label: widget.semanticLabel,
      value: widget.pageLabel(_page + 1, count),
      increasedValue: hasNext ? widget.pageLabel(_page + 2, count) : null,
      decreasedValue: hasPrev ? widget.pageLabel(_page, count) : null,
      onIncrease: hasNext ? () => animateToPage(_page + 1) : null,
      onDecrease: hasPrev ? () => animateToPage(_page - 1) : null,
      child: slot,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        semanticSlot,
        if (widget.showPaginationItem && count >= 2) ...[
          SizedBox(height: t.spacing.s0),
          LooviCarouselPaginationItem(itemCount: count, itemView: _page + 1),
        ],
      ],
    );
  }
}

/// Snaps a horizontal scroll to multiples of [stride] (one slide + gap),
/// clamped to the scroll extent so the last slide rests flush with the end.
class _LooviCarouselSnapPhysics extends ScrollPhysics {
  const _LooviCarouselSnapPhysics({required this.stride, super.parent});

  final double stride;

  @override
  _LooviCarouselSnapPhysics applyTo(ScrollPhysics? ancestor) =>
      _LooviCarouselSnapPhysics(stride: stride, parent: buildParent(ancestor));

  double _target(ScrollMetrics position, double velocity) {
    final tolerance = toleranceFor(position);
    var page = position.pixels / stride;
    if (velocity < -tolerance.velocity) {
      page = page.floorToDouble();
    } else if (velocity > tolerance.velocity) {
      page = page.ceilToDouble();
    } else {
      page = page.roundToDouble();
    }
    return (page * stride).clamp(position.minScrollExtent, position.maxScrollExtent);
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final target = _target(position, velocity);
    if ((target - position.pixels).abs() < toleranceFor(position).distance) return null;
    return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: toleranceFor(position));
  }

  @override
  bool get allowImplicitScrolling => false;
}
