import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaIcon].
void registerNaIconPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaIcon>(
    uiType,
    (BuildContext context, NaIcon widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      final NaUiType targetType = version.family == PlatformFamily.android
          ? NaUiType.material
          : NaUiType.cupertino;

      final iconData = widget.icon.resolve(targetType);

      final Color? effectiveColor = widget.color ??
          ((version == PlatformVersion.ios26 ||
                  version == PlatformVersion.ios27)
              ? const Color(0xFF007AFF)
              : null);

      return Icon(
        iconData,
        size : widget.size,
        color: effectiveColor,
      );
    },
  );
}
