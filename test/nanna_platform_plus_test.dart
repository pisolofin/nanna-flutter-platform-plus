import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanna_platform_plus/nanna_platform_plus.dart';
import 'package:flutter/cupertino.dart' show CupertinoTimerPicker;
import 'package:flutter/material.dart' show Card, ListWheelScrollView;

void main() {
  test('NannaPlatformPlus registers UI types and initializes successfully', () {
    NannaPlatformPlus.initialize();

    expect(NaUiTypePlus.versioned, isNotNull);
    expect(NaUiTypePlus.cupertinoVersioned, isNotNull);
    expect(NaUiTypePlus.materialVersioned, isNotNull);
  });

  test('PlatformVersionController switches families and versions', () {
    final PlatformVersionController controller = PlatformVersionController.instance;

    controller.setPlatformFamily(PlatformFamily.iOS, PlatformVersion.ios26);
    expect(controller.currentFamily, PlatformFamily.iOS);
    expect(controller.currentVersion, PlatformVersion.ios26);
    expect(controller.isLiquidGlass, isTrue);

    controller.setPlatformFamily(PlatformFamily.android, PlatformVersion.androidMaterialYou);
    expect(controller.currentFamily, PlatformFamily.android);
    expect(controller.currentVersion, PlatformVersion.androidMaterialYou);
    expect(controller.isAndroidMaterial, isTrue);
    expect(controller.isLiquidGlass, isFalse);
  });

  testWidgets('NaCard respects padding and NaCardOptionsGeneric in versioned mode', (WidgetTester tester) async {
    NannaPlatformPlus.initialize();
    PlatformVersionController.instance.setPlatformFamily(
      PlatformFamily.android,
      PlatformVersion.androidMaterialYou,
    );

    const EdgeInsets customMargin  = EdgeInsets.all(12.0);
    const EdgeInsets customPadding = EdgeInsets.all(20.0);
    const Color customColor        = Color(0xFF112233);

    await tester.pumpWidget(
      NaApp(
        uiTypes: [NaUiTypePlus.versioned, NaUiType.material],
        home   : NaScaffold(
          body: NaCard(
            padding: customPadding,
            options: NaCardOptionsGeneric(
              margin      : customMargin,
              color       : customColor,
              borderRadius: BorderRadius.circular(8.0),
              borderColor : const Color(0xFF445566),
              borderWidth : 2.0,
            ),
            child: const Text('Card body'),
          ),
        ),
      ),
    );

    final Card card = tester.widget<Card>(find.byType(Card));
    expect(card.margin, customMargin);
    expect(card.color, customColor);

    final Padding innerPadding = tester.widget<Padding>(
      find.ancestor(of: find.text('Card body'), matching: find.byType(Padding)).first,
    );
    expect(innerPadding.padding, customPadding);
  });

  testWidgets('NaSearchBar preserves custom leading on iOS', (WidgetTester tester) async {
    NannaPlatformPlus.initialize();
    PlatformVersionController.instance.setPlatformFamily(
      PlatformFamily.iOS,
      PlatformVersion.ios18,
    );

    const Key leadingKey = Key('custom-leading');

    await tester.pumpWidget(
      NaApp(
        uiTypes: [NaUiTypePlus.versioned, NaUiType.cupertino],
        home   : const NaScaffold(
          body: NaSearchBar(
            leading: SizedBox(key: leadingKey, width: 16, height: 16),
          ),
        ),
      ),
    );

    expect(find.byKey(leadingKey), findsOneWidget);
  });

  testWidgets('NaTimePicker uses Material wheel picker on Android and CupertinoTimerPicker on iOS', (WidgetTester tester) async {
    NannaPlatformPlus.initialize();
    PlatformVersionController.instance.setPlatformFamily(
      PlatformFamily.android,
      PlatformVersion.androidMaterialYou,
    );

    await tester.pumpWidget(
      NaApp(
        uiTypes: [NaUiTypePlus.versioned, NaUiType.material],
        home   : NaScaffold(
          body: NaTimePicker(
            initialTimerDuration  : const Duration(minutes: 5),
            onTimerDurationChanged: (Duration duration) {},
          ),
        ),
      ),
    );

    expect(find.byType(ListWheelScrollView), findsWidgets);
    expect(find.byType(CupertinoTimerPicker), findsNothing);

    PlatformVersionController.instance.setPlatformFamily(
      PlatformFamily.iOS,
      PlatformVersion.ios18,
    );

    await tester.pumpWidget(
      NaApp(
        uiTypes: [NaUiTypePlus.versioned, NaUiType.cupertino],
        home   : NaScaffold(
          body: NaTimePicker(
            initialTimerDuration  : const Duration(minutes: 5),
            onTimerDurationChanged: (Duration duration) {},
          ),
        ),
      ),
    );

    expect(find.byType(CupertinoTimerPicker), findsOneWidget);
  });
}
