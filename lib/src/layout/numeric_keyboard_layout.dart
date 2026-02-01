import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // layout как просили
    final rows = [
      ['1', '2', '3', '-'],
      ['4', '5', '6', 'space'],
      ['7', '8', '9', 'backspace'],
      [
        ',', // запятая
        '0+',
        '.', // точка
        'action',
      ],
    ];

    return Material(
      color: colorScheme.surface,
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
                  return KeyboardKey(
                    label: '0',
                    aditionalCharacters: const ['+'],
                    onTap: () => widget.controller.insert('0'),
                  );
                default:
                  return KeyboardKey.buildCharKey(key, widget.controller);
              }
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
