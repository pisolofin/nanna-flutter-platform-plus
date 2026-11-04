import 'package:nanna_platform/nanna_platform.dart';

/// Extension UI types introduced by `nanna_platform_plus`.
class NaUiTypePlus {
  static NaUiType? _versioned;
  static NaUiType? _cupertinoVersioned;
  static NaUiType? _materialVersioned;

  /// General version-aware UI type dynamically adapting to the active OS version.
  static NaUiType get versioned {
    registerUiTypes();
    return _versioned!;
  }

  /// Cupertino-specialized versioned UI type.
  static NaUiType get cupertinoVersioned {
    registerUiTypes();
    return _cupertinoVersioned!;
  }

  /// Material-specialized versioned UI type.
  static NaUiType get materialVersioned {
    registerUiTypes();
    return _materialVersioned!;
  }

  static bool _registered = false;

  /// Registers custom UI types with nanna_platform service.
  static void registerUiTypes() {
    if (_registered) {
      return;
    }

    _versioned = naPlatformServiceRegisterUiType(
      styleId: 'nanna_plus',
      uiType : 'versioned',
    );

    _cupertinoVersioned = naPlatformServiceRegisterUiType(
      styleId: 'nanna_plus',
      uiType : 'cupertino_versioned',
    );

    _materialVersioned = naPlatformServiceRegisterUiType(
      styleId: 'nanna_plus',
      uiType : 'material_versioned',
    );

    _registered = true;
  }
}
