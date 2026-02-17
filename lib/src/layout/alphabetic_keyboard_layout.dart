import 'package:flutter/material.dart';
import 'package:flutter_virtual_keyboard/src/virtual_keyboard_theme.dart';

import '../keyboard_language.dart';
import '../virtual_keyboard_controller.dart';
import '../virtual_keyboard_options.dart';
import '../widgets/key.dart';

class AlphabeticKeyboardLayout extends StatefulWidget {
  const AlphabeticKeyboardLayout({
    super.key,
    required this.controller,
    required this.options,
  });

  final VirtualKeyboardController controller;
  final VirtualKeyboardOptions options;

  @override
  State<AlphabeticKeyboardLayout> createState() =>
      _AlphabeticKeyboardLayoutState();
}

class _AlphabeticKeyboardLayoutState extends State<AlphabeticKeyboardLayout> {
  late KeyboardLanguageConfig _currentLanguage;
  bool _isUppercase = false;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.options.initialLanguage;
  }

  @override
  void didUpdateWidget(covariant AlphabeticKeyboardLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.options.initialLanguage != widget.options.initialLanguage ||
        !_availableLanguages(oldWidget.options).contains(_currentLanguage)) {
      _currentLanguage = widget.options.initialLanguage;
      _isUppercase = false;
    }
  }

  List<KeyboardLanguageConfig> _availableLanguages(
      VirtualKeyboardOptions options) {
    return [
      options.initialLanguage,
      ...options.additionalLanguages,
    ];
  }

  void _toggleLanguage() {
    final availableLanguages = _availableLanguages(widget.options);
    final currentIndex = availableLanguages.indexOf(_currentLanguage);
    final nextIndex = (currentIndex + 1) % availableLanguages.length;
    setState(() {
      _currentLanguage = availableLanguages[nextIndex];
    });
  }

  void _toggleUppercase() {
    setState(() {
      _isUppercase = !_isUppercase;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context);
    final rows = _currentLanguage.rows;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color: theme.backgroundColor,
          borderRadius: theme.borderRadius,
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== Ряд цифр =====
              KeyboardRow(
                  children: numbers.rows.first.map(
                (e) => KeyboardKey.buildCharKey(
                  e,
                ),
              )),

              // ===== Буквенные ряды =====
              for (int i = 0; i < rows.length - 1; i++)
                KeyboardRow(
                  children: rows.elementAt(i).map(
                        (char) => KeyboardKey.buildCharKey(
                            char,
                            isUpperCase: _isUppercase),
                      ),
                ),

              // ===== Ряд: Caps + Последний буквенный ряд + Backspace =====
              KeyboardRow(
                children: [
                  KeyboardKey.buildIconKey(
                    icon: Icons.keyboard_capslock,
                    onTap:_toggleUppercase,
                    active: _isUppercase,
                  ),
                  ...rows.last.map(
                    (char) => KeyboardKey.buildCharKey(char, isUpperCase: _isUppercase),
                  ),
                  KeyboardKey.buildBackspaceKey(),
                ],
              ),

              // ===== Нижний ряд =====
              KeyboardRow(
                children: [
                  KeyboardKey.buildCharKey(KeyboardChar.symbol(".", [","])),
                  if (widget.options.type == VirtualKeyboardType.email)
                    KeyboardKey.buildCharKey(KeyboardChar.symbol('@')),
                  if (widget.options.additionalLanguages.isNotEmpty)
                    KeyboardKey.buildIconKey(
                      icon: Icons.language,
                      onTap:_toggleLanguage,
                    ),
                  KeyboardKey.buildSpaceKey(),
                  KeyboardKey.buildActionKey(widget.options.action),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
