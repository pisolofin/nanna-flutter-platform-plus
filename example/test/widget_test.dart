import 'package:flutter_test/flutter_test.dart';
import 'package:nanna_platform_plus/nanna_platform_plus.dart';
import 'package:nanna_platform_plus_example/main.dart';

void main() {
  setUp(() {
    NannaPlatformPlus.initialize();
  });

  testWidgets('Test rendering across all platform families and versions', (WidgetTester tester) async {
    await tester.pumpWidget(const PlatformPlusExampleApp());
    await tester.pumpAndSettle();

    final controller = PlatformVersionController.instance;

    // Iterate through all platforms and versions to ensure no errors (like Material dependency missing)
    for (final family in PlatformFamily.values) {
      controller.setPlatformFamily(family);
      for (final version in PlatformVersion.forFamily(family)) {
        controller.setPlatformVersion(version);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    }
  });
}
