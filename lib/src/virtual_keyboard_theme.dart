import 'package:flutter/material.dart';

class VirtualKeyboardThemeData {
  final KeyboardButtonTheme keyTheme;
  final Color backgroundColor;
  final Border border;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  VirtualKeyboardThemeData(
      {required this.keyTheme,
      required this.backgroundColor,
      required this.border,
      required this.borderRadius,
      required this.padding});
}

class KeyboardButtonTheme {
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Border border;

  KeyboardButtonTheme(
      {required this.backgroundColor,
      required this.foregroundColor,
      required this.textStyle,
      required this.borderRadius,
      required this.padding,
      required this.border});
}

class VirtualKeyboardTheme extends InheritedWidget {
  const VirtualKeyboardTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final VirtualKeyboardThemeData data;

  static VirtualKeyboardThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<VirtualKeyboardTheme>();
    assert(theme != null, 'VirtualKeyboardTheme not found');
    return theme!.data;
  }

  @override
  bool updateShouldNotify(VirtualKeyboardTheme oldWidget) {
    return data != oldWidget.data;
  }
}