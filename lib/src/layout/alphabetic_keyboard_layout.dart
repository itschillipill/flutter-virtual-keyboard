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
  late KeyboardLanguage _currentLanguage;
  // ignore: unused_field
  List<String>? _suggestions;

  bool _isUppercase = false;
  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.options.initialLanguage;
    _suggestions = widget.options.suggestionBuilder?.call(
      widget.controller.value.text,
    );
  }

  @override
  void didUpdateWidget(covariant AlphabeticKeyboardLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Если initialLanguage изменился
    if (oldWidget.options.initialLanguage != widget.options.initialLanguage ||
        !_availableLanguages(oldWidget.options).contains(_currentLanguage)) {
      _currentLanguage = widget.options.initialLanguage;
      _isUppercase = false;
    }
  }

  static const String _getNumberRow = "1234567890";
  
  List<String> _getLayoutRows() {
    if (_isUppercase) {
      return _currentLanguage.characters.map((e) => e.toUpperCase()).toList();
    }
    return _currentLanguage.characters;
  }

  List<KeyboardLanguage> _availableLanguages(VirtualKeyboardOptions options) {
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
    final rows = _getLayoutRows();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color: theme.backgroundColor,
          borderRadius: theme.borderRadius,
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: itschillipill/ implement suggestions
              KeyboardRow(
                children: _getNumberRow
                    .split('')
                    .map((e) => KeyboardKey.buildCharKey(e, widget.controller))
                    .toList(),
              ),
              // === Буквенные ряды ===
              for (String row in rows.sublist(0, rows.length - 1))
                KeyboardRow(
                  children: row
                      .split('')
                      .map(
                          (e) => KeyboardKey.buildCharKey(e, widget.controller))
                      .toList(),
                ),

              // === Ряд: Caps + Backspace ===
              KeyboardRow(
                children: [
                  KeyboardKey.buildIconKey(
                    icon: Icons.keyboard_capslock,
                    onTap: _toggleUppercase,
                    active: _isUppercase,
                  ),
                  ...rows.last.split('').map(
                      (e) => KeyboardKey.buildCharKey(e, widget.controller)),
                  KeyboardKey.buildIconKey(
                    icon: Icons.backspace,
                    onTap: widget.controller.backspace,
                  ),
                ],
              ),

              // === Нижний ряд ===
              KeyboardRow(
                children: [
                  KeyboardKey.buildIconKey(
                    icon: Icons.emoji_emotions_rounded,
                    onTap: () {},
                  ),
                  if (widget.options.additionalLanguages.isNotEmpty)
                    KeyboardKey.buildIconKey(
                      icon: Icons.language,
                      onTap: _toggleLanguage,
                    ),
                  KeyboardKey.buildSpaceKey(widget.controller),
                  KeyboardKey.buildActionKey(
                      widget.controller, widget.options.action),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
