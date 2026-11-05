import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaButtonFilled].
void registerNaButtonFilledPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaButtonFilled>(
    uiType,
    (BuildContext context, NaButtonFilled widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27 ||
              version == PlatformVersion.ipados26 ||
              version == PlatformVersion.ipados27) {
            return _LiquidGlassFilledButton(
              onPressed: widget.onPressed,
              isNextGen: version == PlatformVersion.ios27 ||
                  version == PlatformVersion.ipados27,
              child: widget.child,
            );
          }
          return CupertinoButton.filled(
            onPressed   : widget.onPressed,
            borderRadius: BorderRadius.circular(
              version == PlatformVersion.ios18 ? 16 : 10,
            ),
            child: widget.child,
          );

        case PlatformFamily.macOS:
          if (version == PlatformVersion.macos26 ||
              version == PlatformVersion.macos27) {
            return _LiquidGlassFilledButton(
              onPressed   : widget.onPressed,
              isNextGen   : version == PlatformVersion.macos27,
              padding     : const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              borderRadius: 10,
              child       : widget.child,
            );
          }
          return FilledButton(
            onPressed: widget.onPressed,
            style    : FilledButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              shape          : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: widget.child,
          );

        case PlatformFamily.android:
          if (version == PlatformVersion.androidMaterialYou) {
            return FilledButton(
              onPressed: widget.onPressed,
              style    : FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: widget.child,
            );
          }
          if (version == PlatformVersion.androidM3) {
            return FilledButton(
              onPressed: widget.onPressed,
              style    : FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: widget.child,
            );
          }
          // Material 2
          return ElevatedButton(
            onPressed: widget.onPressed,
            style    : ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6200EE),
              foregroundColor: Colors.white,
              elevation      : 4,
              shape          : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: widget.child,
          );
      }
    },
  );
}

class _LiquidGlassFilledButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isNextGen;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const _LiquidGlassFilledButton({
    required this.onPressed,
    required this.child,
    this.isNextGen = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
    this.borderRadius = 26,
  });

  @override
  State<_LiquidGlassFilledButton> createState() =>
      _LiquidGlassFilledButtonState();
}

class _LiquidGlassFilledButtonState extends State<_LiquidGlassFilledButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor =
        widget.isNextGen ? const Color(0xFF0071E3) : const Color(0xFF007AFF);

    return GestureDetector(
      onTapDown  : (_) => setState(() => _isPressed = true),
      onTapUp    : (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap      : widget.onPressed,
      child      : AnimatedScale(
        scale   : _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child   : ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child       : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child : Container(
              padding   : widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient    : LinearGradient(
                  begin : Alignment.topCenter,
                  end   : Alignment.bottomCenter,
                  colors: [
                    baseColor.withValues(alpha: _isPressed ? 0.95 : 0.88),
                    baseColor.withValues(alpha: _isPressed ? 0.80 : 0.72),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.55),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color     : baseColor.withValues(alpha: 0.4),
                    blurRadius: 20,
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
