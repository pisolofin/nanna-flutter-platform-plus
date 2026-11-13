import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:nanna_platform/nanna_platform.dart';
import 'package:flutter/material.dart' show SearchBar;
import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoSearchTextField;

import '../models/platform-target.dart';
import '../services/platform-version-controller.dart';

/// Registers the version-aware widget builder for [NaSearchBar].
void registerNaSearchBarPlus(NaUiType uiType) {
  naPlatformServiceRegisterWidgetBuilder<NaSearchBar>(
    uiType,
    (BuildContext context, NaSearchBar widget) {
      final PlatformVersion version =
          PlatformVersionController.instance.currentVersion;
      final Object? rawOptions                  = widget.options;
      final NaSearchBarOptions? resolvedOptions = (rawOptions is NaSearchBarOptions)
        ? rawOptions
        : widget.optionsBuilder?.call(context, uiType)
      ;
      final Widget effectiveLeading = widget.leading ?? const NaIcon(NaIcons.search);

      switch (version.family) {
        case PlatformFamily.iOS:
        case PlatformFamily.iPadOS:
          final NaSearchBarOptionsCupertino? cupertinoOptions =
              (resolvedOptions is NaSearchBarOptionsCupertino) ? resolvedOptions : null;

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
                    prefixIcon     : effectiveLeading,
                    onChanged      : widget.onChanged,
                    onSubmitted    : widget.onSubmitted,
                    onTap          : widget.onTap,
                    backgroundColor: const Color(0x00000000),
                    borderRadius   : BorderRadius.circular(20),
                    padding        : cupertinoOptions?.padding ??
                        const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                    itemColor: cupertinoOptions?.itemColor ?? CupertinoColors.systemGrey2,
                    itemSize : cupertinoOptions?.itemSize ?? 20.0,
                  ),
                ),
              ),
            );
          }

          return CupertinoSearchTextField(
            controller  : widget.controller,
            focusNode   : widget.focusNode,
            placeholder : widget.hintText ?? 'Cerca...',
            prefixIcon  : effectiveLeading,
            onChanged   : widget.onChanged,
            onSubmitted : widget.onSubmitted,
            onTap       : widget.onTap,
            decoration  : cupertinoOptions?.decoration,
            borderRadius: BorderRadius.circular(version == PlatformVersion.ios18 ? 16 : 9),
            padding     : cupertinoOptions?.padding ??
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            itemColor: cupertinoOptions?.itemColor ?? CupertinoColors.systemGrey2,
            itemSize : cupertinoOptions?.itemSize ?? 20.0,
          );

        case PlatformFamily.macOS:
          final NaSearchBarOptionsCupertino? cupertinoOptions =
              (resolvedOptions is NaSearchBarOptionsCupertino) ? resolvedOptions : null;

          return CupertinoSearchTextField(
            controller  : widget.controller,
            focusNode   : widget.focusNode,
            placeholder : widget.hintText ?? 'Cerca...',
            prefixIcon  : effectiveLeading,
            onChanged   : widget.onChanged,
            onSubmitted : widget.onSubmitted,
            onTap       : widget.onTap,
            decoration  : cupertinoOptions?.decoration,
            borderRadius: BorderRadius.circular(6),
            padding     : cupertinoOptions?.padding ??
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            itemColor: cupertinoOptions?.itemColor ?? CupertinoColors.systemGrey2,
            itemSize : cupertinoOptions?.itemSize ?? 20.0,
          );

        case PlatformFamily.android:
          final NaSearchBarOptionsMaterial? materialOptions =
              (resolvedOptions is NaSearchBarOptionsMaterial) ? resolvedOptions : null;

          return SearchBar(
            controller     : widget.controller,
            focusNode      : widget.focusNode,
            hintText       : widget.hintText,
            leading        : effectiveLeading,
            trailing       : materialOptions?.trailing,
            onChanged      : widget.onChanged,
            onSubmitted    : widget.onSubmitted,
            onTap          : widget.onTap,
            backgroundColor: materialOptions?.backgroundColor,
            elevation      : materialOptions?.elevation ?? const WidgetStatePropertyAll(0),
            constraints    : materialOptions?.constraints,
          );
      }
    },
  );
}
