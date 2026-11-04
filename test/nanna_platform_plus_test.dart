import 'package:flutter_test/flutter_test.dart';
import 'package:nanna_platform_plus/nanna_platform_plus.dart';

void main() {
  test('NannaPlatformPlus registers UI types and initializes successfully', () {
    NannaPlatformPlus.initialize();

    expect(NaUiTypePlus.versioned, isNotNull);
    expect(NaUiTypePlus.cupertinoVersioned, isNotNull);
    expect(NaUiTypePlus.materialVersioned, isNotNull);
  });

  test('PlatformVersionController switches families and versions', () {
    final controller = PlatformVersionController.instance;

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
}
