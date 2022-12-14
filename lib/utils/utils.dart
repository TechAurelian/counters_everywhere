// Copyright 2020-2022 TechAurelian. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

/// Formats [number] as a decimal, inserting locale-appropriate thousands separators as necessary.
String toDecimalString(BuildContext context, int number) {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  return localizations.formatDecimal(number);
}

/// Launches the specified [URL] in the mobile platform.
///
/// Shows an error [SnackBar] if there is no support for launching the URL.
Future<void> launchUrlExternal(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    debugPrint('Failed to open $url');
  }
}

/// Utility Color extension methods.
extension ColorX on Color {
  /// Returns the contrast color for this color.
  Color contrastOf() =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.light ? Colors.black : Colors.white;

  /// Creates a material color from any ARGB color value.
  MaterialColor createMaterialColor() {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = red, g = green, b = blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }

  /// Returns a random material shade.
  static Color? randomMaterialColor() {
    List<Color?> materialShades(MaterialColor mc) =>
        [50, 100, 200, 300, 400, 500, 600, 700, 800, 900].map((index) => mc[index]).toList();

    final Random random = Random();
    List<Color?> shades =
        Colors.primaries.map((color) => materialShades(color)).expand((color) => color).toList();
    return shades[random.nextInt(shades.length)];
  }
}
