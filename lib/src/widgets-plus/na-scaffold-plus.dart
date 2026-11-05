import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaScaffold].
void registerNaScaffoldPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaScaffold>(
    uiType,
    (BuildContext context, NaScaffold widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
        case PlatformFamily.macOS:
          final ObstructingPreferredSizeWidget? navBar =
              widget.appBar is ObstructingPreferredSizeWidget
                  ? widget.appBar as ObstructingPreferredSizeWidget
                  : null;

          return CupertinoPageScaffold(
            navigationBar  : navBar,
            backgroundColor: widget.backgroundColor ??
                (version.designLanguage.contains('Liquid Glass')
                    ? const Color(0xFFF0F4F8)
                    : CupertinoColors.systemBackground),
            child: Stack(
              children: [
                widget.body,
                if (widget.bottomNavigationBar != null)
                  Positioned(
                    left  : 0,
                    right : 0,
                    bottom: 0,
                    child : widget.bottomNavigationBar!,
                  ),
              ],
            ),
          );

        case PlatformFamily.android:
          return Scaffold(
            appBar: widget.appBar != null
                ? PreferredSize(
                    preferredSize: widget.appBar!.preferredSize,
                    child        : widget.appBar!,
                  )
                : null,
            body               : widget.body,
            backgroundColor    : widget.backgroundColor,
            bottomNavigationBar: widget.bottomNavigationBar,
          );
      }
    },
  );
}
