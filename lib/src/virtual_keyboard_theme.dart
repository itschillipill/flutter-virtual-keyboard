import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';

class VirtualKeyboardThemeData {
  final KeyboardButtonTheme keyTheme;
  final VirtualKeyboardPieTheme pieTheme;
  final Color backgroundColor;
  final Border border;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const VirtualKeyboardThemeData({
    required this.keyTheme,
    required this.pieTheme,
    required this.backgroundColor,
    required this.border,
    required this.borderRadius,
    required this.padding,
  });

  // Стандартные темы
  factory VirtualKeyboardThemeData.light() {
    return VirtualKeyboardThemeData(
      keyTheme: KeyboardButtonTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.all(2),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      pieTheme: const VirtualKeyboardPieTheme(
        buttonBackgroundColor: Colors.blue,
        buttonIconColor: Colors.white,
        radius: 120,
      ),
      backgroundColor: Colors.grey.shade100,
      border: Border.all(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(8),
    );
  }

  factory VirtualKeyboardThemeData.dark() {
    return VirtualKeyboardThemeData(
      keyTheme: KeyboardButtonTheme(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.all(2),
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      pieTheme: const VirtualKeyboardPieTheme(
        buttonBackgroundColor: Colors.blueAccent,
        buttonIconColor: Colors.white,
        radius: 120,
      ),
      backgroundColor: Colors.grey.shade900,
      border: Border.all(color: Colors.grey.shade800, width: 1),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(8),
    );
  }

  factory VirtualKeyboardThemeData.material(ColorScheme colorScheme) {
    return VirtualKeyboardThemeData(
      keyTheme: KeyboardButtonTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.all(2),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      pieTheme: VirtualKeyboardPieTheme(
        buttonBackgroundColor: colorScheme.primary,
        buttonIconColor: colorScheme.onPrimary,
        radius: 120,
      ),
      backgroundColor: colorScheme.surfaceContainerHighest,
      border: Border.all(color: colorScheme.outlineVariant, width: 1),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(8),
    );
  }
}

class KeyboardButtonTheme {
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Border border;

  const KeyboardButtonTheme({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.textStyle,
    required this.borderRadius,
    required this.padding,
    required this.border,
  });
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

class VirtualKeyboardPieTheme {
  final Color buttonBackgroundColor;
  final Color buttonIconColor;
  final double radius;
  final double buttonSize;
  final Color pointerColor;
  final Color overlayColor;

  const VirtualKeyboardPieTheme({
    this.buttonBackgroundColor = Colors.white,
    this.buttonIconColor = Colors.black,
    this.radius = 100,
    this.buttonSize = 48,
    this.pointerColor = Colors.white,
    this.overlayColor = const Color(0x10000000),
  });

  PieTheme toPieTheme() {
    return PieTheme(
      radius: radius,
      buttonTheme: PieButtonTheme(
        backgroundColor: buttonBackgroundColor,
        iconColor: buttonIconColor,
      ),
      overlayStyle: PieOverlayStyle.around,
      buttonSize: buttonSize,
      pointerColor: pointerColor,
      overlayColor: overlayColor,
    );
  }
}
