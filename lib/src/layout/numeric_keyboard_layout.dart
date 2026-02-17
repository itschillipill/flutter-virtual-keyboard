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

    final rows = [
      ['1', '2', '3', '-'],
      ['4', '5', '6', 'space'],
      ['7', '8', '9', 'backspace'],
      [
        ',',
        '0+',
        '.',
        'action',
      ],
    ];

    return Material(
      color: theme.backgroundColor,
      borderRadius: theme.borderRadius,
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows.map((row) {
          return KeyboardRow(
            children: row.map((key) {
              switch (key) {
                case 'space':
                  return KeyboardKey.buildSpaceKey(widget.controller, flex: 1);
                case 'backspace':
                  return KeyboardKey.buildBackspaceKey(widget.controller);
                case 'action':
                  return KeyboardKey.buildActionKey(
                      widget.controller, widget.options.action);
                case '0+':
                  return KeyboardKey.buildCharKey(
                      KeyboardChar.symbol("0", ["+"]), widget.controller);
                default:
                  return KeyboardKey.buildCharKey(
                      KeyboardChar.symbol(key), widget.controller);
              }
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
