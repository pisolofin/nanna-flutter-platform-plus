import 'package:nanna_platform/nanna_platform.dart';

import 'models/ui-type-plus.dart';
import 'widgets-plus/na-card-plus.dart';
import 'widgets-plus/na-icon-plus.dart';
import 'widgets-plus/na-radio-plus.dart';
import 'widgets-plus/na-button-plus.dart';
import 'widgets-plus/na-dialog-plus.dart';
import 'widgets-plus/na-slider-plus.dart';
import 'widgets-plus/na-switch-plus.dart';
import 'widgets-plus/na-app-bar-plus.dart';
import 'widgets-plus/na-checkbox-plus.dart';
import 'widgets-plus/na-scaffold-plus.dart';
import 'widgets-plus/na-list-tile-plus.dart';
import 'widgets-plus/na-scrollbar-plus.dart';
import 'widgets-plus/na-search-bar-plus.dart';
import 'widgets-plus/na-text-field-plus.dart';
import 'widgets-plus/na-icon-button-plus.dart';
import 'widgets-plus/na-button-filled-plus.dart';
import 'widgets-plus/na-date-time-picker-plus.dart';
import 'widgets-plus/na-progress-indicator-plus.dart';
import 'widgets-plus/na-bottom-navigation-bar-plus.dart';

/// Entrypoint to initialize `nanna_platform_plus` and register all versioned builders.
class NannaPlatformPlus {
  static bool _initialized = false;

  /// Registers OS-version-aware UI types and widget builders for all nanna_platform components.
  static void initialize() {
    if (_initialized) {
      return;
    }

    NaUiTypePlus.registerUiTypes();

    final List<NaUiType> typeList = [
      NaUiTypePlus.versioned,
      NaUiTypePlus.cupertinoVersioned,
      NaUiTypePlus.materialVersioned,
    ];

    for (final NaUiType type in typeList) {
      registerNaAppBarPlus(type);
      registerNaBottomNavigationBarPlus(type);
      registerNaButtonPlus(type);
      registerNaButtonFilledPlus(type);
      registerNaIconButtonPlus(type);
      registerNaCardPlus(type);
      registerNaCheckboxPlus(type);
      registerNaRadioPlus(type);
      registerNaSwitchPlus(type);
      registerNaSliderPlus(type);
      registerNaProgressIndicatorPlus(type);
      registerNaListTilePlus(type);
      registerNaTextFieldPlus(type);
      registerNaSearchBarPlus(type);
      registerNaDialogPlus(type);
      registerNaScaffoldPlus(type);
      registerNaScrollbarPlus(type);
      registerNaDateTimePickerPlus(type);
      registerNaIconPlus(type);
    }

    _initialized = true;
  }

  /// Async initialization helper for startup sequences.
  static Future initializeAsync() async {
    initialize();
  }
}
