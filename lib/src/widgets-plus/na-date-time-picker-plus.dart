import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builders for date and time pickers.
void registerNaDateTimePickerPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaDatePicker>(
    uiType,
    (BuildContext context, NaDatePicker widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
        case PlatformFamily.macOS:
          final picker = CupertinoDatePicker(
            mode             : CupertinoDatePickerMode.date,
            initialDateTime  : widget.initialDate,
            minimumDate      : widget.firstDate,
            maximumDate      : widget.lastDate,
            onDateTimeChanged: widget.onDateChanged,
          );

          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child : Container(
                  height    : 200,
                  decoration: BoxDecoration(
                    color       : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                    border      : Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 1.0,
                    ),
                  ),
                  child: picker,
                ),
              ),
            );
          }

          return SizedBox(height: 200, child: picker);

        case PlatformFamily.android:
          return CalendarDatePicker(
            initialDate  : widget.initialDate,
            firstDate    : widget.firstDate,
            lastDate     : widget.lastDate,
            onDateChanged: widget.onDateChanged,
          );
      }
    },
  );

  naPlatformServiceRegisterWidgetBuilder<NaTimePicker>(
    uiType,
    (BuildContext context, NaTimePicker widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      final picker = CupertinoTimerPicker(
        initialTimerDuration  : widget.initialTimerDuration,
        onTimerDurationChanged: widget.onTimerDurationChanged,
      );

      if (version.family == PlatformFamily.android) {
        return SizedBox(
          height: 200,
          child : picker,
        );
      }

      if (version == PlatformVersion.ios26 ||
          version == PlatformVersion.ios27) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child       : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child : Container(
              height    : 200,
              decoration: BoxDecoration(
                color       : Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(20),
                border      : Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1.0,
                ),
              ),
              child: picker,
            ),
          ),
        );
      }

      return SizedBox(height: 200, child: picker);
    },
  );
}
