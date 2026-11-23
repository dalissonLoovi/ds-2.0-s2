/// Test helpers for golden / widget tests (import only from `test/`).
library;

import 'dart:convert';

import 'package:flutter/services.dart';

/// Loads every font in the test bundle's FontManifest (including Poppins from
/// `loovi_tokens`) so goldens render real glyphs instead of the Ahem test font.
Future<void> loadLooviFonts() async {
  final manifest = json.decode(await rootBundle.loadString('FontManifest.json')) as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final family = entry['family'] as String;
    final loader = FontLoader(family);
    for (final font in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}
