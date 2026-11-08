import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show ListTile;
import 'package:flutter/cupertino.dart' show CupertinoListTile, CupertinoListTileChevron;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaListTile].
void registerNaListTilePlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaListTile>(
    uiType,
    (BuildContext context, NaListTile widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            // Liquid Glass ListTile
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child       : BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child : Container(
                    decoration: BoxDecoration(
                      color       : const Color(0x73FFFFFF),
                      borderRadius: BorderRadius.circular(16),
                      border      : Border.all(
                        color: const Color(0x8CFFFFFF),
                        width: 1.0,
                      ),
                    ),
                    child: CupertinoListTile(
                      leading : widget.leading,
                      title   : widget.title,
                      subtitle: widget.subtitle,
                      trailing: widget.trailing ??
                          (widget.hasChevron
                              ? const CupertinoListTileChevron()
                              : null),
                      onTap: widget.onTap,
                    ),
                  ),
                ),
              ),
            );
          }
          return CupertinoListTile(
            leading : widget.leading,
            title   : widget.title,
            subtitle: widget.subtitle,
            trailing: widget.trailing ??
                (widget.hasChevron ? const CupertinoListTileChevron() : null),
            onTap: widget.onTap,
          );

        case PlatformFamily.macOS:
          return CupertinoListTile(
            leading : widget.leading,
            title   : widget.title,
            subtitle: widget.subtitle,
            trailing: widget.trailing ??
                (widget.hasChevron ? const CupertinoListTileChevron() : null),
            onTap: widget.onTap,
          );

        case PlatformFamily.android:
          return ListTile(
            leading : widget.leading,
            title   : widget.title,
            subtitle: widget.subtitle,
            trailing: widget.trailing ??
                (widget.hasChevron
                    ? const NaIcon(NaIcons.chevronRight, size: 20)
                    : null),
            onTap: widget.onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                version == PlatformVersion.androidMaterialYou ? 16 : 8,
              ),
            ),
          );
      }
    },
  );
}
