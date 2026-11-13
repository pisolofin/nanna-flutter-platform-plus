import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart' show ElevatedButton, Theme;

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
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            return _LiquidGlassFilledButton(
              onPressed: widget.onPressed,
              isNextGen: (version == PlatformVersion.ios27) ||
                  (version == PlatformVersion.ipados27),
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
          if ((version == PlatformVersion.macos26) ||
              (version == PlatformVersion.macos27)) {
            return _LiquidGlassFilledButton(
              onPressed   : widget.onPressed,
              isNextGen   : version == PlatformVersion.macos27,
              padding     : const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              borderRadius: 10,
              child       : widget.child,
            );
          }
          return CupertinoButton.filled(
            onPressed   : widget.onPressed,
            padding     : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: BorderRadius.circular(6),
            child       : widget.child,
          );

        case PlatformFamily.android:
          if (version == PlatformVersion.androidMaterialYou) {
            return _AndroidFilledTonalButton(
              onPressed: widget.onPressed,
              child    : widget.child,
            );
          }
          return ElevatedButton(
            onPressed: widget.onPressed,
            child    : widget.child,
          );
      }
    },
  );
}

class _AndroidFilledTonalButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const _AndroidFilledTonalButton({
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding   : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color       : isDark ? const Color(0xFF1E3A5F) : const Color(0xFFD0E4FF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color     : isDark ? const Color(0xFF7DD3FC) : const Color(0xFF001D36),
            fontWeight: FontWeight.w600,
            fontSize  : 14,
          ),
          child: child,
        ),
      ),
    );
  }
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
    this.isNextGen     = false,
    this.padding       = const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
    this.borderRadius  = 26.0,
  });

  @override
  State<_LiquidGlassFilledButton> createState() =>
      _LiquidGlassFilledButtonState();
}

class _LiquidGlassFilledButtonState extends State<_LiquidGlassFilledButton> {
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
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child       : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child : Container(
              padding   : widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient    : LinearGradient(
                  begin : Alignment.topLeft,
                  end   : Alignment.bottomRight,
                  colors: [
                    tintColor.withValues(alpha: _isPressed ? 0.95 : 0.88),
                    tintColor.withValues(alpha: _isPressed ? 0.80 : 0.72),
                  ],
                ),
                border: Border.all(
                  color: const Color(0x8CFFFFFF),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color     : tintColor.withValues(alpha: 0.40),
                    blurRadius: 18,
                    offset    : const Offset(0, 6),
                  ),
                ],
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color        : Color(0xFFFFFFFF),
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
