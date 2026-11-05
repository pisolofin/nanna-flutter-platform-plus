import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaSlider].
void registerNaSliderPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaSlider>(
    uiType,
    (BuildContext context, NaSlider widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      final NaSliderOptions? options =
          widget.optionsBuilder?.call(context, uiType);
      final int? divisions = options is NaSliderOptionsMaterial
          ? options.divisions
          : (options is NaSliderOptionsCupertino ? options.divisions : null);

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
        case PlatformFamily.macOS:
          return CupertinoSlider(
            value      : widget.value,
            onChanged  : widget.onChanged,
            min        : widget.min,
            max        : widget.max,
            divisions  : divisions,
            activeColor: version == PlatformVersion.ios26 ||
                    version == PlatformVersion.ios27
                ? const Color(0xFF0A84FF)
                : CupertinoColors.activeBlue,
          );

        case PlatformFamily.android:
          return Slider(
            value      : widget.value,
            onChanged  : widget.onChanged,
            min        : widget.min,
            max        : widget.max,
            divisions  : divisions,
            activeColor: version == PlatformVersion.androidM2
                ? const Color(0xFF6200EE)
                : null,
          );
      }
    },
  );
}
