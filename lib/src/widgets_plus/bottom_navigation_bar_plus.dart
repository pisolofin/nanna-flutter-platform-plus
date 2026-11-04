import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform_target.dart';
import '../services/platform_version_controller.dart';

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
  if (version == PlatformVersion.ios26 || version == PlatformVersion.ios27) {
    return _LiquidGlassFloatingBar(
      items       : widget.items,
      currentIndex: widget.currentIndex,
      onTap       : widget.onTap,
      isNextGen   : version == PlatformVersion.ios27,
    );
  }

  // iOS 18: Floating tab bar with modern rounded container
  if (version == PlatformVersion.ios18) {
    return Container(
      margin    : const EdgeInsets.only(left: 16, right: 16, bottom: 18),
      decoration: BoxDecoration(
        color       : CupertinoColors.systemBackground.resolveFrom(context).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(24),
        boxShadow   : [
          BoxShadow(
            color     : Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset    : const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child       : CupertinoTabBar(
          items          : widget.items,
          currentIndex   : widget.currentIndex,
          onTap          : widget.onTap,
          backgroundColor: Colors.transparent,
          border         : null,
          activeColor    : CupertinoColors.activeBlue,
        ),
      ),
    );
  }

  // iOS 15-17: Classic CupertinoTabBar
  return CupertinoTabBar(
    items          : widget.items,
    currentIndex   : widget.currentIndex,
    onTap          : widget.onTap,
    backgroundColor: CupertinoColors.systemBackground
        .resolveFrom(context)
        .withValues(alpha: 0.8),
    border: const Border(
      top: BorderSide(
        color: CupertinoColors.separator,
        width: 0.0, // One physical pixel
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
  if (version == PlatformVersion.macos26 || version == PlatformVersion.macos27) {
    return Container(
      padding   : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color : Colors.white.withValues(alpha: 0.45),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.6),
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
              final item = widget.items[index];
              final isSelected = index == widget.currentIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child  : InkWell(
                  onTap       : () => widget.onTap?.call(index),
                  borderRadius: BorderRadius.circular(8),
                  child       : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF007AFF).withValues(alpha: 0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border      : isSelected
                          ? Border.all(
                              color: const Color(0xFF007AFF).withValues(alpha: 0.4),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children    : [
                        IconTheme(
                          data: IconThemeData(
                            color: isSelected
                                ? const Color(0xFF007AFF)
                                : Colors.black54,
                            size: 18,
                          ),
                          child: item.icon,
                        ),
                        if (item.label != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            item.label!,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF007AFF)
                                  : Colors.black87,
                              fontWeight: isSelected
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
            }),
          ),
        ),
      ),
    );
  }

  // macOS 12-15: Desktop segmented bottom bar
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
        final item = widget.items[index];
        final isSelected = index == widget.currentIndex;
        return TextButton(
          onPressed: () => widget.onTap?.call(index),
          style    : TextButton.styleFrom(
            backgroundColor: isSelected ? Colors.white : Colors.transparent,
            foregroundColor: isSelected ? Colors.black : Colors.black54,
            padding        : const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            shape          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children    : [
              IconTheme(
                data: IconThemeData(
                  color: isSelected ? Colors.black : Colors.black54,
                  size : 16,
                ),
                child: item.icon,
              ),
              if (item.label != null) ...[
                const SizedBox(width: 6),
                Text(
                  item.label!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
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
  return _LiquidGlassFloatingBar(
    items       : widget.items,
    currentIndex: widget.currentIndex,
    onTap       : widget.onTap,
    isNextGen   : true,
  );
}

Widget _buildAndroidBottomBar(
  BuildContext context,
  NaBottomNavigationBar widget,
  PlatformVersion version,
) {
  // Material 3 & Material You (NavigationBar with pill indicator)
  if (version == PlatformVersion.androidM3 ||
      version == PlatformVersion.androidMaterialYou) {
    final bool isMaterialYou = version == PlatformVersion.androidMaterialYou;
    return NavigationBar(
      selectedIndex        : widget.currentIndex,
      onDestinationSelected: widget.onTap,
      indicatorColor       : isMaterialYou
          ? const Color(0xFFD0E4FF)
          : const Color(0xFFE8DEF8),
      backgroundColor: isMaterialYou
          ? const Color(0xFFF0F4F9)
          : const Color(0xFFF7F2FA),
      elevation   : 3,
      destinations: widget.items.map((item) {
        return NavigationDestination(
          icon : item.icon,
          label: item.label ?? '',
        );
      }).toList(),
    );
  }

  // Material 2 (Classic BottomNavigationBar)
  return BottomNavigationBar(
    items              : widget.items,
    currentIndex       : widget.currentIndex,
    onTap              : widget.onTap,
    backgroundColor    : Colors.white,
    selectedItemColor  : const Color(0xFF6200EE),
    unselectedItemColor: Colors.black54,
    type               : BottomNavigationBarType.fixed,
    elevation          : 8,
  );
}

/// Floating Liquid Glass Navigation Bar (iOS 26 / 27).
class _LiquidGlassFloatingBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool isNextGen;

  const _LiquidGlassFloatingBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.isNextGen = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor =
        isNextGen ? const Color(0xFF0A84FF) : const Color(0xFF007AFF);

    return Container(
      margin    : const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow   : [
          BoxShadow(
            color     : activeColor.withValues(alpha: 0.18),
            blurRadius: 28,
            offset    : const Offset(0, 8),
          ),
          BoxShadow(
            color     : Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset    : const Offset(0, 2),
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
              gradient    : LinearGradient(
                begin : Alignment.topLeft,
                end   : Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.45),
                  Colors.white.withValues(alpha: 0.20),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.55),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children         : List.generate(items.length, (index) {
                final item = items[index];
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
                          : Colors.transparent,
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
                        IconTheme(
                          data: IconThemeData(
                            color: isSelected ? activeColor : Colors.black45,
                            size : 24,
                          ),
                          child: item.icon,
                        ),
                        if (item.label != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            item.label!,
                            style: TextStyle(
                              color     : isSelected ? activeColor : Colors.black54,
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
    );
  }
}
