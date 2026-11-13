import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show AppBar, Theme;
import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoNavigationBar;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaAppBar].
void registerNaAppBarPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaAppBar>(
    uiType,
    (BuildContext context, NaAppBar widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            return _LiquidGlassAppBar(widget: widget, version: version);
          }
          return CupertinoNavigationBar(
            middle  : widget.title,
            leading : widget.leading,
            trailing: ((widget.actions != null) && (widget.actions!.isNotEmpty))
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children    : widget.actions!,
                  )
                : null,
            backgroundColor: widget.backgroundColor ??
                CupertinoColors.systemBackground.withValues(alpha: 0.8),
          );

        case PlatformFamily.macOS:
          return Container(
            height    : 48,
            padding   : const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color : Color(0xFFF6F6F6),
              border: Border(
                bottom: BorderSide(
                  color: Color(0x1A000000),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Optional leading navigation item
                if (widget.leading != null) ...[
                  widget.leading!,
                ],
                // Centered window title
                Expanded(
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize  : 13,
                        fontWeight: FontWeight.w600,
                        color     : Color(0xDD000000),
                      ),
                      child: widget.title ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
                // Trailing actions list
                if (widget.actions != null) ...[
                  ...widget.actions!,
                ],
              ],
            ),
          );

        case PlatformFamily.android:
          final bool isDark       = Theme.of(context).brightness == Brightness.dark;
          final Color effectiveBg = widget.backgroundColor ??
              (isDark ? const Color(0xFF0B1120) : const Color(0xFFF0F4F9));
          final Color effectiveFg = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B);

          if (version == PlatformVersion.androidMaterialYou) {
            return AppBar(
              title          : widget.title,
              leading        : widget.leading,
              actions        : widget.actions,
              backgroundColor: effectiveBg,
              foregroundColor: effectiveFg,
              elevation      : 0,
              centerTitle    : true,
            );
          }
          if (version == PlatformVersion.androidM3) {
            return AppBar(
              title          : widget.title,
              leading        : widget.leading,
              actions        : widget.actions,
              backgroundColor: effectiveBg,
              foregroundColor: effectiveFg,
              elevation      : 0,
              centerTitle    : true,
            );
          }
          return AppBar(
            title          : widget.title,
            leading        : widget.leading,
            actions        : widget.actions,
            backgroundColor: widget.backgroundColor ?? (isDark ? const Color(0xFF0B1120) : const Color(0xFF6200EE)),
            foregroundColor: isDark ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF),
            elevation      : 4,
          );
      }
    },
  );
}

class _LiquidGlassAppBar extends StatelessWidget {
  final NaAppBar widget;
  final PlatformVersion version;

  const _LiquidGlassAppBar({
    required this.widget,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child : Container(
          decoration: const BoxDecoration(
            color : Color(0xA6FFFFFF),
            border: Border(
              bottom: BorderSide(
                color: Color(0x99FFFFFF),
                width: 1.0,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child : SizedBox(
              height: 48,
              child : NavigationToolbar(
                leading: widget.leading,
                middle : widget.title != null
                    ? DefaultTextStyle(
                        style: const TextStyle(
                          color        : Color(0xFF1D1D1F),
                          fontWeight   : FontWeight.w600,
                          fontSize     : 17,
                          letterSpacing: -0.4,
                        ),
                        child: widget.title!,
                      )
                    : null,
                trailing: ((widget.actions != null) && (widget.actions!.isNotEmpty))
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children    : widget.actions!,
                      )
                    : null,
                centerMiddle: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
