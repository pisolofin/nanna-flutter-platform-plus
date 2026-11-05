import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

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
          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27 ||
              version == PlatformVersion.ipados26 ||
              version == PlatformVersion.ipados27) {
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
                          : Colors.white.withValues(alpha: 0.35),
                      border: Border.all(
                        color: isSelected
                            ? activeColor
                            : Colors.black.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color     : activeColor.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset    : const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration  : const Duration(milliseconds: 180),
                        curve     : Curves.easeInOutCubic,
                        width     : isSelected ? 10 : 0,
                        height    : isSelected ? 10 : 0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          // ignore: deprecated_member_use
          return CupertinoRadio(
            value: widget.value,
            // ignore: deprecated_member_use
            groupValue: widget.groupValue,
            // ignore: deprecated_member_use
            onChanged  : (dynamic val) => widget.onChanged?.call(val),
            activeColor: CupertinoColors.activeBlue,
          );

        case PlatformFamily.macOS:
          if (version == PlatformVersion.macos26 ||
              version == PlatformVersion.macos27) {
            final bool isSelected   = widget.value == widget.groupValue;
            const Color activeColor = Color(0xFF007AFF);
            return GestureDetector(
              onTap: widget.onChanged != null
                  ? () => widget.onChanged?.call(widget.value)
                  : null,
              child: Container(
                width     : 16,
                height    : 16,
                decoration: BoxDecoration(
                  shape : BoxShape.circle,
                  color : Colors.white.withValues(alpha: 0.5),
                  border: Border.all(
                    color: isSelected
                        ? activeColor
                        : Colors.black.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration  : const Duration(milliseconds: 150),
                    width     : isSelected ? 6 : 0,
                    height    : isSelected ? 6 : 0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor,
                    ),
                  ),
                ),
              ),
            );
          }
          // ignore: deprecated_member_use
          return CupertinoRadio(
            value: widget.value,
            // ignore: deprecated_member_use
            groupValue: widget.groupValue,
            // ignore: deprecated_member_use
            onChanged  : (dynamic val) => widget.onChanged?.call(val),
            activeColor: CupertinoColors.activeBlue,
          );

        case PlatformFamily.android:
          // ignore: deprecated_member_use
          return Radio(
            value: widget.value,
            // ignore: deprecated_member_use
            groupValue: widget.groupValue,
            // ignore: deprecated_member_use
            onChanged  : (dynamic val) => widget.onChanged?.call(val),
            activeColor: version == PlatformVersion.androidM2
                ? const Color(0xFF6200EE)
                : null,
          );
      }
    },
  );
}
