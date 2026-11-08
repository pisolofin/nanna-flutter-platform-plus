import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show Checkbox;
import 'package:flutter/cupertino.dart' show CupertinoCheckbox, CupertinoColors;

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
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
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
                      : const Color(0x66FFFFFF),
                  border: Border.all(
                    color: isChecked
                        ? const Color(0x00000000)
                        : const Color(0x40000000),
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
                    ? const NaIcon(
                        NaIcons.check,
                        size : 16,
                        color: Color(0xFFFFFFFF),
                      )
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
          if ((version == PlatformVersion.macos26) ||
              (version == PlatformVersion.macos27)) {
            return CupertinoCheckbox(
              value      : widget.value,
              onChanged  : widget.onChanged,
              activeColor: CupertinoColors.activeBlue,
            );
          }
          return CupertinoCheckbox(
            value    : widget.value,
            onChanged: widget.onChanged,
          );

        case PlatformFamily.android:
          return Checkbox(
            value    : widget.value,
            onChanged: widget.onChanged,
          );
      }
    },
  );
}
