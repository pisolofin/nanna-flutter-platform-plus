// ignore_for_file: deprecated_member_use
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Radio;
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoRadio;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaRadio].
void registerNaRadioPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaRadio>(
    uiType,
    (BuildContext context, NaRadio widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            // Liquid Glass Radio
            final bool isSelected   = widget.value == widget.groupValue;
            final Color activeColor = version == PlatformVersion.ios27
                ? const Color(0xFF0071E3)
                : const Color(0xFF007AFF);

            return GestureDetector(
              onTap: widget.onChanged != null
                  ? () => widget.onChanged?.call(widget.value)
                  : null,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child : Container(
                    width     : 22,
                    height    : 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? activeColor.withValues(alpha: 0.18)
                          : const Color(0x59FFFFFF),
                      border: Border.all(
                        color: isSelected
                            ? activeColor
                            : const Color(0x40000000),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color     : activeColor.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset    : const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration  : const Duration(milliseconds: 180),
                        curve     : Curves.easeOutBack,
                        width     : isSelected ? 10 : 0,
                        height    : isSelected ? 10 : 0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? activeColor
                              : const Color(0x00000000),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color     : activeColor.withValues(alpha: 0.6),
                                    blurRadius: 4,
                                    offset    : const Offset(0, 0),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return CupertinoRadio(
            value      : widget.value,
            groupValue : widget.groupValue,
            onChanged  : widget.onChanged,
            activeColor: CupertinoColors.activeBlue,
          );

        case PlatformFamily.macOS:
          if ((version == PlatformVersion.macos26) ||
              (version == PlatformVersion.macos27)) {
            return _LiquidGlassDesktopRadio(
              value     : widget.value,
              groupValue: widget.groupValue,
              onChanged : widget.onChanged,
            );
          }
          // macOS 12-15: Desktop compact radio control
          return _MacOsCompactRadio(
            value     : widget.value,
            groupValue: widget.groupValue,
            onChanged : widget.onChanged,
          );

        case PlatformFamily.android:
          return Radio(
            value      : widget.value,
            groupValue : widget.groupValue,
            onChanged  : widget.onChanged,
            activeColor: version == PlatformVersion.androidM2
                ? const Color(0xFF6200EE)
                : null,
          );
      }
    },
  );
}

class _LiquidGlassDesktopRadio extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final ValueChanged<dynamic>? onChanged;

  const _LiquidGlassDesktopRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;
    const Color tintColor = Color(0xFF007AFF);

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child : Container(
            width     : 16,
            height    : 16,
            decoration: BoxDecoration(
              shape : BoxShape.circle,
              color : isSelected ? tintColor : const Color(0x80FFFFFF),
              border: Border.all(
                color: isSelected
                    ? tintColor
                    : const Color(0x4D000000),
                width: 1.0,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width     : 6,
                      height    : 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _MacOsCompactRadio extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final ValueChanged<dynamic>? onChanged;

  const _MacOsCompactRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: Container(
        width     : 16,
        height    : 16,
        decoration: BoxDecoration(
          shape : BoxShape.circle,
          color : isSelected ? const Color(0xFF007AFF) : const Color(0xFFFFFFFF),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFB0B0B5),
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color     : Color(0x1A000000),
              blurRadius: 1,
              offset    : Offset(0, 1),
            ),
          ],
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width     : 6,
                  height    : 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
