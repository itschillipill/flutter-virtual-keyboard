import 'package:flutter/material.dart';
import 'package:flutter_virtual_keyboard/src/keyboard_language.dart';
import 'package:flutter_virtual_keyboard/src/virtual_keyboard_theme.dart';

import '../virtual_keyboard_controller.dart';
import '../virtual_keyboard_options.dart';
import '../widgets/key.dart';

class NumericKeyboardLayout extends StatefulWidget {
  const NumericKeyboardLayout({
    super.key,
    required this.controller,
    required this.options,
  });

  final VirtualKeyboardController controller;
  final VirtualKeyboardOptions options;

  @override
  State<NumericKeyboardLayout> createState() => _NumericKeyboardLayoutState();
}

class _NumericKeyboardLayoutState extends State<NumericKeyboardLayout> {
@override
  Widget build(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context);

    return Material(
      color: theme.backgroundColor,
      borderRadius: theme.borderRadius,
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: phoneLayout.rows.map((row) {
          return KeyboardRow(
            children: row.map((key) {
              switch (key.lower) {
                case 'space':
                  return KeyboardKey.buildSpaceKey(flex: 1);
                case 'backspace':
                  return KeyboardKey.buildBackspaceKey();
                case 'action':
                  return KeyboardKey.buildActionKey(widget.options.action);
                default:
                  return KeyboardKey.buildCharKey(key);
              }
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
