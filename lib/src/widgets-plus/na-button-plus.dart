import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaButton].
void registerNaButtonPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaButton>(
    uiType,
    (BuildContext context, NaButton widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
          return _buildIosButton(context, widget, version);
        case PlatformFamily.macOS:
          return _buildMacOsButton(context, widget, version);
        case PlatformFamily.iPadOS:
          return _buildIpadosButton(context, widget, version);
        case PlatformFamily.android:
          return _buildAndroidButton(context, widget, version);
      }
    },
  );
}

Widget _buildIosButton(
  BuildContext context,
  NaButton widget,
  PlatformVersion version,
) {
  // iOS 26 & 27: Liquid Glass aesthetic
  if (version == PlatformVersion.ios26 || version == PlatformVersion.ios27) {
    return _LiquidGlassButton(
      onPressed: widget.onPressed,
      isNextGen: version == PlatformVersion.ios27,
      child    : widget.child,
    );
  }

  // iOS 18: Modern Cupertino with responsive curves
  if (version == PlatformVersion.ios18) {
    return CupertinoButton(
      onPressed   : widget.onPressed,
      padding     : const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      color       : CupertinoColors.activeBlue,
      child       : widget.child,
    );
  }

  // iOS 15 - 17: Classic Cupertino button
  return CupertinoButton.filled(
    onPressed   : widget.onPressed,
    padding     : const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
    borderRadius: BorderRadius.circular(10),
    child       : widget.child,
  );
}

Widget _buildMacOsButton(
  BuildContext context,
  NaButton widget,
  PlatformVersion version,
) {
  // macOS 26 & 27 (Tahoe / Golden Gate): Liquid Glass Desktop
  if (version == PlatformVersion.macos26 || version == PlatformVersion.macos27) {
    return _LiquidGlassDesktopButton(
      onPressed   : widget.onPressed,
      label       : widget.child,
      isGoldenGate: version == PlatformVersion.macos27,
    );
  }

  // macOS 12-15: Standard macOS push button
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child  : OutlinedButton(
      onPressed: widget.onPressed,
      style    : OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: const Color(0xFFF2F2F7),
        side           : const BorderSide(color: Color(0xFFC7C7CC), width: 0.8),
        shape          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle      : const TextStyle(
          fontSize  : 13,
          fontWeight: FontWeight.w500,
          fontFamily: '.AppleSystemUIFont',
        ),
      ),
      child: widget.child,
    ),
  );
}

Widget _buildIpadosButton(
  BuildContext context,
  NaButton widget,
  PlatformVersion version,
) {
  if (version == PlatformVersion.ipados26 || version == PlatformVersion.ipados27) {
    return _LiquidGlassButton(
      onPressed: widget.onPressed,
      isNextGen: true,
      padding  : const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
      child    : widget.child,
    );
  }

  return CupertinoButton(
    onPressed   : widget.onPressed,
    padding     : const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    borderRadius: BorderRadius.circular(14),
    color       : CupertinoColors.systemIndigo,
    child       : widget.child,
  );
}

Widget _buildAndroidButton(
  BuildContext context,
  NaButton widget,
  PlatformVersion version,
) {
  // Material You (API 34+)
  if (version == PlatformVersion.androidMaterialYou) {
    return FilledButton.tonal(
      onPressed: widget.onPressed,
      style    : FilledButton.styleFrom(
        backgroundColor: const Color(0xFFD0E4FF),
        foregroundColor: const Color(0xFF001D36),
        shape          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding        : const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      child: widget.child,
    );
  }

  // Material 3 (API 31-33)
  if (version == PlatformVersion.androidM3) {
    return FilledButton(
      onPressed: widget.onPressed,
      style    : FilledButton.styleFrom(
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        shape          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding        : const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: widget.child,
    );
  }

  // Material 2 (Android 11-)
  return ElevatedButton(
    onPressed: widget.onPressed,
    style    : ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6200EE),
      foregroundColor: Colors.white,
      elevation      : 2,
      shape          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      padding        : const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      textStyle      : const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.25),
    ),
    child: widget.child,
  );
}

/// Custom Liquid Glass button widget for iOS 26/27.
class _LiquidGlassButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isNextGen;
  final EdgeInsetsGeometry padding;

  const _LiquidGlassButton({
    required this.onPressed,
    required this.child,
    this.isNextGen = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
  });

  @override
  State<_LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<_LiquidGlassButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color tintColor = widget.isNextGen
        ? const Color(0xFF0A84FF)
        : const Color(0xFF007AFF);

    return GestureDetector(
      onTapDown  : (_) => setState(() => _isPressed = true),
      onTapUp    : (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap      : widget.onPressed,
      child      : AnimatedScale(
        scale   : _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve   : Curves.easeOutCubic,
        child   : ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child       : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child : Container(
              padding   : widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient    : LinearGradient(
                  begin : Alignment.topLeft,
                  end   : Alignment.bottomRight,
                  colors: [
                    tintColor.withValues(alpha: _isPressed ? 0.85 : 0.75),
                    tintColor.withValues(alpha: _isPressed ? 0.65 : 0.55),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color     : tintColor.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset    : const Offset(0, 6),
                  ),
                ],
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color        : Colors.white,
                  fontWeight   : FontWeight.w600,
                  fontSize     : 16,
                  letterSpacing: -0.3,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom macOS Liquid Glass button widget.
class _LiquidGlassDesktopButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget label;
  final bool isGoldenGate;

  const _LiquidGlassDesktopButton({
    required this.onPressed,
    required this.label,
    this.isGoldenGate = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child       : BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient    : LinearGradient(
              begin : Alignment.topCenter,
              end   : Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.35),
                Colors.white.withValues(alpha: 0.15),
              ],
            ),
            border: Border.all(
              color: isGoldenGate
                  ? const Color(0xFF007AFF).withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.15),
              width: 1.0,
            ),
          ),
          child: CupertinoButton(
            padding    : const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            onPressed  : onPressed,
            minimumSize: const Size(0, 32),
            child      : DefaultTextStyle(
              style: TextStyle(
                color: isGoldenGate
                    ? const Color(0xFF007AFF)
                    : const Color(0xFF1D1D1F),
                fontWeight: FontWeight.w600,
                fontSize  : 13,
              ),
              child: label,
            ),
          ),
        ),
      ),
    );
  }
}
