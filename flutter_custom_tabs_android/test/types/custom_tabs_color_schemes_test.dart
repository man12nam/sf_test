import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsColorSchemes', () {
    test('toMessage() returns empty message when option values are null', () {
      const schemes = CustomTabsColorSchemes();
      final actual = schemes.toMessage();
      expect(actual.colorScheme, isNull);
      expect(actual.lightParams, isNull);
      expect(actual.darkParams, isNull);
      expect(actual.defaultPrams, isNull);
    });

    test('toMessage() returns a message with complete options', () {
      const schemes = CustomTabsColorSchemes(
        colorScheme: CustomTabsColorScheme.system,
        lightParams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFDBAA),
          navigationBarColor: Color(0xFFFFDBAB),
          navigationBarDividerColor: Color(0xFFFFDBAC),
        ),
        darkParams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFDBBA),
          navigationBarColor: Color(0xFFFFDBBB),
          navigationBarDividerColor: Color(0xFFFFDBBC),
        ),
        defaultPrams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFDBCA),
          navigationBarColor: Color(0xFFFFDBCB),
          navigationBarDividerColor: Color(0xFFFFDBCC),
        ),
      );

      final actual = schemes.toMessage();
      expect(actual.colorScheme, schemes.colorScheme!.rawValue);
      expect(actual.lightParams, isA<ColorSchemeParams>());
      expect(actual.darkParams, isA<ColorSchemeParams>());
      expect(actual.defaultPrams, isA<ColorSchemeParams>());

      final actualLightParams = actual.lightParams!;
      expect(actualLightParams.toolbarColor, 0xFFFFDBAA);
      expect(actualLightParams.navigationBarColor, 0xFFFFDBAB);
      expect(actualLightParams.navigationBarDividerColor, 0xFFFFDBAC);

      final actualDarkParams = actual.darkParams!;
      expect(actualDarkParams.toolbarColor, 0xFFFFDBBA);
      expect(actualDarkParams.navigationBarColor, 0xFFFFDBBB);
      expect(actualDarkParams.navigationBarDividerColor, 0xFFFFDBBC);

      final actualDefaultParams = actual.defaultPrams!;
      expect(actualDefaultParams.toolbarColor, 0xFFFFDBCA);
      expect(actualDefaultParams.navigationBarColor, 0xFFFFDBCB);
      expect(actualDefaultParams.navigationBarDividerColor, 0xFFFFDBCC);
    });
  });

  group('CustomTabsColorSchemeParams', () {
    test('toMessage() returns empty message when option values are null', () {
      const params = CustomTabsColorSchemeParams();
      final actual = params.toMessage();
      expect(actual.toolbarColor, null);
      expect(actual.navigationBarColor, null);
      expect(actual.navigationBarDividerColor, null);
    });

    test('toMessage() returns a message with complete options', () {
      const params = CustomTabsColorSchemeParams(
        toolbarColor: Color(0xFFFFCBAA),
        navigationBarColor: Color(0xFFFFCBAB),
        navigationBarDividerColor: Color(0xFFFFCBAC),
      );
      final actual = params.toMessage();
      expect(actual.toolbarColor, 0xFFFFCBAA);
      expect(actual.navigationBarColor, 0xFFFFCBAB);
      expect(actual.navigationBarDividerColor, 0xFFFFCBAC);
    });
  });

  group('CustomTabsColorScheme', () {
    test('returns associated value', () {
      expect(CustomTabsColorScheme.system.rawValue, 0);
      expect(CustomTabsColorScheme.light.rawValue, 1);
      expect(CustomTabsColorScheme.dark.rawValue, 2);
    });
  });

  group('BrightnessToColorScheme', () {
    test('toColorScheme() returns light color scheme', () {
      expect(Brightness.light.toColorScheme(), CustomTabsColorScheme.light);
    });

    test('toColorScheme() returns dark color scheme', () {
      expect(Brightness.dark.toColorScheme(), CustomTabsColorScheme.dark);
    });
  });
}
