import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoTextField;
import 'package:flutter/material.dart' show InputDecoration, OutlineInputBorder, TextField;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaTextField].
void registerNaTextFieldPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaTextField>(
    uiType,
    (BuildContext context, NaTextField widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      final NaTextFieldOptions? options =
          widget.optionsBuilder?.call(context, uiType);
      final NaTextFieldOptionsGeneric? genericOptions = options is NaTextFieldOptionsGeneric
        ? options
        : null
      ;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            // Liquid Glass text field
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child : Container(
                  decoration: BoxDecoration(
                    color       : const Color(0x80FFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border      : Border.all(
                      color: const Color(0xA6FFFFFF),
                      width: 1.2,
                    ),
                  ),
                  child: CupertinoTextField(
                    controller        : widget.controller,
                    focusNode         : widget.focusNode,
                    keyboardType      : widget.keyboardType,
                    textInputAction   : widget.textInputAction,
                    textCapitalization: widget.textCapitalization,
                    style             : widget.style,
                    textAlign         : widget.textAlign,
                    autofocus         : widget.autofocus,
                    readOnly          : widget.readOnly,
                    showCursor        : widget.showCursor,
                    obscureText       : widget.obscureText,
                    onChanged         : widget.onChanged,
                    onSubmitted       : widget.onSubmitted,
                    placeholder       : genericOptions?.placeholder,
                    decoration        : null,
                    padding           : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            );
          }
          return CupertinoTextField(
            controller        : widget.controller,
            focusNode         : widget.focusNode,
            keyboardType      : widget.keyboardType,
            textInputAction   : widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            style             : widget.style,
            textAlign         : widget.textAlign,
            autofocus         : widget.autofocus,
            readOnly          : widget.readOnly,
            showCursor        : widget.showCursor,
            obscureText       : widget.obscureText,
            onChanged         : widget.onChanged,
            onSubmitted       : widget.onSubmitted,
            placeholder       : genericOptions?.placeholder,
            decoration        : BoxDecoration(
              color       : CupertinoColors.tertiarySystemFill.resolveFrom(context),
              borderRadius: BorderRadius.circular(
                version == PlatformVersion.ios18 ? 14 : 8,
              ),
            ),
          );

        case PlatformFamily.macOS:
          return CupertinoTextField(
            controller        : widget.controller,
            focusNode         : widget.focusNode,
            keyboardType      : widget.keyboardType,
            textInputAction   : widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            style             : widget.style,
            textAlign         : widget.textAlign,
            autofocus         : widget.autofocus,
            readOnly          : widget.readOnly,
            showCursor        : widget.showCursor,
            obscureText       : widget.obscureText,
            onChanged         : widget.onChanged,
            onSubmitted       : widget.onSubmitted,
            placeholder       : genericOptions?.placeholder,
            decoration        : BoxDecoration(
              color       : CupertinoColors.tertiarySystemFill.resolveFrom(context),
              borderRadius: BorderRadius.circular(6),
              border      : Border.all(
                color: const Color(0xFFC7C7CC),
                width: 0.5,
              ),
            ),
          );

        case PlatformFamily.android:
          return TextField(
            controller        : widget.controller,
            focusNode         : widget.focusNode,
            keyboardType      : widget.keyboardType,
            textInputAction   : widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            style             : widget.style,
            textAlign         : widget.textAlign,
            autofocus         : widget.autofocus,
            readOnly          : widget.readOnly,
            showCursor        : widget.showCursor,
            obscureText       : widget.obscureText,
            onChanged         : widget.onChanged,
            onSubmitted       : widget.onSubmitted,
            decoration        : InputDecoration(
              hintText: genericOptions?.placeholder,
              border  : OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  version == PlatformVersion.androidMaterialYou
                      ? 24
                      : (version == PlatformVersion.androidM3 ? 16 : 4),
                ),
              ),
            ),
          );
      }
    },
  );
}
