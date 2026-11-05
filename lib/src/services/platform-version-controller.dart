import 'package:flutter/foundation.dart';

import '../models/platform-target.dart';

/// Controller that manages the active platform and version for adaptive rendering.
class PlatformVersionController extends ChangeNotifier {
  static final PlatformVersionController _instance = PlatformVersionController._internal();

  /// Access the shared singleton instance.
  static PlatformVersionController get instance => _instance;

  PlatformVersionController._internal() {
    _currentFamily  = PlatformFamily.iOS;
    _currentVersion = PlatformVersion.ios26;
  }

  late PlatformFamily _currentFamily;
  late PlatformVersion _currentVersion;

  /// The active platform family (iOS, macOS, iPadOS, Android).
  PlatformFamily get currentFamily => _currentFamily;

  /// The active operating system version.
  PlatformVersion get currentVersion => _currentVersion;

  /// Sets the active platform family, automatically picking its recommended latest version.
  void setPlatformFamily(PlatformFamily family, [PlatformVersion? version]) {
    if ((_currentFamily == family) && (version == null)) {
      return;
    }
    _currentFamily                            = family;
    final List<PlatformVersion> availableList = PlatformVersion.forFamily(family);
    if ((version != null) && availableList.contains(version)) {
      _currentVersion = version;
    }else {
      _currentVersion = availableList.last;
    }
    notifyListeners();
  }

  /// Sets the specific operating system version.
  void setPlatformVersion(PlatformVersion version) {
    if (_currentVersion == version) {
      return;
    }
    _currentFamily  = version.family;
    _currentVersion = version;
    notifyListeners();
  }

  /// Helper to check if current version is iOS 26 or 27 with Liquid Glass design.
  bool get isLiquidGlass =>
      (_currentVersion == PlatformVersion.ios26) ||
      (_currentVersion == PlatformVersion.ios27) ||
      (_currentVersion == PlatformVersion.macos26) ||
      (_currentVersion == PlatformVersion.macos27) ||
      (_currentVersion == PlatformVersion.ipados26) ||
      (_currentVersion == PlatformVersion.ipados27);

  /// Helper to check if current version uses Material Design (Android).
  bool get isAndroidMaterial => (_currentFamily == PlatformFamily.android);
}
