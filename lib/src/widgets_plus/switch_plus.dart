import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform_target.dart';
import '../services/platform_version_controller.dart';

/// Registers the version-aware widget builder for [NaSwitch].
void registerNaSwitchPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaSwitch>(
    uiType,
    (BuildContext context, NaSwitch widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27 ||
              version == PlatformVersion.ipados26 ||
              version == PlatformVersion.ipados27) {
            // iOS 26 / 27: Elongated pill thumb (Liquid Glass)
            return _Ios26PillSwitch(
              value: widget.value,
              onChanged: widget.onChanged,
              isNextGen: version == PlatformVersion.ios27,
            );
          }
          // iOS 15-18: Standard round thumb Cupertino switch
          return CupertinoSwitch(
            value: widget.value,
            onChanged: widget.onChanged,
            activeTrackColor: CupertinoColors.systemGreen,
          );

        case PlatformFamily.macOS:
          if (version == PlatformVersion.macos26 ||
              version == PlatformVersion.macos27) {
            return _Ios26PillSwitch(
              value: widget.value,
              onChanged: widget.onChanged,
              isNextGen: version == PlatformVersion.macos27,
              scale: 0.85,
            );
          }
          return Transform.scale(
            scale: 0.85,
            child: CupertinoSwitch(
              value: widget.value,
              onChanged: widget.onChanged,
              activeTrackColor: CupertinoColors.activeBlue,
            ),
          );

        case PlatformFamily.android:
          if (version == PlatformVersion.androidMaterialYou ||
              version == PlatformVersion.androidM3) {
            return Switch(
              value: widget.value,
              onChanged: widget.onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF6750A4),
            );
          }
          // Material 2
          return Switch(
            value: widget.value,
            onChanged: widget.onChanged,
            activeThumbColor: const Color(0xFF6200EE),
          );
      }
    },
  );
}

/// Specialized iOS 26/27 switch featuring the elongated capsule thumb.
class _Ios26PillSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isNextGen;
  final double scale;

  const _Ios26PillSwitch({
    required this.value,
    required this.onChanged,
    this.isNextGen = false,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    const double trackWidth = 58.0;
    const double trackHeight = 32.0;
    const double thumbWidth = 36.0; // Elongated pill thumb!
    const double thumbHeight = 28.0;

    final Color trackColor = value
        ? (isNextGen ? const Color(0xFF30D158) : const Color(0xFF34C759))
        : const Color(0xFFE5E5EA);

    return Transform.scale(
      scale: scale,
      child: GestureDetector(
        onTap: onChanged != null ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          width: trackWidth,
          height: trackHeight,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(trackHeight / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Container(
                    width: thumbWidth,
                    height: thumbHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(thumbHeight / 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.16),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 1,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

