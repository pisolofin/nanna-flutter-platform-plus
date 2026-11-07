import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform_plus/nanna_platform_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes OS-version-aware types and widget builders
  NannaPlatformPlus.initialize();

  runApp(const PlatformPlusExampleApp());
}

class PlatformPlusExampleApp extends StatefulWidget {
  const PlatformPlusExampleApp({ super.key });

  @override
  State<PlatformPlusExampleApp> createState() => _PlatformPlusExampleAppState();
}

class _PlatformPlusExampleAppState extends State<PlatformPlusExampleApp> {
  final PlatformVersionController _controller = PlatformVersionController.instance;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onVersionChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVersionChanged);
    super.dispose();
  }

  void _onVersionChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with NaUiTypeScope to activate version-aware builders
    return NaUiTypeScope(
      uiTypes: [
        NaUiTypePlus.versioned,
        _controller.isAndroidMaterial ? NaUiType.material : NaUiType.cupertino,
      ],
      child: NaApp(
        title                     : 'Nanna Platform Plus Demo',
        debugShowCheckedModeBanner: false,
        optionsBuilder            : (BuildContext context, NaUiType uiType) {
          if (_controller.isAndroidMaterial) {
            return NaAppOptionsMaterial(
              theme: ThemeData(
                useMaterial3: _controller.currentVersion != PlatformVersion.androidM2,
                colorScheme : _controller.currentVersion == PlatformVersion.androidMaterialYou
                    ? ColorScheme.fromSeed(
                        seedColor : const Color(0xFF006495),
                        brightness: Brightness.light,
                      )
                    : ColorScheme.fromSeed(
                        seedColor : const Color(0xFF6750A4),
                        brightness: Brightness.light,
                      ),
              ),
            );
          }

          return NaAppOptionsCupertino(
            theme: const CupertinoThemeData(
              brightness  : Brightness.light,
              primaryColor: CupertinoColors.activeBlue,
            ),
          );
        },
        home: const ExampleShowcasePage(),
      ),
    );
  }
}

class ExampleShowcasePage extends StatefulWidget {
  const ExampleShowcasePage({ super.key });

  @override
  State<ExampleShowcasePage> createState() => _ExampleShowcasePageState();
}

class _ExampleShowcasePageState extends State<ExampleShowcasePage> {
  final PlatformVersionController _controller = PlatformVersionController.instance;

  int _currentNavIndex = 0;
  bool _switchValue    = true;
  int _clickCount      = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onVersionChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVersionChanged);
    super.dispose();
  }

  void _onVersionChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlatformFamily currentFamily            = _controller.currentFamily;
    final PlatformVersion currentVersion          = _controller.currentVersion;
    final List<PlatformVersion> availableVersions =
        PlatformVersion.forFamily(currentFamily);

    return NaScaffold(
      appBar: NaAppBar(
        title: Text(
          '${currentFamily.label} • ${currentVersion.displayName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Material(
          type : MaterialType.transparency,
          child: SingleChildScrollView(
            padding           : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child             : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children          : [
              // 1. Platform Selector (iOS / macOS / iPadOS / Android)
              _buildSectionHeader(
                icon    : Icons.devices,
                title   : '1. Seleziona Piattaforma',
                subtitle: 'Scegli la famiglia di sistema operativo',
              ),
              const SizedBox(height: 8),
              _buildPlatformSelector(currentFamily),

              const SizedBox(height: 18),

              // 2. Version Selector
              _buildSectionHeader(
                icon    : Icons.history,
                title   : '2. Seleziona Versione OS',
                subtitle: 'Evoluzione delle linee guida e del design system',
              ),
              const SizedBox(height: 8),
              _buildVersionSelector(availableVersions, currentVersion),

              const SizedBox(height: 22),

              // 3. Live Preview Card
              _buildShowcaseCard(currentVersion),

              const SizedBox(height: 16),

              // 4. Specs & Design Language Details
              _buildSpecsCard(currentVersion),

              const SizedBox(height: 80), // bottom margin for floating bars
            ],
          ),
        ),
      ),
    ),
      bottomNavigationBar: NaBottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap       : (int index) {
          setState(() => _currentNavIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon      : Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label     : 'Home',
          ),
          BottomNavigationBarItem(
            icon      : Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label     : 'Esplora',
          ),
          BottomNavigationBarItem(
            icon      : Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label     : 'Profilo',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children          : [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF007AFF)),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize  : 15,
                fontWeight: FontWeight.w700,
                color     : Color(0xFF1C1C1E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
        ),
      ],
    );
  }

  Widget _buildPlatformSelector(PlatformFamily selectedFamily) {
    return Wrap(
      spacing   : 8,
      runSpacing: 8,
      children  : PlatformFamily.values.map((family) {
        final isSelected = family == selectedFamily;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap   : () {
            setState(() {
              _controller.setPlatformFamily(family);
            });
          },
          child: AnimatedContainer(
            duration  : const Duration(milliseconds: 180),
            padding   : const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(12),
              boxShadow   : isSelected
                  ? [
                      BoxShadow(
                        color     : const Color(0xFF007AFF).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset    : const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children    : [
                Icon(
                  _getPlatformIcon(family),
                  size : 16,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                const SizedBox(width: 6),
                Text(
                  family.label,
                  style: TextStyle(
                    color     : isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize  : 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVersionSelector(
    List<PlatformVersion> versions,
    PlatformVersion selectedVersion,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child          : Row(
        children: versions.map((version) {
          final isSelected    = version == selectedVersion;
          final isLiquidGlass = version.designLanguage.contains('Liquid Glass');

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child  : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap   : () {
                setState(() {
                  _controller.setPlatformVersion(version);
                });
              },
              child: AnimatedContainer(
                duration  : const Duration(milliseconds: 180),
                padding   : const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isLiquidGlass
                          ? const Color(0xFF0A84FF)
                          : const Color(0xFF1D1D1F))
                      : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(10),
                  border      : Border.all(
                    color: isLiquidGlass && !isSelected
                        ? const Color(0xFF0A84FF).withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.05),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: isLiquidGlass
                                ? const Color(0xFF0A84FF).withValues(alpha: 0.35)
                                : Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset    : const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children    : [
                    if (isLiquidGlass) ...[
                      const Text('✨ ', style: TextStyle(fontSize: 12)),
                    ],
                    Text(
                      version.codename != null
                          ? '${version.displayName} (${version.codename})'
                          : version.displayName,
                      style: TextStyle(
                        color     : isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShowcaseCard(PlatformVersion version) {
    final bool isLiquidGlass = version.designLanguage.contains('Liquid Glass');

    return Container(
      padding   : const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color       : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border      : Border.all(
          color: isLiquidGlass
              ? const Color(0xFF0A84FF).withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.08),
          width: isLiquidGlass ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isLiquidGlass
                ? const Color(0xFF0A84FF).withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset    : const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children          : [
          // Header Badge
          Container(
            padding   : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isLiquidGlass
                  ? const Color(0xFF0A84FF).withValues(alpha: 0.12)
                  : const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children    : [
                Icon(
                  isLiquidGlass ? Icons.auto_awesome : Icons.palette_outlined,
                  size : 14,
                  color: isLiquidGlass
                      ? const Color(0xFF0A84FF)
                      : Colors.black87,
                ),
                const SizedBox(width: 6),
                Text(
                  version.designLanguage,
                  style: TextStyle(
                    fontSize  : 12,
                    fontWeight: FontWeight.w600,
                    color     : isLiquidGlass
                        ? const Color(0xFF0A84FF)
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Component 1: NaButton (Pulsante adattivo)
          const Text(
            'Pulsante Adattivo (NaButton)',
            style: TextStyle(
              fontSize  : 13,
              fontWeight: FontWeight.w600,
              color     : Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 10),

          NaButton(
            onPressed: () {
              setState(() => _clickCount++);
            },
            child: Text('Conferma Azione ($_clickCount)'),
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFE5E5EA)),
          const SizedBox(height: 20),

          // Component 2: NaSwitch (Check di selezione / Toggle)
          const Text(
            'Controllo Switch (NaSwitch)',
            style: TextStyle(
              fontSize  : 13,
              fontWeight: FontWeight.w600,
              color     : Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children         : [
              Text(
                _switchValue ? 'Attivo' : 'Disattivato',
                style: const TextStyle(
                  fontSize  : 14,
                  fontWeight: FontWeight.w500,
                  color     : Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(width: 14),
              NaSwitch(
                value    : _switchValue,
                onChanged: (val) => setState(() => _switchValue = val),
              ),
            ],
          ),

          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27) ...[
            const SizedBox(height: 10),
            Container(
              padding   : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color       : const Color(0xFF34C759).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '✨ Levetta allungata a capsula (Liquid Glass)',
                style: TextStyle(
                  fontSize  : 11,
                  fontWeight: FontWeight.w500,
                  color     : Color(0xFF248A3D),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFE5E5EA)),
          const SizedBox(height: 20),

          // Component 3: NaTextField & NaCard
          const Text(
            'Campi Testo e Card (NaCard & NaTextField)',
            style: TextStyle(
              fontSize  : 13,
              fontWeight: FontWeight.w600,
              color     : Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 12),

          NaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children          : [
                Row(
                  children: [
                    NaCheckbox(
                      value    : _switchValue,
                      onChanged: (val) =>
                          setState(() => _switchValue = val ?? false),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Checkbox con stile adattivo (NaCheckbox)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                NaTextField(
                  optionsBuilder: (context, uiType) =>
                      NaTextFieldOptionsGeneric(
                    placeholder: 'Inserisci un testo adattivo...',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsCard(PlatformVersion version) {
    return Container(
      padding   : const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color       : const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(16),
        border      : Border.all(color: const Color(0xFFE5E5EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children          : [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Color(0xFF8E8E93)),
              const SizedBox(width: 6),
              Text(
                'Specifiche Tecniche • ${version.displayName}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize  : 13,
                  color     : Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSpecRow('Anno di rilascio', '${version.releaseYear}'),
          _buildSpecRow('Design Language', version.designLanguage),
          _buildSpecRow('Caratteristiche', version.highlights),
          _buildSpecRow(
            'Barra di Navigazione',
            version.designLanguage.contains('Liquid Glass')
                ? 'Dock flottante in vetro traslucido'
                : (version.family == PlatformFamily.android
                    ? 'NavigationBar con pill container'
                    : (version.family == PlatformFamily.macOS
                        ? 'Desktop Toolbar / Segmented Bar'
                        : (version == PlatformVersion.ipados18
                            ? 'Floating Pill Tab Bar tablet'
                            : (version == PlatformVersion.ios18
                                ? 'Floating Tab Bar con angoli arrotondati'
                                : 'Standard Tab Bar con effetto blur')))),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child  : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children          : [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize  : 12,
                fontWeight: FontWeight.w500,
                color     : Color(0xFF1C1C1E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon(PlatformFamily family) {
    switch (family) {
      case PlatformFamily.iOS:
        return Icons.phone_iphone;
      case PlatformFamily.macOS:
        return Icons.laptop_mac;
      case PlatformFamily.iPadOS:
        return Icons.tablet_mac;
      case PlatformFamily.android:
        return Icons.android;
    }
  }
}
