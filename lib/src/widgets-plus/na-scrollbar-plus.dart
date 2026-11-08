import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show Scrollbar;
import 'package:flutter/cupertino.dart' show CupertinoScrollbar;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaScrollbar].
void registerNaScrollbarPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaScrollbar>(
    uiType,
    (BuildContext context, NaScrollbar widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      if (version.family == PlatformFamily.android) {
        return Scrollbar(
          controller     : widget.controller,
          thumbVisibility: widget.thumbVisibility,
          child          : widget.child,
        );
      }

      return CupertinoScrollbar(
        controller     : widget.controller,
        thumbVisibility: widget.thumbVisibility,
        child          : widget.child,
      );
    },
  );
}
