import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaCheckbox].
void registerNaCheckboxPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaCheckbox>(
    uiType,
    (BuildContext context, NaCheckbox widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27 ||
              version == PlatformVersion.ipados26 ||
              version == PlatformVersion.ipados27) {
            // Liquid Glass Checkbox
            final isChecked = widget.value == true;
            return GestureDetector(
              onTap: widget.onChanged != null
                  ? () => widget.onChanged!(!isChecked)
                  : null,
              child: AnimatedContainer(
                duration  : const Duration(milliseconds: 200),
                width     : 24,
                height    : 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color       : isChecked
                      ? (version == PlatformVersion.ios27
                          ? const Color(0xFF0071E3)
                          : const Color(0xFF007AFF))
                      : Colors.white.withValues(alpha: 0.4),
                  border: Border.all(
                    color: isChecked
                        ? Colors.transparent
                        : Colors.black.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                  boxShadow: isChecked
                      ? [
                          BoxShadow(
                            color     : const Color(0xFF007AFF).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset    : const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: isChecked
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            );
          }
          return CupertinoCheckbox(
            value      : widget.value,
            onChanged  : widget.onChanged,
            activeColor: CupertinoColors.activeBlue,
          );

        case PlatformFamily.macOS:
          return CupertinoCheckbox(
            value      : widget.value,
            onChanged  : widget.onChanged,
            activeColor: CupertinoColors.activeBlue,
          );

        case PlatformFamily.android:
          if (version == PlatformVersion.androidMaterialYou ||
              version == PlatformVersion.androidM3) {
            return Checkbox(
              value    : widget.value,
              onChanged: widget.onChanged,
              shape    : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }
          return Checkbox(
            value      : widget.value,
            onChanged  : widget.onChanged,
            activeColor: const Color(0xFF6200EE),
          );
      }
    },
  );
}
