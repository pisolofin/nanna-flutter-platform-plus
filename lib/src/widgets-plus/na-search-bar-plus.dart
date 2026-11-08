import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show SearchBar;
import 'package:flutter/cupertino.dart' show CupertinoSearchTextField;

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
          if ((version == PlatformVersion.ios26) ||
              (version == PlatformVersion.ios27) ||
              (version == PlatformVersion.ipados26) ||
              (version == PlatformVersion.ipados27)) {
            // Liquid Glass SearchBar
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child       : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child : Container(
                  decoration: BoxDecoration(
                    color       : const Color(0x73FFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border      : Border.all(
                      color: const Color(0x99FFFFFF),
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
                    backgroundColor: const Color(0x00000000),
                    borderRadius   : BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          }
          return CupertinoSearchTextField(
            controller  : widget.controller,
            focusNode   : widget.focusNode,
            placeholder : widget.hintText ?? 'Cerca...',
            onChanged   : widget.onChanged,
            onSubmitted : widget.onSubmitted,
            onTap       : widget.onTap,
            borderRadius: BorderRadius.circular(version == PlatformVersion.ios18 ? 16 : 9),
          );

        case PlatformFamily.macOS:
          return CupertinoSearchTextField(
            controller  : widget.controller,
            focusNode   : widget.focusNode,
            placeholder : widget.hintText ?? 'Cerca...',
            onChanged   : widget.onChanged,
            onSubmitted : widget.onSubmitted,
            onTap       : widget.onTap,
            borderRadius: BorderRadius.circular(6),
          );

        case PlatformFamily.android:
          return SearchBar(
            controller: widget.controller,
            focusNode : widget.focusNode,
            hintText  : widget.hintText,
            onChanged : widget.onChanged,
            onTap     : widget.onTap,
            leading   : widget.leading ?? const NaIcon(NaIcons.search),
            elevation : const WidgetStatePropertyAll(0),
          );
      }
    },
  );
}
