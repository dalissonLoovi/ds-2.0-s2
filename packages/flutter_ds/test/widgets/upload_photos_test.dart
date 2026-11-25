import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Statuses": every status, then pending with description.
class UploadPhotosStatuses extends StatelessWidget {
  const UploadPhotosStatuses({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (final s in LooviUploadPhotosStatus.values) ...[
            LooviUploadPhotos(label: 'Frente do veículo', status: s, onSelectPhoto: () {}, onRetakePhoto: () {}),
            SizedBox(height: t.spacing.s200),
          ],
          LooviUploadPhotos(
            label: 'Chassi',
            description: 'Foto nítida, sem reflexo, com o número legível.',
            showDescription: true,
            onSelectPhoto: () {},
          ),
        ]),
      ),
    );
  }
}

BoxDecoration _root(WidgetTester tester) => tester
    .widget<DecoratedBox>(find.descendant(of: find.byType(LooviUploadPhotos), matching: find.byType(DecoratedBox)).first)
    .decoration as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('surface by status: pending|rejected surface/2, in-review|approved surface/1; radius/300; min 64', (tester) async {
    for (final e in {
      LooviUploadPhotosStatus.pending: _t.color.backgroundSurface2,
      LooviUploadPhotosStatus.inReview: _t.color.backgroundSurface1,
      LooviUploadPhotosStatus.approved: _t.color.backgroundSurface1,
      LooviUploadPhotosStatus.rejected: _t.color.backgroundSurface2,
    }.entries) {
      await pumpLoovi(tester, LooviUploadPhotos(label: 'L', status: e.key, onSelectPhoto: () {}, onRetakePhoto: () {}));
      expect(_root(tester).color, e.value);
      expect(_root(tester).borderRadius, BorderRadius.circular(_t.radius.s300));
      expect(tester.getSize(find.byType(LooviUploadPhotos)).height, greaterThanOrEqualTo(_t.spacing.s800));
    }
  });

  testWidgets('leading camera-outline 24 text/primary; label body/medium/medium; description optional', (tester) async {
    await pumpLoovi(tester, const LooviUploadPhotos(label: 'L', description: 'D'));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon).first);
    expect(icon.name, LooviIcons.cameraOutline);
    expect(icon.size, _t.spacing.s300);
    expect(icon.color, _t.text.primary);
    final label = tester.widget<Text>(find.text('L'));
    expect(label.style!.color, _t.text.primary);
    expect(label.style!.fontWeight, _t.typography.bodyMediumMedium.fontWeight);
    expect(find.text('D'), findsNothing);
    await pumpLoovi(tester, const LooviUploadPhotos(label: 'L', description: 'D', showDescription: true));
    expect(tester.widget<Text>(find.text('D')).style!.color, _t.text.secondary);
  });

  testWidgets('pending: chevron-only text/sm Button named "Adicionar foto" calls onSelectPhoto', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, LooviUploadPhotos(label: 'L', onSelectPhoto: () => taps++));
    final b = tester.widget<LooviButton>(find.byType(LooviButton));
    expect(b.variant, LooviButtonVariant.text);
    expect(b.size, LooviButtonSize.sm);
    expect(b.showLabel, isFalse);
    expect(b.showTrailingIcon, isTrue);
    expect(b.label, 'Adicionar foto');
    expect(find.byType(LooviChipTag), findsNothing);
    await tester.tap(find.byType(LooviButton));
    expect(taps, 1);
  });

  testWidgets('in-review / approved: informational chip only (no action)', (tester) async {
    await pumpLoovi(tester, const LooviUploadPhotos(label: 'L', status: LooviUploadPhotosStatus.inReview));
    var chip = tester.widget<LooviChipTag>(find.byType(LooviChipTag));
    expect(chip.intent, LooviChipTagIntent.system);
    expect(chip.emphasis, LooviChipTagEmphasis.primary);
    expect(chip.size, LooviChipTagSize.sm);
    expect(chip.showLeadingIcon, isFalse);
    expect(chip.label, 'Em análise');
    expect(find.byType(LooviButton), findsNothing);

    await pumpLoovi(tester, const LooviUploadPhotos(label: 'L', status: LooviUploadPhotosStatus.approved));
    chip = tester.widget<LooviChipTag>(find.byType(LooviChipTag));
    expect(chip.intent, LooviChipTagIntent.success);
    expect(chip.showLeadingIcon, isTrue);
    expect(chip.label, 'Aprovada');
    expect(find.byType(LooviButton), findsNothing);
  });

  testWidgets('rejected: warning-filled chip + "Refazer foto" action calls onRetakePhoto', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      LooviUploadPhotos(label: 'L', status: LooviUploadPhotosStatus.rejected, onRetakePhoto: () => taps++),
    );
    final chip = tester.widget<LooviChipTag>(find.byType(LooviChipTag));
    expect(chip.intent, LooviChipTagIntent.warning);
    expect(chip.leadingIcon, LooviIcons.alertCircleOutline);
    expect(chip.label, 'Reprovada');
    expect(tester.widget<LooviButton>(find.byType(LooviButton)).label, 'Refazer foto');
    await tester.tap(find.byType(LooviButton));
    expect(taps, 1);
  });

  testWidgets('semantics: label and status exposed; action named', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviUploadPhotos(label: 'Chassi', status: LooviUploadPhotosStatus.rejected, onRetakePhoto: () {}));
    expect(find.bySemanticsLabel('Chassi'), findsOneWidget);
    expect(find.bySemanticsLabel('Reprovada'), findsOneWidget);
    expect(find.bySemanticsLabel('Refazer foto'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('textScaler 2.0 does not overflow', (tester) async {
    await pumpLoovi(
      tester,
      LooviUploadPhotos(label: 'Frente do veículo', status: LooviUploadPhotosStatus.rejected, onRetakePhoto: () {}),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: statuses', (tester) async {
    await pumpGolden(tester, const UploadPhotosStatuses(), height: 460);
    await expectLater(find.byType(UploadPhotosStatuses), matchesGoldenFile('../goldens/upload_photos_statuses.png'));
  });
}
