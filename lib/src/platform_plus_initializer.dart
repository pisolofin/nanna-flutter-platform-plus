import 'package:nanna_platform/nanna_platform.dart';

import 'models/ui_type_plus.dart';
import 'widgets_plus/button_plus.dart';
import 'widgets_plus/bottom_navigation_bar_plus.dart';
import 'widgets_plus/switch_plus.dart';
import 'widgets_plus/app_bar_plus.dart';

/// Entrypoint to initialize `nanna_platform_plus` and register all versioned builders.
class NannaPlatformPlus {
  static bool _initialized = false;

  /// Registers OS-version-aware UI types and widget builders.
  static void initialize() {
    if (_initialized) return;

    NaUiTypePlus.registerUiTypes();

    final List<NaUiType> types = [
      NaUiTypePlus.versioned,
      NaUiTypePlus.cupertinoVersioned,
      NaUiTypePlus.materialVersioned,
    ];

    for (final NaUiType type in types) {
      registerNaButtonPlus(type);
      registerNaBottomNavigationBarPlus(type);
      registerNaSwitchPlus(type);
      registerNaAppBarPlus(type);
    }

    _initialized = true;
  }

  /// Async initialization helper for startup sequences.
  static Future<void> initializeAsync() async {
    initialize();
  }
}
