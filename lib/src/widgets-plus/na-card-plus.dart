import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaCard].
void registerNaCardPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaCard>(
    uiType,
    (BuildContext context, NaCard widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;
      final NaCardOptions? options =
          widget.optionsBuilder?.call(context, uiType);
      final EdgeInsetsGeometry padding =
          (options is NaCardOptionsGeneric ? options.padding : null) ??
              const EdgeInsets.all(16.0);

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27 ||
              version == PlatformVersion.ipados26 ||
              version == PlatformVersion.ipados27) {
            // Liquid Glass Card
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                child : Container(
                  padding   : padding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient    : LinearGradient(
                      begin : Alignment.topLeft,
                      end   : Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.55),
                        Colors.white.withValues(alpha: 0.25),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color     : Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset    : const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            );
          }

          // iOS 15-18 Cupertino Card
          return Container(
            padding   : padding,
            decoration: BoxDecoration(
              color: CupertinoColors.secondarySystemGroupedBackground
                  .resolveFrom(context),
              borderRadius: BorderRadius.circular(version == PlatformVersion.ios18 ? 16 : 12),
              border      : Border.all(
                color: CupertinoColors.separator.resolveFrom(context).withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
            child: widget.child,
          );

        case PlatformFamily.macOS:
          if (version == PlatformVersion.macos26 ||
              version == PlatformVersion.macos27) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child : Container(
                  padding   : padding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color       : Colors.white.withValues(alpha: 0.5),
                    border      : Border.all(
                      color: Colors.black.withValues(alpha: 0.12),
                      width: 1.0,
                    ),
                  ),
                  child: widget.child,
                ),
              ),
            );
          }
          return Container(
            padding   : padding,
            decoration: BoxDecoration(
              color       : const Color(0xFFFBFBFB),
              borderRadius: BorderRadius.circular(8),
              border      : Border.all(
                color: const Color(0xFFDCDCDC),
                width: 1.0,
              ),
            ),
            child: widget.child,
          );

        case PlatformFamily.android:
          if (version == PlatformVersion.androidMaterialYou) {
            return Card(
              elevation: 0,
              color    : const Color(0xFFE8EDF4),
              shape    : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(padding: padding, child: widget.child),
            );
          }
          if (version == PlatformVersion.androidM3) {
            return Card(
              elevation: 1,
              color    : const Color(0xFFF7F2FA),
              shape    : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(padding: padding, child: widget.child),
            );
          }
          // Material 2
          return Card(
            elevation: 2,
            shape    : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(padding: padding, child: widget.child),
          );
      }
    },
  );
}
