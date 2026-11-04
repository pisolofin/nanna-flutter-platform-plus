# nanna_platform_plus

An OS-version-aware extension package for [`nanna_platform`](https://pub.dev/packages/nanna_platform) that brings adaptive, version-specific design system rendering to Flutter applications.

---

## Overview

While `nanna_platform` unifies cross-platform Flutter development by abstracting widgets into standard Material and Cupertino equivalents, operating systems evolve significantly over time:

* **iOS and iPadOS** evolve between versions (e.g., iOS 15 translucent navigation bars, iOS 16/17 typography and control refinements, iOS 18 floating navigation, and iOS 26/27 with the **Liquid Glass** aesthetic and revamped fluid controls).
* **Android** spans multiple design generations, from Material 2 to Material 3, including **Material You** (dynamic colors generated from the user's wallpaper on Android 12+ / API 31+).
* **macOS** introduces desktop-specific Human Interface Guidelines (Monterey, Ventura, Sonoma, Sequoia, macOS 26 Tahoe, and macOS 27 Golden Gate) that differ from mobile touch interfaces.

`nanna_platform_plus` builds on top of `nanna_platform` by introducing version-aware UI types (`NaUiTypePlus.cupertinoVersioned`, `NaUiTypePlus.materialVersioned`) and dynamic widget builders that automatically adapt your UI to match the exact OS version running on the device.

---

## Features

* 🍏 **Cupertino Versioning:** Automatically adapts Cupertino widgets (`NaAppBar`, `NaBottomNavigationBar`, `NaButton`, `NaSwitch`, etc.) to the visual guidelines and ergonomics of specific iOS releases (iOS 15, 16, 17, 18, 26, 27+).
* 🤖 **Material & Material You Adaptation:** Supports dynamic wallpaper color extraction (`dynamic_color`) on Android 12+ (API 31+), with graceful fallback to standard Material 3 or Material 2 on older releases.
* 🖥️ **macOS Desktop Polish:** Tailors desktop components to match macOS design conventions rather than generic mobile interfaces.
* 🔌 **Zero-Friction Integration:** Works seamlessly with existing `nanna_platform` widgets without requiring custom conditional blocks (`if (osVersion >= 17)`) scattered across your UI screens.
* 🛡️ **Graceful Fallbacks:** If a specific OS-version specialization is not defined for a widget, it automatically falls back to standard `nanna_platform` Material or Cupertino builders.

---

## Architecture

`nanna_platform_plus` leverages the modular builder and plugin architecture of `nanna_platform`:

1. **Custom `NaUiType` Registration:** Registers `NaUiTypePlus.cupertinoVersioned` and `NaUiTypePlus.materialVersioned` using `naPlatformServiceRegisterUiType`.
2. **OS Detection:** Uses device capabilities and runtime OS version inspection (e.g. via `device_info_plus`) to determine the active platform release.
3. **Dynamic Widget Builders:** Registers specialized builders via `naPlatformServiceRegisterWidgetBuilder` to render widgets with version-specific metrics, paddings, materials, and decorations.

---

## Getting Started

### 1. Add Dependencies

In your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  nanna_platform: ^1.2.2
  nanna_platform_plus:
    path: ../nanna-flutter-platform-plus # or version from pub.dev
```

### 2. Initialization

Initialize the version detection and widget builders during your application startup:

```dart
import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:nanna_platform_plus/nanna_platform_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Detects OS version and registers versioned widget builders
  await NannaPlatformPlus.initializeAsync();

  runApp(const MyApp());
}
```

---

## Usage

### Automatic Adaptive UI by Platform Version

Wrap your app or screens in `NaUiTypeScope` using the versioned types:

```dart
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:nanna_platform_plus/nanna_platform_plus.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically pick the versioned type for the current platform
    final NaUiType activeUiType = Platform.isIOS || Platform.isMacOS
      ? NaUiTypePlus.cupertinoVersioned
      : NaUiTypePlus.materialVersioned
    ;

    return NaUiTypeScope(
      uiTypes: [
        activeUiType,
        NaUiType.cupertino,
        NaUiType.material,
      ],
      child: NaApp(
        home: const HomePage(),
      ),
    );
  }
}
```

### Material You (Dynamic Wallpaper Theming)

On Android 12+ (API 31+), `nanna_platform_plus` can harmonize your color schemes with the system wallpaper:

```dart
DynamicColorBuilder(
  builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    return NaApp(
      optionsBuilder: (uiType) {
        if (uiType == NaUiTypePlus.materialVersioned) {
          return NaAppOptionsMaterial(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkDynamic ?? ColorScheme.fromSeed(
                seedColor: const Color(0xFF2196F3),
                brightness: Brightness.dark,
              ),
            ),
          );
        }
        return NaAppOptionsGeneric();
      },
      home: const HomePage(),
    );
  },
);
```

---

## Compatibility

| Platform | Target OS Versions Supported |
| :--- | :--- |
| **iOS / iPadOS** | iOS 15, iOS 16, iOS 17, iOS 18, iOS 26, iOS 27+ |
| **Android** | Material 2 (API < 31), Material 3 / Material You (API 31+) |
| **macOS** | macOS 12 (Monterey), 13 (Ventura), 14 (Sonoma), 15 (Sequoia), macOS 26 (Tahoe), macOS 27+ (Golden Gate) |

---

## Contributing & License

Contributions and suggestions are welcome! Feel free to open issues or pull requests.
This project is licensed under the MIT License.
