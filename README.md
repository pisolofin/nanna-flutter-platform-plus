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

## Tabella Widget Adattati e Versioning OS

La seguente tabella riporta tutti i widget supportati da `nanna_platform`, lo stato dell'adattamento in `nanna_platform_plus` e le specifiche variazioni grafiche e di comportamento introdotte per ciascuna versione di sistema operativo:

| Widget | Categoria | Builder Plus | Versioni OS Specializzate | Variazioni della resa grafica |
| :--- | :--- | :---: | :--- | :--- |
| **`NaButton`** | Azioni | ✅ Sì | **iOS 26/27**, **iOS 18**, **iOS 15–17**, **macOS 26/27**, **macOS 12–15**, **Android M2/M3/You** | • **iOS 26/27:** Glassmorphism con `BackdropFilter` (sfocatura 20px), contorno iridescente semi-trasparente, forma a capsula e glow al tocco.<br>• **iOS 18:** Raggio 16px e padding reattivo.<br>• **iOS 15–17:** Raggio classico 10px e stile Cupertino.<br>• **macOS 26/27:** Bottone desktop in vetro acrilico.<br>• **macOS 12–15:** Push button con bordo compatto e gradiente 5px.<br>• **Android:** Box shadow e angoli a 4px (M2), Pill container 20px (M3), forma squircle con palette dinamica (Material You). |
| **`NaButtonFilled`** | Azioni | ✅ Sì | **iOS 26/27**, **macOS 26/27**, **macOS 12–15**, **Android M2/M3/You** | • **iOS 26/27:** Bottone primario pieno in vetro sfumato azzurro/blu con bordo semi-trasparente e riflesso speculare.<br>• **macOS 26/27:** Bottone primario desktop Liquid Glass.<br>• **Android:** Tonal primary container (M3/You) vs ElevatedButton elevato a 4px con testo uppercase (M2). |
| **`NaIconButton`** | Azioni | ✅ Sì | **iOS 26/27**, **macOS 26/27**, **macOS 12–15**, **Android M3/You** | • **iOS 26/27:** Cerchio flottante in vetro smerigliato translucido con bordo bianco semitrasparente.<br>• **macOS 26/27:** Icon button compatto desktop con cornice acrilica.<br>• **Android:** `IconButton.filledTonal` (M3/You) con ripple circolare. |
| **`NaAppBar`** | Navigazione | ✅ Sì | **iOS 26/27**, **iOS 15–18**, **macOS**, **Android M2/M3/You** | • **iOS 26/27:** Barra superiore Liquid Glass con `BackdropFilter` a tutta larghezza e titolo centrato nitido.<br>• **macOS:** Titlebar desktop con controlli compatti unificati.<br>• **Android:** Surface container senza elevazione e titolo centrato (M3/You) vs barra rigida con ombra a 4dp (M2). |
| **`NaBottomNavigationBar`** | Navigazione | ✅ Sì | **iOS 26/27**, **iOS 18**, **iOS 15–17**, **macOS 26/27**, **macOS 12–15**, **Android M2/M3/You** | • **iOS 26/27:** **Dock flottante** sollevato dal fondo (`margin: 20px`, raggio 32px), sfocatura 28px, capsula di selezione attiva illuminata.<br>• **iOS 18:** Barra tab flottante con angoli smussati.<br>• **iOS 15–17:** `CupertinoTabBar` classica a tutta larghezza con divisorio a filo.<br>• **macOS 26/27:** Barra toolbar desktop flottante translucida.<br>• **macOS 12–15:** Segmented tab bar stile finestra desktop.<br>• **Android M3/You:** `NavigationBar` da 80px con indicatore pillola orizzontale.<br>• **Android M2:** Barra fissa da 56px con elevazione 8dp. |
| **`NaSwitch`** | Selezione | ✅ Sì | **iOS 26/27**, **iOS 15–18**, **macOS 26/27**, **Android M2/M3/You** | • **iOS 26/27:** **Levetta a capsula allungata (pill thumb)** con traccia verde fluida e scorrimento elastico.<br>• **iOS 15–18:** Tradizionale levetta circolare Cupertino.<br>• **macOS:** Levetta ridotta in scala (0.85x) per desktop.<br>• **Android M3/You:** Switch con levetta ingrandita che si espande allo stato attivo.<br>• **Android M2:** Switch compatto con traccia rettilinea. |
| **`NaCheckbox`** | Selezione | ✅ Sì | **iOS 26/27**, **iOS 15–18**, **Android M2/M3/You** | • **iOS 26/27:** Squircle con bordo vitreo traslucido, glow azzurro e animazione di check fluida.<br>• **iOS 15–18:** `CupertinoCheckbox` circolare standard.<br>• **Android M3/You:** Checkbox con angoli a 4px e tinta dinamica.<br>• **Android M2:** Checkbox quadrato classico a spigoli vivi. |
| **`NaRadio`** | Selezione | ✅ Sì | **iOS 26/27**, **macOS 26/27**, **macOS 12–15**, **Android M2/M3/You** | • **iOS 26/27:** Cerchio in vetro acrilico con alone glow neon e pallino centrale (inner dot) che si espande con transizione fluida.<br>• **macOS:** Controllo compatto scalato a 16px desktop.<br>• **Android M2:** Colore storico viola `#6200EE`.<br>• **Android M3/You:** Tinta armonica del tema e splash ripple. |
| **`NaSlider`** | Selezione | ✅ Sì | **iOS 26/27**, **Android M2/M3/You** | • **iOS 26/27:** Traccia azzurro ciano vibrante con thumb luminescente.<br>• **Android M3/You:** Traccia più spessa e maniglia a pillola M3.<br>• **Android M2:** Traccia sottile con thumb circolare standard. |
| **`NaCard`** | Contenitori | ✅ Sì | **iOS 26/27**, **iOS 18**, **iOS 15–17**, **macOS 26/27**, **macOS 12–15**, **Android M2/M3/You** | • **iOS 26/27:** Card in vetro smerigliato (blur a 22px), riflesso gradiente e bordo bianco semitrasparente a 24px.<br>• **iOS 18:** Card raggruppata con angoli a 16px.<br>• **iOS 15–17:** Card raggruppata classica con angoli a 12px.<br>• **macOS 26/27:** Pannello desktop Liquid Glass con contorno sottile.<br>• **Android:** Superficie tonale 16px (M3), raggio 24px con tonalità wallpaper (Material You), Card elevata 4px (M2). |
| **`NaListTile`** | Liste | ✅ Sì | **iOS 26/27**, **iOS 15–18**, **Android M2/M3/You** | • **iOS 26/27:** Tile racchiuso in card di vetro translucido con angoli a 16px e chevron integrato.<br>• **iOS 15–18:** `CupertinoListTile` con separatore nativo.<br>• **Android M3/You:** Tile con bordo arrotondato a 12px e sfondo tonale. |
| **`NaTextField`** | Input | ✅ Sì | **iOS 26/27**, **iOS 18**, **iOS 15–17**, **macOS**, **Android M2/M3/You** | • **iOS 26/27:** Campo di testo su contenitore in vetro con sfocatura 18px e bordo luminoso a 16px.<br>• **iOS 18:** Sfondo `tertiarySystemFill` con raggio a 14px.<br>• **iOS 15–17:** `CupertinoTextField` standard (8px).<br>• **macOS:** Campo compatto da 6px desktop.<br>• **Android:** OutlineInputBorder da 24px (Material You), 16px (M3), o 4px a spigolo (M2). |
| **`NaSearchBar`** | Input | ✅ Sì | **iOS 26/27**, **iOS 18**, **macOS**, **Android M2/M3/You** | • **iOS 26/27:** Barra di ricerca a capsula trasparente in vetro con filtro sfocatura a 18px e bordo vitreo.<br>• **iOS 18:** Barra a raggio 16px.<br>• **Android M3/You:** `SearchBar` priva di ombra rigida con sfondo surface container colorato. |
| **`NaProgressIndicator`** | Feedback | ✅ Sì | **iOS 26/27**, **Android M2/M3/You** | • **iOS 26/27:** `CupertinoActivityIndicator` ad alta visibilità con raggio maggiorato a 12px.<br>• **iOS 15–18:** `CupertinoActivityIndicator` standard da 10px.<br>• **Android M2:** Spessore e colore `#6200EE`.<br>• **Android M3/You:** Indicatore circolare con colori dinamici del tema. |
| **`NaAlertDialog`** | Dialoghi | ✅ Sì | **iOS 26/27**, **Android M2/M3/You** | • **iOS 26/27:** Finestra di dialogo immersiva con sfondo a sfocatura profonda (25px).<br>• **Android M3/You:** Dialogo con angoli smussati a 20–28px.<br>• **Android M2:** Dialogo con angoli squadrati a 4px. |
| **`NaDialogAction`** | Dialoghi | ✅ Sì | **iOS 26/27**, **Android** | • **iOS:** `CupertinoDialogAction` (supporta azioni distruttive e predefinite).<br>• **Android:** `TextButton` piatto allineato al tema Material. |
| **`NaScaffold`** | Struttura | ✅ Sì | **iOS 26/27**, **iOS 15–18**, **Android** | • **iOS 26/27:** Sfondo tenue coordinato (`#F0F4F8`) con impilamento e ancoraggio automatico della barra di navigazione flottante.<br>• **Android:** `Scaffold` nativo Material. |
| **`NaScrollbar`** | Struttura | ✅ Sì | **iOS / macOS**, **Android** | • Gestione del cursore nativo: `CupertinoScrollbar` per l'ecosistema Apple e `Scrollbar` per Android. |
| **`NaDatePicker`** | Selezione | ✅ Sì | **iOS 26/27**, **iOS 15–18**, **Android** | • **iOS 26/27:** Ruota calendario in contenitore trasparente con sfocatura 16px e angoli a 20px.<br>• **Android:** `CalendarDatePicker` Material 3 / Material 2. |
| **`NaTimePicker`** | Selezione | ✅ Sì | **iOS 26/27**, **iOS 15–18**, **Android** | • **iOS 26/27:** Selettore orario a tamburo incapsulato in vetro acrilico translucido.<br>• **Android:** Ruote numeriche orarie adattate. |
| **`NaIcon`** | Elementi | ✅ Sì | **iOS 26/27**, **Android** | • Risoluzione dei simboli nativi tramite `NaIconData` con accento ciano per iOS 26/27 e tonalità primaria per Android. |
| **`NaTextFieldTitle`** | Layout | 🔄 Native | *Tutte* | Layout wrapper: si adatta automaticamente allineandosi al padding e al raggio del `NaTextField` sottostante. |
| **`NaTextFieldCaption`** | Layout | 🔄 Native | *Tutte* | Layout wrapper: posiziona didascalie sopra o sotto il campo rispettando la scala tipografica della piattaforma. |

---

## Contributing & License

Contributions and suggestions are welcome! Feel free to open issues or pull requests.
This project is licensed under the MIT License.
