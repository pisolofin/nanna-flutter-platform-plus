import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show AlertDialog, TextButton;
import 'package:flutter/cupertino.dart' show CupertinoAlertDialog, CupertinoDialogAction;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builders for dialog components.
void registerNaDialogPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaAlertDialog>(
    uiType,
    (BuildContext context, NaAlertDialog widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            // Liquid Glass Dialog
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child : CupertinoAlertDialog(
                title  : widget.title,
                content: widget.content,
                actions: widget.actions ?? [],
              ),
            );
          }
          return CupertinoAlertDialog(
            title  : widget.title,
            content: widget.content,
            actions: widget.actions ?? [],
          );

        case PlatformFamily.macOS:
          return CupertinoAlertDialog(
            title  : widget.title,
            content: widget.content,
            actions: widget.actions ?? [],
          );

        case PlatformFamily.android:
          return AlertDialog(
            title  : widget.title,
            content: widget.content,
            actions: widget.actions,
            shape  : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                version == PlatformVersion.androidMaterialYou
                    ? 28
                    : (version == PlatformVersion.androidM3 ? 20 : 4),
              ),
            ),
          );
      }
    },
  );

  naPlatformServiceRegisterWidgetBuilder<NaDialogAction>(
    uiType,
    (BuildContext context, NaDialogAction widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      if (version.family == PlatformFamily.android) {
        return TextButton(
          onPressed: widget.onPressed,
          child    : widget.child,
        );
      }

      final NaDialogActionOptions? options =
          widget.optionsBuilder?.call(context, uiType);
      final NaDialogActionOptionsCupertino? cupertinoOptions = options is NaDialogActionOptionsCupertino
        ? options
        : null
      ;

      return CupertinoDialogAction(
        onPressed          : widget.onPressed,
        isDefaultAction    : cupertinoOptions?.isDefaultAction ?? false,
        isDestructiveAction: cupertinoOptions?.isDestructiveAction ?? false,
        child              : widget.child,
      );
    },
  );
}
