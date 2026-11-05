import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaTextField].
void registerNaTextFieldPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaTextField>(
    uiType,
    (BuildContext context, NaTextField widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27 ||
              version == PlatformVersion.ipados26 ||
              version == PlatformVersion.ipados27) {
            // Liquid Glass text field
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child : Container(
                  decoration: BoxDecoration(
                    color       : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border      : Border.all(
                      color: Colors.white.withValues(alpha: 0.65),
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
                    autocorrect       : widget.autocorrect,
                    enableSuggestions : widget.enableSuggestions,
                    maxLines          : widget.maxLines,
                    minLines          : widget.minLines,
                    expands           : widget.expands,
                    maxLength         : widget.maxLength,
                    onChanged         : widget.onChanged,
                    onEditingComplete : widget.onEditingComplete,
                    onSubmitted       : widget.onSubmitted,
                    inputFormatters   : widget.inputFormatters,
                    enabled           : widget.enabled ?? true,
                    padding           : const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical  : 12,
                    ),
                    decoration: null,
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
            autocorrect       : widget.autocorrect,
            enableSuggestions : widget.enableSuggestions,
            maxLines          : widget.maxLines,
            minLines          : widget.minLines,
            expands           : widget.expands,
            maxLength         : widget.maxLength,
            onChanged         : widget.onChanged,
            onEditingComplete : widget.onEditingComplete,
            onSubmitted       : widget.onSubmitted,
            inputFormatters   : widget.inputFormatters,
            enabled           : widget.enabled ?? true,
            decoration        : BoxDecoration(
              color       : CupertinoColors.tertiarySystemFill.resolveFrom(context),
              borderRadius: BorderRadius.circular(
                version == PlatformVersion.ios18 ? 14 : 8,
              ),
            ),
          );

        case PlatformFamily.macOS:
          return CupertinoTextField(
            controller     : widget.controller,
            focusNode      : widget.focusNode,
            keyboardType   : widget.keyboardType,
            textInputAction: widget.textInputAction,
            style          : widget.style,
            textAlign      : widget.textAlign,
            autofocus      : widget.autofocus,
            readOnly       : widget.readOnly,
            showCursor     : widget.showCursor,
            obscureText    : widget.obscureText,
            maxLines       : widget.maxLines,
            minLines       : widget.minLines,
            onChanged      : widget.onChanged,
            onSubmitted    : widget.onSubmitted,
            padding        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration     : BoxDecoration(
              color       : CupertinoColors.tertiarySystemFill.resolveFrom(context),
              borderRadius: BorderRadius.circular(6),
            ),
          );

        case PlatformFamily.android:
          final double radius = version == PlatformVersion.androidMaterialYou
              ? 24.0
              : (version == PlatformVersion.androidM3 ? 16.0 : 4.0);
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
            autocorrect       : widget.autocorrect,
            enableSuggestions : widget.enableSuggestions,
            maxLines          : widget.maxLines,
            minLines          : widget.minLines,
            expands           : widget.expands,
            maxLength         : widget.maxLength,
            onChanged         : widget.onChanged,
            onEditingComplete : widget.onEditingComplete,
            onSubmitted       : widget.onSubmitted,
            inputFormatters   : widget.inputFormatters,
            enabled           : widget.enabled,
            decoration        : InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              filled   : version != PlatformVersion.androidM2,
              fillColor: version == PlatformVersion.androidMaterialYou
                  ? const Color(0xFFE8EDF4)
                  : const Color(0xFFF7F2FA),
            ),
          );
      }
    },
  );
}
