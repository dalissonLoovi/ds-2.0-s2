import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:loovi_tokens/testing.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps [child] in the app-cliente theme with a LOCKED text scaler.
///
/// Tests lock the scaler so goldens are stable; the app in production never
/// locks it (widgets follow the system textScaler).
Widget looviHarness(Widget child, {double textScale = 1.0, double width = 390}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: LooviTheme.light(),
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    ),
  );
}

Future<void> pumpLoovi(WidgetTester tester, Widget child, {double textScale = 1.0}) async {
  await tester.pumpWidget(looviHarness(child, textScale: textScale));
  await tester.pumpAndSettle();
}

/// Call once per golden test file (`setUpAll(loadGoldenFonts)`): loads Poppins.
Future<void> loadGoldenFonts() => loadLooviFonts();

/// Golden surface: 390 logical px wide, white canvas, DPR 1.
Future<void> pumpGolden(WidgetTester tester, Widget child, {double height = 200}) async {
  tester.view.physicalSize = Size(390, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(looviHarness(RepaintBoundary(child: child)));
  await tester.pumpAndSettle();
}
