/// Supported platform families for version-aware UI rendering.
enum PlatformFamily {
  iOS('iOS', 'Apple iOS'),
  macOS('macOS', 'Apple macOS'),
  iPadOS('iPadOS', 'Apple iPadOS'),
  android('Android', 'Google Android');

  final String label;
  final String description;

  const PlatformFamily(this.label, this.description);
}

/// Represents a specific operating system version and its design system.
class PlatformVersion {
  final String id;
  final String displayName;
  final String? codename;
  final int releaseYear;
  final PlatformFamily family;
  final String designLanguage;
  final String highlights;

  const PlatformVersion({
    required this.id,
    required this.displayName,
    this.codename,
    required this.releaseYear,
    required this.family,
    required this.designLanguage,
    required this.highlights,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformVersion &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$displayName ($designLanguage)';

  // Predefined versions

  // --- iOS ---
  static const PlatformVersion ios15 = PlatformVersion(
    id: 'ios_15',
    displayName: 'iOS 15',
    releaseYear: 2021,
    family: PlatformFamily.iOS,
    designLanguage: 'Cupertino Classic',
    highlights: 'Translucent navigation bars, rounded list tiles',
  );

  static const PlatformVersion ios16 = PlatformVersion(
    id: 'ios_16',
    displayName: 'iOS 16',
    releaseYear: 2022,
    family: PlatformFamily.iOS,
    designLanguage: 'Cupertino Refined',
    highlights: 'Lock screen depth & typography adjustments',
  );

  static const PlatformVersion ios17 = PlatformVersion(
    id: 'ios_17',
    displayName: 'iOS 17',
    releaseYear: 2023,
    family: PlatformFamily.iOS,
    designLanguage: 'Cupertino Dynamic',
    highlights: 'Interactive widgets, StandBy mode, refined controls',
  );

  static const PlatformVersion ios18 = PlatformVersion(
    id: 'ios_18',
    displayName: 'iOS 18',
    releaseYear: 2024,
    family: PlatformFamily.iOS,
    designLanguage: 'Cupertino Modern',
    highlights: 'Floating tab bar, tintable icons, responsive controls',
  );

  static const PlatformVersion ios26 = PlatformVersion(
    id: 'ios_26',
    displayName: 'iOS 26',
    releaseYear: 2025,
    family: PlatformFamily.iOS,
    designLanguage: 'Liquid Glass',
    highlights: 'Translucent glassmorphism, fluid morphing toggles & pill thumb',
  );

  static const PlatformVersion ios27 = PlatformVersion(
    id: 'ios_27',
    displayName: 'iOS 27',
    releaseYear: 2026,
    family: PlatformFamily.iOS,
    designLanguage: 'Liquid Glass+',
    highlights: 'Refined iridescent glass, Apple Intelligence contextual actions',
  );

  static const List<PlatformVersion> iosVersions = [
    ios15,
    ios16,
    ios17,
    ios18,
    ios26,
    ios27,
  ];

  // --- macOS ---
  static const PlatformVersion macos12 = PlatformVersion(
    id: 'macos_12',
    displayName: 'macOS 12',
    codename: 'Monterey',
    releaseYear: 2021,
    family: PlatformFamily.macOS,
    designLanguage: 'Desktop Aqua / Flat',
    highlights: 'Compact tab bars, Shortcuts for Mac, SharePlay',
  );

  static const PlatformVersion macos13 = PlatformVersion(
    id: 'macos_13',
    displayName: 'macOS 13',
    codename: 'Ventura',
    releaseYear: 2022,
    family: PlatformFamily.macOS,
    designLanguage: 'Stage Manager Style',
    highlights: 'Redesigned System Settings, Stage Manager',
  );

  static const PlatformVersion macos14 = PlatformVersion(
    id: 'macos_14',
    displayName: 'macOS 14',
    codename: 'Sonoma',
    releaseYear: 2023,
    family: PlatformFamily.macOS,
    designLanguage: 'Desktop Interactive',
    highlights: 'Interactive desktop widgets, presenter overlay',
  );

  static const PlatformVersion macos15 = PlatformVersion(
    id: 'macos_15',
    displayName: 'macOS 15',
    codename: 'Sequoia',
    releaseYear: 2024,
    family: PlatformFamily.macOS,
    designLanguage: 'Modern Desktop Sequoia',
    highlights: 'iPhone Mirroring, window tiling shortcuts',
  );

  static const PlatformVersion macos26 = PlatformVersion(
    id: 'macos_26',
    displayName: 'macOS 26',
    codename: 'Tahoe',
    releaseYear: 2025,
    family: PlatformFamily.macOS,
    designLanguage: 'Liquid Glass Desktop',
    highlights: 'Translucent menu bars, fluid floating toolbars, Phone app',
  );

  static const PlatformVersion macos27 = PlatformVersion(
    id: 'macos_27',
    displayName: 'macOS 27',
    codename: 'Golden Gate',
    releaseYear: 2026,
    family: PlatformFamily.macOS,
    designLanguage: 'Liquid Glass Pro',
    highlights: 'Pure Apple Silicon, adaptive dark mode, unified glass dock',
  );

  static const List<PlatformVersion> macosVersions = [
    macos12,
    macos13,
    macos14,
    macos15,
    macos26,
    macos27,
  ];

  // --- iPadOS ---
  static const PlatformVersion ipados15 = PlatformVersion(
    id: 'ipados_15',
    displayName: 'iPadOS 15',
    releaseYear: 2021,
    family: PlatformFamily.iPadOS,
    designLanguage: 'Cupertino Tablet',
    highlights: 'Widgets anywhere on home screen, App Library',
  );

  static const PlatformVersion ipados16 = PlatformVersion(
    id: 'ipados_16',
    displayName: 'iPadOS 16',
    releaseYear: 2022,
    family: PlatformFamily.iPadOS,
    designLanguage: 'Stage Manager Tablet',
    highlights: 'Multi-window Stage Manager, external display support',
  );

  static const PlatformVersion ipados17 = PlatformVersion(
    id: 'ipados_17',
    displayName: 'iPadOS 17',
    releaseYear: 2023,
    family: PlatformFamily.iPadOS,
    designLanguage: 'Cupertino Adaptive',
    highlights: 'Interactive widgets, customizable lock screen',
  );

  static const PlatformVersion ipados18 = PlatformVersion(
    id: 'ipados_18',
    displayName: 'iPadOS 18',
    releaseYear: 2024,
    family: PlatformFamily.iPadOS,
    designLanguage: 'Floating Tab Bar Tablet',
    highlights: 'Floating tab bar morphing into sidebar, redesigned Calculator',
  );

  static const PlatformVersion ipados26 = PlatformVersion(
    id: 'ipados_26',
    displayName: 'iPadOS 26',
    releaseYear: 2025,
    family: PlatformFamily.iPadOS,
    designLanguage: 'Liquid Glass Tablet',
    highlights: 'Glassmorphism sheets, fluid floating docks, responsive controls',
  );

  static const PlatformVersion ipados27 = PlatformVersion(
    id: 'ipados_27',
    displayName: 'iPadOS 27',
    releaseYear: 2026,
    family: PlatformFamily.iPadOS,
    designLanguage: 'Spatial Liquid Canvas',
    highlights: 'Contextual AI tools, multi-pane fluid glass surfaces',
  );

  static const List<PlatformVersion> ipadosVersions = [
    ipados15,
    ipados16,
    ipados17,
    ipados18,
    ipados26,
    ipados27,
  ];

  // --- Android ---
  static const PlatformVersion androidM2 = PlatformVersion(
    id: 'android_m2',
    displayName: 'Android (Material 2)',
    codename: 'API < 31 (Android 11-)',
    releaseYear: 2020,
    family: PlatformFamily.android,
    designLanguage: 'Material 2',
    highlights: 'Elevated surfaces, box shadows, 4px corner radius, bold FABs',
  );

  static const PlatformVersion androidM3 = PlatformVersion(
    id: 'android_m3',
    displayName: 'Android (Material 3)',
    codename: 'API 31-33 (Android 12/13)',
    releaseYear: 2022,
    family: PlatformFamily.android,
    designLanguage: 'Material 3',
    highlights: 'Tonal palettes, pill indicators, rounded corners (20px)',
  );

  static const PlatformVersion androidMaterialYou = PlatformVersion(
    id: 'android_material_you',
    displayName: 'Android (Material You)',
    codename: 'API 34+ (Android 14+)',
    releaseYear: 2024,
    family: PlatformFamily.android,
    designLanguage: 'Material You Dynamic',
    highlights: 'Dynamic wallpaper extraction, expressive shapes, haptic feedback',
  );

  static const List<PlatformVersion> androidVersions = [
    androidM2,
    androidM3,
    androidMaterialYou,
  ];

  /// Returns available versions for a given platform family.
  static List<PlatformVersion> forFamily(PlatformFamily family) {
    switch (family) {
      case PlatformFamily.iOS:
        return iosVersions;
      case PlatformFamily.macOS:
        return macosVersions;
      case PlatformFamily.iPadOS:
        return ipadosVersions;
      case PlatformFamily.android:
        return androidVersions;
    }
  }
}
