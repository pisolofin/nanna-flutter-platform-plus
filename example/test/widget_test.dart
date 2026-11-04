import 'package:flutter_test/flutter_test.dart';
import 'package:nanna_platform_plus/nanna_platform_plus.dart';
import 'package:nanna_platform_plus_example/main.dart';

void main() {
  setUp(() {
    NannaPlatformPlus.initialize();
  });

  testWidgets('PlatformPlusExampleApp builds and switches versions', (WidgetTester tester) async {
    await tester.pumpWidget(const PlatformPlusExampleApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('iOS'), findsWidgets);
    expect(find.textContaining('Conferma Azione'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    // Initial version is iOS 26
    expect(find.textContaining('iOS 26'), findsWidgets);

    // Tap on iOS 18 chip
    await tester.tap(find.text('iOS 18'));
    await tester.pumpAndSettle();

    // Now current version should be iOS 18
    expect(PlatformVersionController.instance.currentVersion, PlatformVersion.ios18);
    expect(find.textContaining('iOS 18'), findsWidgets);

    // Tap on Android platform chip
    await tester.tap(find.text('Android'));
    await tester.pumpAndSettle();

    expect(PlatformVersionController.instance.currentFamily, PlatformFamily.android);
  });
}
