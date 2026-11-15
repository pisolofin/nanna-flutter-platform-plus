import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/ui-type-plus.dart';
import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaApp].
void registerNaAppPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaApp>(
    uiType,
    (BuildContext context, NaApp widget) {
      if (uiType == NaUiTypePlus.materialVersioned) {
        return widget.renderForUIType(context, NaUiType.material) ??
            const SizedBox.shrink();
      }

      if (uiType == NaUiTypePlus.cupertinoVersioned) {
        return widget.renderForUIType(context, NaUiType.cupertino) ??
            const SizedBox.shrink();
      }

      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;
      final NaUiType targetType = version.family == PlatformFamily.android
          ? NaUiType.material
          : NaUiType.cupertino;

      return widget.renderForUIType(context, targetType) ??
          const SizedBox.shrink();
    },
  );
}

