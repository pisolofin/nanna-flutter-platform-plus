import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show Card, Theme;
import 'package:flutter/cupertino.dart' show CupertinoColors;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Resolves an optional [BoxBorder] for Cupertino/macOS cards, honoring explicit overrides.
BoxBorder? _resolveCardBoxBorder({
  required NaCardOptionsGeneric? genericOptions,
  required NaCardOptionsCupertino? cupertinoOptions,
  required Color defaultColor,
  required double defaultWidth,
}) {
  if (cupertinoOptions?.border != null) {
    return cupertinoOptions!.border;
  }

  final double effectiveWidth = genericOptions?.borderWidth ?? defaultWidth;
  if (effectiveWidth <= 0.0) {
    return null;
  }

  return Border.all(
    color: genericOptions?.borderColor ?? defaultColor,
    width: effectiveWidth,
  );
}

/// Resolves an optional [BorderSide] for Android Material cards, honoring explicit overrides.
BorderSide _resolveMaterialBorderSide({
  required NaCardOptionsGeneric? genericOptions,
  required Color defaultColor,
  required double defaultWidth,
}) {
  final double effectiveWidth = genericOptions?.borderWidth ?? defaultWidth;
  if (effectiveWidth <= 0.0) {
    return BorderSide.none;
  }

  return BorderSide(
    color: genericOptions?.borderColor ?? defaultColor,
    width: effectiveWidth,
  );
}

/// Registers the version-aware widget builder for [NaCard].
void registerNaCardPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaCard>(
    uiType,
    (BuildContext context, NaCard widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;
      final Object? rawOptions             = widget.options;
      final NaCardOptions? resolvedOptions = (rawOptions is NaCardOptions)
        ? rawOptions
        : widget.optionsBuilder?.call(context, uiType)
      ;
      final NaCardOptionsGeneric? genericOptions = (resolvedOptions is NaCardOptionsGeneric)
        ? resolvedOptions
        : null
      ;
      final EdgeInsetsGeometry padding = genericOptions?.padding ??
          widget.padding ??
          const EdgeInsets.all(16.0);
      final EdgeInsetsGeometry margin = genericOptions?.margin ?? EdgeInsets.zero;
      final Clip clipBehavior         = genericOptions?.clipBehavior ?? Clip.antiAlias;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          final NaCardOptionsCupertino? cupertinoOptions = (resolvedOptions is NaCardOptionsCupertino)
            ? resolvedOptions
            : null
          ;

          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            final BorderRadiusGeometry effectiveRadius =
                genericOptions?.borderRadius ?? BorderRadius.circular(24);
            final BoxBorder? effectiveBorder = _resolveCardBoxBorder(
              genericOptions  : genericOptions,
              cupertinoOptions: cupertinoOptions,
              defaultColor    : const Color(0x99FFFFFF),
              defaultWidth    : 1.2,
            );

            // Liquid Glass Card
            final Widget glassCard = ClipRRect(
              borderRadius: effectiveRadius,
              clipBehavior: clipBehavior,
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                child : Container(
                  padding   : padding,
                  decoration: BoxDecoration(
                    borderRadius: effectiveRadius,
                    color       : genericOptions?.color,
                    gradient    : (genericOptions?.color == null)
                      ? const LinearGradient(
                          begin : Alignment.topLeft,
                          end   : Alignment.bottomRight,
                          colors: [
                            Color(0x8CFFFFFF),
                            Color(0x40FFFFFF),
                          ],
                        )
                      : null,
                    border   : effectiveBorder,
                    boxShadow: const [
                      BoxShadow(
                        color     : Color(0x0F000000),
                        blurRadius: 18,
                        offset    : Offset(0, 6),
                      ),
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            );

            if (margin != EdgeInsets.zero) {
              return Padding(
                padding: margin,
                child  : glassCard,
              );
            }
            return glassCard;
          }

          // iOS 15-18 Cupertino Card
          return Container(
            margin      : margin,
            padding     : padding,
            clipBehavior: clipBehavior,
            decoration  : BoxDecoration(
              color: genericOptions?.color ??
                  CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
              borderRadius: genericOptions?.borderRadius ??
                  BorderRadius.circular(version == PlatformVersion.ios18 ? 16 : NaCard.defaultBorderRadius),
              border: _resolveCardBoxBorder(
                genericOptions  : genericOptions,
                cupertinoOptions: cupertinoOptions,
                defaultColor    : CupertinoColors.separator.resolveFrom(context).withValues(alpha: 0.5),
                defaultWidth    : NaCard.defaultBorderWidth,
              ),
            ),
            child: widget.child,
          );

        case PlatformFamily.macOS:
          final NaCardOptionsCupertino? cupertinoOptions = (resolvedOptions is NaCardOptionsCupertino)
            ? resolvedOptions
            : null
          ;

          if ((version == PlatformVersion.macos26) ||
              (version == PlatformVersion.macos27)) {
            final BorderRadiusGeometry effectiveRadius =
                genericOptions?.borderRadius ?? BorderRadius.circular(14);
            final Widget glassCard = ClipRRect(
              borderRadius: effectiveRadius,
              clipBehavior: clipBehavior,
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child : Container(
                  padding   : padding,
                  decoration: BoxDecoration(
                    borderRadius: effectiveRadius,
                    color       : genericOptions?.color ?? const Color(0x80FFFFFF),
                    border      : _resolveCardBoxBorder(
                      genericOptions  : genericOptions,
                      cupertinoOptions: cupertinoOptions,
                      defaultColor    : const Color(0x1F000000),
                      defaultWidth    : 1.0,
                    ),
                  ),
                  child: widget.child,
                ),
              ),
            );

            if (margin != EdgeInsets.zero) {
              return Padding(
                padding: margin,
                child  : glassCard,
              );
            }
            return glassCard;
          }

          return Container(
            margin      : margin,
            padding     : padding,
            clipBehavior: clipBehavior,
            decoration  : BoxDecoration(
              color       : genericOptions?.color ?? const Color(0xFFFBFBFB),
              borderRadius: genericOptions?.borderRadius ?? BorderRadius.circular(8),
              border      : _resolveCardBoxBorder(
                genericOptions  : genericOptions,
                cupertinoOptions: cupertinoOptions,
                defaultColor    : const Color(0xFFDCDCDC),
                defaultWidth    : 1.0,
              ),
            ),
            child: widget.child,
          );

        case PlatformFamily.android:
          final bool isDark                            = Theme.of(context).brightness == Brightness.dark;
          final NaCardOptionsMaterial? materialOptions = (resolvedOptions is NaCardOptionsMaterial)
            ? resolvedOptions
            : null
          ;

          if (version == PlatformVersion.androidMaterialYou) {
            return Card(
              elevation         : materialOptions?.elevation ?? (isDark ? 0 : 0.5),
              color             : genericOptions?.color ?? (isDark ? const Color(0xFF131C31) : const Color(0xFFFFFFFF)),
              shadowColor       : materialOptions?.shadowColor,
              surfaceTintColor  : materialOptions?.surfaceTintColor,
              borderOnForeground: materialOptions?.borderOnForeground ?? true,
              semanticContainer : materialOptions?.semanticContainer ?? true,
              margin            : margin,
              clipBehavior      : clipBehavior,
              shape             : materialOptions?.shape ??
                  RoundedRectangleBorder(
                    borderRadius: genericOptions?.borderRadius ?? BorderRadius.circular(20),
                    side        : _resolveMaterialBorderSide(
                      genericOptions: genericOptions,
                      defaultColor  : isDark ? const Color(0xFF283655) : const Color(0xFFE2E8F0),
                      defaultWidth  : 1,
                    ),
                  ),
              child: Padding(padding: padding, child: widget.child),
            );
          }

          if (version == PlatformVersion.androidM3) {
            return Card(
              elevation         : materialOptions?.elevation ?? 1,
              color             : genericOptions?.color ?? (isDark ? const Color(0xFF1C2842) : const Color(0xFFFFFFFF)),
              shadowColor       : materialOptions?.shadowColor,
              surfaceTintColor  : materialOptions?.surfaceTintColor,
              borderOnForeground: materialOptions?.borderOnForeground ?? true,
              semanticContainer : materialOptions?.semanticContainer ?? true,
              margin            : margin,
              clipBehavior      : clipBehavior,
              shape             : materialOptions?.shape ??
                  RoundedRectangleBorder(
                    borderRadius: genericOptions?.borderRadius ?? BorderRadius.circular(16),
                    side        : _resolveMaterialBorderSide(
                      genericOptions: genericOptions,
                      defaultColor  : isDark ? const Color(0xFF283655) : const Color(0xFFE2E8F0),
                      defaultWidth  : 1,
                    ),
                  ),
              child: Padding(padding: padding, child: widget.child),
            );
          }

          // Material 2
          final bool hasCustomBorder =
              (genericOptions?.borderColor != null) || (genericOptions?.borderWidth != null);
          return Card(
            elevation         : materialOptions?.elevation ?? 2,
            color             : genericOptions?.color ?? (isDark ? const Color(0xFF131C31) : const Color(0xFFFFFFFF)),
            shadowColor       : materialOptions?.shadowColor,
            surfaceTintColor  : materialOptions?.surfaceTintColor,
            borderOnForeground: materialOptions?.borderOnForeground ?? true,
            semanticContainer : materialOptions?.semanticContainer ?? true,
            margin            : margin,
            clipBehavior      : clipBehavior,
            shape             : materialOptions?.shape ??
                RoundedRectangleBorder(
                  borderRadius: genericOptions?.borderRadius ?? BorderRadius.circular(8),
                  side        : hasCustomBorder
                    ? _resolveMaterialBorderSide(
                        genericOptions: genericOptions,
                        defaultColor  : isDark ? const Color(0xFF283655) : const Color(0xFFE2E8F0),
                        defaultWidth  : NaCard.defaultBorderWidth,
                      )
                    : BorderSide.none,
                ),
            child: Padding(padding: padding, child: widget.child),
          );
      }
    },
  );
}
