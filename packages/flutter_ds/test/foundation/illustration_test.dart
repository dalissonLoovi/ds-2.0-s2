import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  test('catalog: 60 illustrations, kebab-case <group>/<name>', () {
    expect(LooviIllustrations.all.length, 60);
    for (final name in LooviIllustrations.all) {
      expect(name, matches(RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*/[a-z0-9]+(-[a-z0-9]+)*$')));
      expect(LooviIllustrations.specOf(name)!.name, name);
    }
    expect(LooviIllustrations.claimReasonTheft, 'claim-reason/theft');
    expect(LooviIllustrations.specOf('nope/missing'), isNull);
  });

  test('every name resolves to an asset whose viewBox matches the spec', () async {
    for (final spec in LooviIllustrations.specs.values) {
      final file = File(spec.asset);
      expect(file.existsSync(), isTrue, reason: spec.asset);
      final svg = file.readAsStringSync();
      expect(svg, contains('viewBox="0 0 ${_n(spec.width)} ${_n(spec.height)}"'), reason: spec.name);
      // Bundled (pubspec assets folder registered).
      final data = await rootBundle.load('packages/loovi_ds/${spec.asset}');
      expect(data.lengthInBytes, file.lengthSync(), reason: spec.name);
      // Parses with flutter_svg (vector_graphics compiler).
      final info = await vg.loadPicture(SvgStringLoader(svg), null);
      expect(info.size, Size(spec.width, spec.height), reason: spec.name);
      info.picture.dispose();
    }
  });

  testWidgets('keeps the artboard aspect ratio by default', (tester) async {
    await pumpLoovi(tester, const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LooviIllustration(LooviIllustrations.claimReasonTheft, key: Key('natural')),
      LooviIllustration(LooviIllustrations.cardCredCard1, width: 164, key: Key('w')),
      LooviIllustration(LooviIllustrations.vehiclePhotoPainel, height: 105, key: Key('h')),
    ]));
    expect(tester.getSize(find.byKey(const Key('natural'))), const Size(156, 156));
    expect(tester.getSize(find.byKey(const Key('w'))), const Size(164, 100));
    expect(tester.getSize(find.byKey(const Key('h'))), const Size(226, 105));
  });

  testWidgets('semantics: decorative by default, labelled when asked', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Row(children: [
      LooviIllustration(LooviIllustrations.claimReasonTheft, width: 48),
      LooviIllustration(LooviIllustrations.feedbackSuccess, width: 48, semanticLabel: 'Sucesso'),
    ]));
    expect(find.bySemanticsLabel('Sucesso'), findsOneWidget);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Sucesso')).flagsCollection.isImage,
      isTrue,
    );
    final decorative = tester.getSemantics(find.byType(LooviIllustration).first);
    expect(decorative.label, isEmpty);
    handle.dispose();
  });

  testWidgets('gallery golden: every illustration renders', (tester) async {
    const cell = 44.0;
    await pumpGolden(
      tester,
      Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final n in LooviIllustrations.all)
            SizedBox.square(dimension: cell, child: LooviIllustration(n, width: cell, height: cell)),
        ],
      ),
      height: 400,
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(SvgPicture), findsNWidgets(LooviIllustrations.all.length));
    await expectLater(find.byType(Wrap), matchesGoldenFile('../goldens/foundation_illustrations.png'));
  });
}

String _n(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
