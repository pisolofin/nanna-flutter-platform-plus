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
            child: Material(
              type : MaterialType.transparency,
              child: widget.bottomNavigationBar == null
                  ? widget.body
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children          : [
                        // Main body content occupying remaining viewport space
                        Expanded(
                          child: widget.body,
                        ),
                        // Dedicated bottom navigation bar container preventing content overlap
                        if (widget.bottomNavigationBar != null) ...[
                          widget.bottomNavigationBar!,
                        ],
                      ],
                    ),
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
