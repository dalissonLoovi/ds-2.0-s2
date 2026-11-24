import 'package:loovi_ds/loovi_ds.dart';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// 8×8 gradient PNG standing in for a profile photo.
final _photo = MemoryImage(base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAk0lEQVR4nBXKoZUFIRAAwYvzZ0AGozEY9GgMBj0ag+ms+t6Wrr9fYAuMwBGYgTuwAl/g369j6xgdR8fsuDtWx9e/MLFNjIljYk7cE2vim19IbImROBIzcSdW4ssvLGwLY+FYmAv3wlr41hcOtoNxcBzMg/tgHXznC4WtMApHYRbuwip89YWL7WJcHBfz4r5YF9/Ff9davCGiPj5VAAAAAElFTkSuQmCC',
));

/// Freezes the loading spinner so pumpAndSettle settles.
Widget _still(Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child,
      ),
    );

/// Forces a runtime interaction state on an interactive avatar (stories /
/// goldens only).
WidgetStatesController _forced(WidgetState s) => WidgetStatesController({s});

/// Story "Matrix": rows = content × size (md, sm, micro); columns = state
/// (default, hover, focus, disabled, loading). Same as the Widgetbook story.
class AvatarMatrix extends StatelessWidget {
  const AvatarMatrix({super.key, required this.photo});

  final ImageProvider photo;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget cell(LooviAvatarContent c, LooviAvatarSize s, String state) => LooviAvatar(
          content: c,
          size: s,
          image: photo,
          initials: 'Sofia Oliveira',
          disabled: state == 'disabled',
          loading: state == 'loading',
          onPressed: state == 'hover' || state == 'focus' ? () {} : null,
          statesController: state == 'hover'
              ? _forced(WidgetState.hovered)
              : state == 'focus'
                  ? _forced(WidgetState.focused)
                  : null,
        );
    const states = ['default', 'hover', 'focus', 'disabled', 'loading'];
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final c in LooviAvatarContent.values) ...[
              for (final s in [LooviAvatarSize.md, LooviAvatarSize.sm, LooviAvatarSize.micro])
                Padding(
                  padding: EdgeInsets.only(bottom: t.spacing.s050),
                  child: Row(children: [
                    for (final st in states)
                      SizedBox(width: t.spacing.s900, child: Center(child: cell(c, s, st))),
                  ]),
                ),
              SizedBox(height: t.spacing.s100),
            ],
          ],
        ),
      ),
    );
  }
}

/// Story "Sizes": initials micro → xl.
class AvatarSizes extends StatelessWidget {
  const AvatarSizes({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s100),
        child: Row(
          children: [
            for (final s in LooviAvatarSize.values.reversed) ...[
              LooviAvatar(content: LooviAvatarContent.initials, initials: 'SO', size: s),
              SizedBox(width: t.spacing.s050),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _precache(WidgetTester tester) async {
  await tester.runAsync(() async {
    final ctx = tester.element(find.byType(Scaffold));
    await precacheImage(_photo, ctx);
  });
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('sizes: micro 24 · xs 32 · sm 48 · md 64 · lg 80 · xl 96 (spacing tokens)', (tester) async {
    await pumpLoovi(
      tester,
      Wrap(children: [
        for (final s in LooviAvatarSize.values) LooviAvatar(key: Key(s.name), size: s),
      ]),
    );
    final expected = {
      LooviAvatarSize.micro: _t.spacing.s300,
      LooviAvatarSize.xs: _t.spacing.s400,
      LooviAvatarSize.sm: _t.spacing.s600,
      LooviAvatarSize.md: _t.spacing.s800,
      LooviAvatarSize.lg: _t.spacing.s1000,
      LooviAvatarSize.xl: _t.spacing.s1200,
    };
    for (final e in expected.entries) {
      expect(tester.getSize(find.byKey(Key(e.key.name))), Size.square(e.value), reason: e.key.name);
    }
  });

  testWidgets('initials: surface/3 fill, text/primary, style per size, max 2 chars', (tester) async {
    await pumpLoovi(
      tester,
      const Wrap(children: [
        LooviAvatar(content: LooviAvatarContent.initials, initials: 'sofia', size: LooviAvatarSize.md),
      ]),
    );
    expect(find.text('SO'), findsOneWidget);
    final fills = tester.widgetList<ColoredBox>(find.descendant(of: find.byType(LooviAvatar).first, matching: find.byType(ColoredBox)));
    expect(fills.first.color, _t.color.backgroundSurface3);
    final txt = tester.widget<Text>(find.text('SO').first);
    expect(txt.style!.color, _t.text.primary);
    expect(txt.style!.fontSize, _t.typography.headingH2Regular.fontSize);
    for (final (s, style) in [
      (LooviAvatarSize.micro, _t.typography.bodySmallRegular),
      (LooviAvatarSize.xs, _t.typography.bodyLargeRegular),
      (LooviAvatarSize.sm, _t.typography.headingH3Regular),
      (LooviAvatarSize.md, _t.typography.headingH2Regular),
      (LooviAvatarSize.lg, _t.typography.headingH1Regular),
      (LooviAvatarSize.xl, _t.typography.displayLargeRegular),
    ]) {
      expect(LooviAvatar.initialsStyleFor(_t, s), style);
    }
  });

  testWidgets('placeholder: user-outline in text/placeholder, icon size per size', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviAvatar(size: LooviAvatarSize.xl)));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.userOutline);
    expect(icon.color, _t.text.placeholder);
    expect(icon.size, _t.spacing.s700);
    expect(LooviAvatar.iconFor(_t, LooviAvatarSize.micro), _t.spacing.s200);
    expect(LooviAvatar.iconFor(_t, LooviAvatarSize.sm), _t.spacing.s300);
    expect(LooviAvatar.iconFor(_t, LooviAvatarSize.lg), _t.spacing.s500);
  });

  testWidgets('falls back to placeholder without image / initials', (tester) async {
    await pumpLoovi(
      tester,
      const Row(children: [
        LooviAvatar(content: LooviAvatarContent.image),
        LooviAvatar(content: LooviAvatarContent.initials, initials: '  '),
      ]),
    );
    expect(find.byType(Image), findsNothing);
    expect(tester.widgetList<LooviIcon>(find.byType(LooviIcon)).map((i) => i.name), everyElement(LooviIcons.userOutline));
  });

  testWidgets('image: photo, no surface/3 shell', (tester) async {
    await pumpLoovi(tester, LooviAvatar(content: LooviAvatarContent.image, image: _photo));
    await _precache(tester);
    expect(find.byType(Image), findsOneWidget);
    expect(find.descendant(of: find.byType(LooviAvatar), matching: find.byType(ColoredBox)), findsNothing);
  });

  testWidgets('disabled: initials text/placeholder, not tappable', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      LooviAvatar(content: LooviAvatarContent.initials, initials: 'SO', disabled: true, onPressed: () => taps++),
    );
    expect(tester.widget<Text>(find.text('SO')).style!.color, _t.text.placeholder);
    await tester.tap(find.byType(LooviAvatar));
    expect(taps, 0);
  });

  testWidgets('loading: elevation/4 overlay + sm spinner sized per avatar, content hidden', (tester) async {
    await pumpLoovi(
      tester,
      _still(const Align(
        alignment: Alignment.topLeft,
        child: LooviAvatar(content: LooviAvatarContent.initials, initials: 'SO', size: LooviAvatarSize.sm, loading: true),
      )),
    );
    expect(find.text('SO'), findsNothing);
    final spinner = tester.widget<LooviLoadingSpinner>(find.byType(LooviLoadingSpinner));
    expect(spinner.size, LooviLoadingSpinnerSize.sm);
    expect(spinner.dimension, _t.spacing.s250);
    expect(spinner.decorative, isTrue);
    final fills = tester.widgetList<ColoredBox>(find.descendant(of: find.byType(LooviAvatar), matching: find.byType(ColoredBox)));
    expect(fills.map((b) => b.color), contains(_t.color.elevation4));
    expect(LooviAvatar.spinnerFor(_t, LooviAvatarSize.xl), _t.spacing.s400);
    expect(LooviAvatar.spinnerFor(_t, LooviAvatarSize.md), _t.spacing.s300);
    expect(LooviAvatar.spinnerFor(_t, LooviAvatarSize.micro), _t.spacing.s200);
  });

  testWidgets('hover: upload-outline replaces content; image gets inverse-3 + elevation/4', (tester) async {
    await pumpLoovi(
      tester,
      Row(children: [
        LooviAvatar(
          key: const Key('i'),
          content: LooviAvatarContent.initials,
          initials: 'SO',
          onPressed: () {},
          statesController: _forced(WidgetState.hovered),
        ),
        LooviAvatar(
          key: const Key('p'),
          content: LooviAvatarContent.image,
          image: _photo,
          onPressed: () {},
          statesController: _forced(WidgetState.hovered),
        ),
      ]),
    );
    expect(find.text('SO'), findsNothing);
    LooviIcon iconIn(Key k) => tester.widget<LooviIcon>(find.descendant(of: find.byKey(k), matching: find.byType(LooviIcon)));
    expect(iconIn(const Key('i')).name, LooviIcons.uploadOutline);
    expect(iconIn(const Key('i')).color, _t.text.primary);
    expect(iconIn(const Key('p')).color, _t.color.backgroundSurface0);
    final imageFills = tester
        .widgetList<ColoredBox>(find.descendant(of: find.byKey(const Key('p')), matching: find.byType(ColoredBox)))
        .map((b) => b.color)
        .toList();
    expect(imageFills, [_t.color.elevationInverse3, _t.color.elevation4]);
  });

  testWidgets('focus: 2 px interactive/focus ring with a 2 px gap outside the shell', (tester) async {
    await pumpLoovi(
      tester,
      Center(
        child: LooviAvatar(
          size: LooviAvatarSize.xl,
          onPressed: () {},
          statesController: _forced(WidgetState.focused),
        ),
      ),
    );
    final ring = find.descendant(of: find.byType(LooviAvatar), matching: find.byType(DecoratedBox));
    final d = tester.widget<DecoratedBox>(ring).decoration as BoxDecoration;
    expect(d.shape, BoxShape.circle);
    expect(d.border!.top.color, _t.interactive.focus);
    expect(d.border!.top.width, _t.borderWidth.s025);
    // 96 shell + 2 × (gap 2 + ring 2) = 104 (Figma avatar.focus-ring).
    expect(tester.getSize(ring), const Size.square(104));
  });

  testWidgets('interactive: button semantics, tap, 48 dp target on micro', (tester) async {
    var taps = 0;
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: LooviAvatar(
          size: LooviAvatarSize.micro,
          semanticLabel: 'Alterar foto de perfil',
          onPressed: () => taps++,
        ),
      ),
    );
    expect(tester.getSize(find.byType(LooviAvatar)), Size.square(_t.spacing.s600));
    expect(
      tester.getSemantics(find.byType(LooviAvatar)),
      isSemantics(label: 'Alterar foto de perfil', isButton: true, hasTapAction: true),
    );
    await tester.tapAt(tester.getTopLeft(find.byType(LooviAvatar)) + const Offset(2, 2));
    expect(taps, 1);
    handle.dispose();
  });

  testWidgets('static: decorative without label, image semantics with label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const Row(children: [
        LooviAvatar(content: LooviAvatarContent.initials, initials: 'AB'),
        LooviAvatar(content: LooviAvatarContent.initials, initials: 'SO', semanticLabel: 'Sofia Oliveira'),
      ]),
    );
    expect(find.bySemanticsLabel('AB'), findsNothing);
    expect(find.bySemanticsLabel('Sofia Oliveira'), findsOneWidget);
    expect(find.descendant(of: find.byType(LooviAvatar), matching: find.byType(GestureDetector)), findsNothing);
    handle.dispose();
  });

  testWidgets('textScaler 2: initials scale down inside the circle', (tester) async {
    await pumpLoovi(
      tester,
      const LooviAvatar(content: LooviAvatarContent.initials, initials: 'SO', size: LooviAvatarSize.micro),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: sizes', (tester) async {
    await pumpGolden(tester, const AvatarSizes(), height: 112);
    await expectLater(find.byType(AvatarSizes), matchesGoldenFile('../goldens/avatar_sizes.png'));
  });

  testWidgets('golden: content × state matrix', (tester) async {
    await pumpGolden(tester, _still(AvatarMatrix(photo: _photo)), height: 600);
    await _precache(tester);
    await expectLater(find.byType(AvatarMatrix), matchesGoldenFile('../goldens/avatar_matrix.png'));
  });
}
