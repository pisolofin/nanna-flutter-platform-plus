import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

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
          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27 ||
              version == PlatformVersion.ipados26 ||
              version == PlatformVersion.ipados27) {
            // Liquid Glass circular icon button
            return ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child : Container(
                  width     : 44,
                  height    : 44,
                  decoration: BoxDecoration(
                    shape : BoxShape.circle,
                    color : Colors.white.withValues(alpha: 0.35),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
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
          if (version == PlatformVersion.macos26 ||
              version == PlatformVersion.macos27) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child : Container(
                  width     : 32,
                  height    : 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color       : Colors.white.withValues(alpha: 0.3),
                    border      : Border.all(
                      color: Colors.black.withValues(alpha: 0.1),
                      width: 0.8,
                    ),
                  ),
                  child: IconButton(
                    padding  : EdgeInsets.zero,
                    iconSize : 18,
                    onPressed: widget.onPressed,
                    icon     : widget.icon,
                  ),
                ),
              ),
            );
          }
          return IconButton(
            iconSize : 20,
            padding  : const EdgeInsets.all(6.0),
            onPressed: widget.onPressed,
            icon     : widget.icon,
          );

        case PlatformFamily.android:
          if (version == PlatformVersion.androidMaterialYou) {
            return IconButton.filledTonal(
              onPressed: widget.onPressed,
              icon     : widget.icon,
            );
          }
          if (version == PlatformVersion.androidM3) {
            return IconButton(
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
