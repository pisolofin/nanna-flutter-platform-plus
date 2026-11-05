import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanna_platform/nanna_platform.dart';

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaSearchBar].
void registerNaSearchBarPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaSearchBar>(
    uiType,
    (BuildContext context, NaSearchBar widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          if (version == PlatformVersion.ios26 ||
              version == PlatformVersion.ios27 ||
              version == PlatformVersion.ipados26 ||
              version == PlatformVersion.ipados27) {
            // Liquid Glass SearchBar
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child : Container(
                  decoration: BoxDecoration(
                    color       : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                    border      : Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 1.0,
                    ),
                  ),
                  child: CupertinoSearchTextField(
                    controller     : widget.controller,
                    focusNode      : widget.focusNode,
                    placeholder    : widget.hintText ?? 'Cerca...',
                    onChanged      : widget.onChanged,
                    onSubmitted    : widget.onSubmitted,
                    onTap          : widget.onTap,
                    backgroundColor: Colors.transparent,
                    borderRadius   : BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          }
          return CupertinoSearchTextField(
            controller  : widget.controller,
            focusNode   : widget.focusNode,
            placeholder : widget.hintText,
            onChanged   : widget.onChanged,
            onSubmitted : widget.onSubmitted,
            onTap       : widget.onTap,
            borderRadius: BorderRadius.circular(
              version == PlatformVersion.ios18 ? 16 : 10,
            ),
          );

        case PlatformFamily.macOS:
          return CupertinoSearchTextField(
            controller  : widget.controller,
            focusNode   : widget.focusNode,
            placeholder : widget.hintText,
            onChanged   : widget.onChanged,
            onSubmitted : widget.onSubmitted,
            onTap       : widget.onTap,
            borderRadius: BorderRadius.circular(6),
          );

        case PlatformFamily.android:
          return SearchBar(
            controller : widget.controller,
            focusNode  : widget.focusNode,
            hintText   : widget.hintText,
            leading    : widget.leading ?? const Icon(Icons.search),
            onChanged  : widget.onChanged,
            onSubmitted: widget.onSubmitted,
            onTap      : widget.onTap,
            elevation  : WidgetStateProperty.all(
              version == PlatformVersion.androidM2 ? 2.0 : 0.0,
            ),
            backgroundColor: WidgetStateProperty.all(
              version == PlatformVersion.androidMaterialYou
                  ? const Color(0xFFE8EDF4)
                  : const Color(0xFFF7F2FA),
            ),
          );
      }
    },
  );
}
