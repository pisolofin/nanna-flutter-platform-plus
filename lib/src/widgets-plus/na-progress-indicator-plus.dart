import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaProgressIndicator].
void registerNaProgressIndicatorPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaProgressIndicator>(
    uiType,
    (BuildContext context, NaProgressIndicator widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      final NaProgressIndicatorOptions? options =
          widget.optionsBuilder?.call(context, uiType);
      final NaProgressIndicatorOptionsMaterial? materialOptions = options is NaProgressIndicatorOptionsMaterial
        ? options
        : null
      ;

      if (version.family == PlatformFamily.android) {
        return CircularProgressIndicator(
          value: materialOptions?.value,
          color: version == PlatformVersion.androidM2
              ? const Color(0xFF6200EE)
              : null,
        );
      }

      return CupertinoActivityIndicator(
        radius: (version == PlatformVersion.ios26 ||
                version == PlatformVersion.ios27)
            ? 12
            : 10,
      );
    },
  );
}
