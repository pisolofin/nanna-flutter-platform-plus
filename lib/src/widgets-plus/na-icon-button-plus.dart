import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show IconButton;
import 'package:flutter/cupertino.dart' show CupertinoButton;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaIconButton].
void registerNaIconButtonPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaIconButton>(
    uiType,
    (BuildContext context, NaIconButton widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            // Liquid Glass circular icon button
            return ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child : Container(
                  width     : 44,
                  height    : 44,
                  decoration: BoxDecoration(
                    shape : BoxShape.circle,
                    color : const Color(0x59FFFFFF),
                    border: Border.all(
                      color: const Color(0x99FFFFFF),
                      width: 1.0,
                    ),
                  ),
                  child: CupertinoButton(
                    padding  : EdgeInsets.zero,
                    onPressed: widget.onPressed,
                    child    : widget.icon,
                  ),
                ),
              ),
            );
          }
          return CupertinoButton(
            padding  : const EdgeInsets.all(8.0),
            onPressed: widget.onPressed,
            child    : widget.icon,
          );

        case PlatformFamily.macOS:
          if ((version == PlatformVersion.macos26) ||
              (version == PlatformVersion.macos27)) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child : Container(
                  width     : 32,
                  height    : 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color       : const Color(0x4DFFFFFF),
                    border      : Border.all(
                      color: const Color(0x1A000000),
                      width: 1.0,
                    ),
                  ),
                  child: CupertinoButton(
                    padding    : EdgeInsets.zero,
                    onPressed  : widget.onPressed,
                    minimumSize: const Size(32, 32),
                    child      : widget.icon,
                  ),
                ),
              ),
            );
          }
          return CupertinoButton(
            padding    : const EdgeInsets.all(6.0),
            onPressed  : widget.onPressed,
            minimumSize: const Size(28, 28),
            child      : widget.icon,
          );

        case PlatformFamily.android:
          if (version == PlatformVersion.androidMaterialYou) {
            return IconButton.filledTonal(
              onPressed: widget.onPressed,
              icon     : widget.icon,
            );
          }
          return IconButton(
            onPressed: widget.onPressed,
            icon     : widget.icon,
          );
      }
    },
  );
}
