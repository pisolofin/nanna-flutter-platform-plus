import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoTabBar;
import 'package:flutter/material.dart' show BottomNavigationBar, BottomNavigationBarType, NavigationBar, NavigationDestination, Theme;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaBottomNavigationBar].
void registerNaBottomNavigationBarPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaBottomNavigationBar>(
    uiType,
    (BuildContext context, NaBottomNavigationBar widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
          return _buildIosBottomBar(context, widget, version);
        case PlatformFamily.macOS:
          return _buildMacOsBottomBar(context, widget, version);
        case PlatformFamily.iPadOS:
          return _buildIpadosBottomBar(context, widget, version);
        case PlatformFamily.android:
          return _buildAndroidBottomBar(context, widget, version);
      }
    },
  );
}

Widget _buildIosBottomBar(
  BuildContext context,
  NaBottomNavigationBar widget,
  PlatformVersion version,
) {
  // iOS 26 & 27: Liquid Glass Floating Dock
  if ((version == PlatformVersion.ios26) || (version == PlatformVersion.ios27)) {
    return _LiquidGlassFloatingBar(
      items       : widget.items,
      currentIndex: widget.currentIndex,
      onTap       : widget.onTap,
      isNextGen   : version == PlatformVersion.ios27,
    );
  }

  // iOS 18: Modern floating tab bar with rounded frosted glass capsule
  if (version == PlatformVersion.ios18) {
    return SafeArea(
      top  : false,
      child: Container(
        margin    : const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        decoration: BoxDecoration(
          color       : CupertinoColors.systemBackground.resolveFrom(context).withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(24),
          boxShadow   : const [
            BoxShadow(
              color     : Color(0x1F000000),
              blurRadius: 16,
              offset    : Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child       : CupertinoTabBar(
            items          : widget.items,
            currentIndex   : widget.currentIndex,
            onTap          : widget.onTap,
            backgroundColor: const Color(0x00000000),
            border         : null,
            activeColor    : CupertinoColors.activeBlue,
          ),
        ),
      ),
    );
  }

  // iOS 15-17: Classic CupertinoTabBar attached to bottom
  return SafeArea(
    top  : false,
    child: CupertinoTabBar(
      items          : widget.items,
      currentIndex   : widget.currentIndex,
      onTap          : widget.onTap,
      backgroundColor: CupertinoColors.systemBackground
          .resolveFrom(context)
          .withValues(alpha: 0.8),
      border: const Border(
        top: BorderSide(
          color: CupertinoColors.separator,
          width: 0.0,
        ),
      ),
    ),
  );
}

Widget _buildMacOsBottomBar(
  BuildContext context,
  NaBottomNavigationBar widget,
  PlatformVersion version,
) {
  // macOS 26 & 27: Liquid Glass Desktop Toolbar Bar
  if ((version == PlatformVersion.macos26) || (version == PlatformVersion.macos27)) {
    return Container(
      padding   : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color : Color(0x73FFFFFF),
        border: Border(
          top: BorderSide(
            color: Color(0x99FFFFFF),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child       : BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children         : List.generate(widget.items.length, (index) {
              return _MacOsLiquidGlassItem(
                item      : widget.items[index],
                isSelected: index == widget.currentIndex,
                onTap     : () => widget.onTap?.call(index),
              );
            }),
          ),
        ),
      ),
    );
  }

  // macOS 12-15: Desktop segmented bottom bar without Material dependencies
  return Container(
    height    : 48,
    padding   : const EdgeInsets.symmetric(horizontal: 8),
    decoration: const BoxDecoration(
      color : Color(0xFFE5E5EA),
      border: Border(top: BorderSide(color: Color(0xFFC7C7CC), width: 0.5)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children         : List.generate(widget.items.length, (index) {
        return _MacOsSegmentedItem(
          item      : widget.items[index],
          isSelected: index == widget.currentIndex,
          onTap     : () => widget.onTap?.call(index),
        );
      }),
    ),
  );
}

Widget _buildIpadosBottomBar(
  BuildContext context,
  NaBottomNavigationBar widget,
  PlatformVersion version,
) {
  // iPadOS 26 & 27: Liquid Glass Floating Tablet Dock
  if ((version == PlatformVersion.ipados26) || (version == PlatformVersion.ipados27)) {
    return _LiquidGlassFloatingBar(
      items       : widget.items,
      currentIndex: widget.currentIndex,
      onTap       : widget.onTap,
      isNextGen   : version == PlatformVersion.ipados27,
      isTablet    : true,
    );
  }

  // iPadOS 18: Modern tablet floating pill tab bar
  if (version == PlatformVersion.ipados18) {
    return _buildIpados18FloatingTabBar(context, widget);
  }

  // iPadOS 15-17: Classic iPad docked Cupertino tab bar
  return _buildIpadosClassicTabBar(context, widget);
}

/// iPadOS 18 floating capsule tab bar designed specifically for tablet form factors.
Widget _buildIpados18FloatingTabBar(
  BuildContext context,
  NaBottomNavigationBar widget,
) {
  return SafeArea(
    top  : false,
    child: Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        margin     : const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        decoration : BoxDecoration(
          color       : CupertinoColors.systemBackground.resolveFrom(context).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(22),
          boxShadow   : [
            BoxShadow(
              color     : CupertinoColors.systemIndigo.withValues(alpha: 0.14),
              blurRadius: 18,
              offset    : const Offset(0, 6),
            ),
            const BoxShadow(
              color     : Color(0x10000000),
              blurRadius: 6,
              offset    : Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child       : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children         : List.generate(widget.items.length, (index) {
                  final item       = widget.items[index];
                  final isSelected = index == widget.currentIndex;

                  return GestureDetector(
                    onTap   : () => widget.onTap?.call(index),
                    behavior: HitTestBehavior.opaque,
                    child   : AnimatedContainer(
                      duration  : const Duration(milliseconds: 200),
                      padding   : const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CupertinoColors.systemIndigo.withValues(alpha: 0.16)
                            : const Color(0x00000000),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children    : [
                          // Tab icon in iPadOS 18 indigo theme
                          IconTheme(
                            data: IconThemeData(
                              color: isSelected
                                  ? CupertinoColors.systemIndigo
                                  : CupertinoColors.inactiveGray,
                              size: 22,
                            ),
                            child: item.icon,
                          ),
                          // Tab label text
                          if (item.label != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              item.label!,
                              style: TextStyle(
                                color: isSelected
                                    ? CupertinoColors.systemIndigo
                                    : CupertinoColors.inactiveGray,
                                fontSize  : 11,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// iPadOS 15-17 classic docked tab bar.
Widget _buildIpadosClassicTabBar(
  BuildContext context,
  NaBottomNavigationBar widget,
) {
  return Container(
    decoration: const BoxDecoration(
      color : CupertinoColors.systemBackground,
      border: Border(
        top: BorderSide(
          color: CupertinoColors.separator,
          width: 0.0,
        ),
      ),
    ),
    child: SafeArea(
      top  : false,
      child: CupertinoTabBar(
        items          : widget.items,
        currentIndex   : widget.currentIndex,
        onTap          : widget.onTap,
        activeColor    : CupertinoColors.systemIndigo,
        backgroundColor: const Color(0x00000000),
        border         : null,
      ),
    ),
  );
}

Widget _buildAndroidBottomBar(
  BuildContext context,
  NaBottomNavigationBar widget,
  PlatformVersion version,
) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;

  // Material 3 & Material You (NavigationBar with pill indicator)
  if ((version == PlatformVersion.androidM3) ||
      (version == PlatformVersion.androidMaterialYou)) {
    final bool isMaterialYou = version == PlatformVersion.androidMaterialYou;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex        : widget.currentIndex,
        onDestinationSelected: widget.onTap,
        indicatorColor       : isDark
            ? (isMaterialYou ? const Color(0xFF1E3A5F) : const Color(0xFF382D4F))
            : (isMaterialYou ? const Color(0xFFD0E4FF) : const Color(0xFFE8DEF8)),
        backgroundColor: isDark
            ? const Color(0xFF131C31)
            : (isMaterialYou ? const Color(0xFFF0F4F9) : const Color(0xFFF7F2FA)),
        elevation   : 3,
        destinations: widget.items.map((item) {
          return NavigationDestination(
            icon : item.icon,
            label: item.label ?? '',
          );
        }).toList(),
      ),
    );
  }

  // Material 2 (Classic BottomNavigationBar)
  return BottomNavigationBar(
    items              : widget.items,
    currentIndex       : widget.currentIndex,
    onTap              : widget.onTap,
    backgroundColor    : isDark ? const Color(0xFF0B1120) : const Color(0xFFFFFFFF),
    selectedItemColor  : isDark ? const Color(0xFF38BDF8) : const Color(0xFF6200EE),
    unselectedItemColor: isDark ? const Color(0xFF94A3B8) : const Color(0x8A000000),
    type               : BottomNavigationBarType.fixed,
    elevation          : 8,
  );
}

/// Desktop segmented navigation bar item for macOS 12-15 without Material dependencies.
class _MacOsSegmentedItem extends StatefulWidget {
  final BottomNavigationBarItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const _MacOsSegmentedItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_MacOsSegmentedItem> createState() => _MacOsSegmentedItemState();
}

class _MacOsSegmentedItemState extends State<_MacOsSegmentedItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = widget.isSelected
        ? const Color(0xFFFFFFFF)
        : (_isHovered ? const Color(0xFFEBEBEF) : const Color(0x00000000));
    final Color fgColor = widget.isSelected
        ? const Color(0xFF1D1D1F)
        : const Color(0xFF6E6E73);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit : (_) => setState(() => _isHovered = false),
      cursor : SystemMouseCursors.click,
      child  : GestureDetector(
        onTap   : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child   : AnimatedContainer(
          duration  : const Duration(milliseconds: 150),
          padding   : const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color       : bgColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow   : widget.isSelected
                ? const [
                    BoxShadow(
                      color     : Color(0x1F000000),
                      blurRadius: 3,
                      offset    : Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children    : [
              // Navigation icon for macOS desktop bar
              IconTheme(
                data: IconThemeData(
                  color: fgColor,
                  size : 16,
                ),
                child: widget.item.icon,
              ),
              // Optional text label for the desktop segment
              if (widget.item.label != null) ...[
                const SizedBox(width: 6),
                Text(
                  widget.item.label!,
                  style: TextStyle(
                    fontSize  : 12,
                    fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    color     : fgColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Desktop Liquid Glass navigation toolbar item for macOS 26/27.
class _MacOsLiquidGlassItem extends StatefulWidget {
  final BottomNavigationBarItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const _MacOsLiquidGlassItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_MacOsLiquidGlassItem> createState() => _MacOsLiquidGlassItemState();
}

class _MacOsLiquidGlassItemState extends State<_MacOsLiquidGlassItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const Color tintColor = Color(0xFF007AFF);
    final Color bgColor   = widget.isSelected
        ? tintColor.withValues(alpha: 0.18)
        : (_isHovered ? const Color(0x15000000) : const Color(0x00000000));
    final Color fgColor = widget.isSelected
        ? tintColor
        : const Color(0xFF1D1D1F);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit : (_) => setState(() => _isHovered = false),
      cursor : SystemMouseCursors.click,
      child  : GestureDetector(
        onTap   : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child   : AnimatedContainer(
          duration  : const Duration(milliseconds: 160),
          padding   : const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color       : bgColor,
            borderRadius: BorderRadius.circular(8),
            border      : widget.isSelected
                ? Border.all(
                    color: tintColor.withValues(alpha: 0.4),
                    width: 1,
                  )
                : Border.all(
                    color: _isHovered
                        ? const Color(0x20000000)
                        : const Color(0x00000000),
                    width: 1,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children    : [
              // Liquid glass desktop navigation icon
              IconTheme(
                data: IconThemeData(
                  color: fgColor,
                  size : 18,
                ),
                child: widget.item.icon,
              ),
              // Navigation item label
              if (widget.item.label != null) ...[
                const SizedBox(width: 8),
                Text(
                  widget.item.label!,
                  style: TextStyle(
                    color     : fgColor,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating Liquid Glass Navigation Bar (iOS 26 / 27 / iPadOS 26 / 27).
class _LiquidGlassFloatingBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool isNextGen;
  final bool isTablet;

  const _LiquidGlassFloatingBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.isNextGen = false,
    this.isTablet  = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor =
        isNextGen ? const Color(0xFF0A84FF) : const Color(0xFF007AFF);

    return SafeArea(
      top  : false,
      child: Center(
        child: Container(
          constraints: isTablet
              ? const BoxConstraints(maxWidth: 580)
              : null,
          margin: EdgeInsets.only(
            left  : isTablet ? 32 : 20,
            right : isTablet ? 32 : 20,
            bottom: isTablet ? 20 : 24,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow   : [
              BoxShadow(
                color     : activeColor.withValues(alpha: 0.18),
                blurRadius: 28,
                offset    : const Offset(0, 8),
              ),
              const BoxShadow(
                color     : Color(0x14000000),
                blurRadius: 10,
                offset    : Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child       : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child : Container(
                padding   : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient    : const LinearGradient(
                    begin : Alignment.topLeft,
                    end   : Alignment.bottomRight,
                    colors: [
                      Color(0x73FFFFFF),
                      Color(0x33FFFFFF),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0x8CFFFFFF),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children         : List.generate(items.length, (index) {
                    final item       = items[index];
                    final isSelected = index == currentIndex;

                    return GestureDetector(
                      onTap   : () => onTap?.call(index),
                      behavior: HitTestBehavior.opaque,
                      child   : AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve   : Curves.easeInOutCubic,
                        padding : const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical  : 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? activeColor.withValues(alpha: 0.16)
                              : const Color(0x00000000),
                          borderRadius: BorderRadius.circular(20),
                          border      : isSelected
                              ? Border.all(
                                  color: activeColor.withValues(alpha: 0.35),
                                  width: 1.0,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children    : [
                            // Navigation icon with active glow
                            IconTheme(
                              data: IconThemeData(
                                color: isSelected ? activeColor : const Color(0x73000000),
                                size : 24,
                              ),
                              child: item.icon,
                            ),
                            // Navigation label
                            if (item.label != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                item.label!,
                                style: TextStyle(
                                  color     : isSelected ? activeColor : const Color(0x8A000000),
                                  fontSize  : 11,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
