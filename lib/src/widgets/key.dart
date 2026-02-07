import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';

import '../../flutter_virtual_keyboard.dart';
import '../virtual_keyboard_controller.dart';

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({super.key, required this.children});

  final List<KeyboardKey> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children:
            children.map((e) => Expanded(flex: e.flex, child: e)).toList(),
      ),
    );
  }
}

class KeyboardKey extends StatefulWidget {
  const KeyboardKey({
    super.key,
    this.label,
    this.icon,
    this.onTap,
    this.active = false,
    this.flex = 1,
    this.additionalCharacters,
    this.showPieOnlyWhenHasAdditional = true,
    this.pieMenuTheme,
  });

  final String? label;
  final List<String>? additionalCharacters;
  final IconData? icon;
  final Function(String char)? onTap;
  final bool active;
  final int flex;
  final bool showPieOnlyWhenHasAdditional;
  final PieTheme? pieMenuTheme;

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();

  static KeyboardKey buildCharKey(
    String char,
    VirtualKeyboardController controller, {
    List<String>? additional,
    bool showPieOnlyWhenHasAdditional = true,
    PieTheme? pieTheme,
  }) =>
      KeyboardKey(
        label: char,
        additionalCharacters: additional,
        showPieOnlyWhenHasAdditional: showPieOnlyWhenHasAdditional,
        pieMenuTheme: pieTheme,
        onTap: controller.insert,
      );

  static KeyboardKey buildSpaceKey(
    VirtualKeyboardController controller, {
    int flex = 5,
    PieTheme? pieTheme,
  }) =>
      KeyboardKey(
        label: 'ПРОБЕЛ',
        flex: flex,
        pieMenuTheme: pieTheme,
        onTap: (_) => controller.insert(' '),
      );

  static KeyboardKey buildBackspaceKey(
    VirtualKeyboardController controller, {
    PieTheme? pieTheme,
  }) =>
      KeyboardKey(
        icon: Icons.backspace,
        pieMenuTheme: pieTheme,
        onTap: (_) => controller.backspace(),
      );

  static KeyboardKey buildActionKey(
    VirtualKeyboardController controller,
    KeyboardAction action, {
    PieTheme? pieTheme,
  }) =>
      KeyboardKey.buildIconKey(
        icon: action.icon,
        pieTheme: pieTheme,
        onTap: () {
          switch (action) {
            case KeyboardAction.newLine:
              controller.insert('\n');
              break;
            case KeyboardAction.search:
            case KeyboardAction.done:
              controller.submit();
              break;
          }
        },
      );

  static KeyboardKey buildIconKey({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
    PieTheme? pieTheme,
  }) =>
      KeyboardKey(
        icon: icon,
        pieMenuTheme: pieTheme,
        onTap: (_) => onTap(),
        active: active,
      );
}

class _KeyboardKeyState extends State<KeyboardKey> {
  bool _shouldShowPieMenu() {
    if (widget.showPieOnlyWhenHasAdditional) {
      return widget.additionalCharacters != null &&
          widget.additionalCharacters!.isNotEmpty;
    }
    return true;
  }

  Widget _buildPieMenuContent(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;
    final hasAdditionalChars = widget.additionalCharacters != null &&
        widget.additionalCharacters!.isNotEmpty;

    return Material(
      color: widget.active
          ? theme.backgroundColor.withValues(alpha: 0.9)
          : theme.backgroundColor,
      borderRadius: theme.borderRadius,
      elevation: widget.active ? 4 : 0,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Основной контент
            widget.icon != null
                ? Icon(
                    widget.icon,
                    color: theme.foregroundColor,
                    size: 24,
                  )
                : Text(
                    widget.label ?? '',
                    style: theme.textStyle,
                  ),

            // Индикатор дополнительных символов (маленький значок в углу)
            if (hasAdditionalChars && widget.label != null)
              Positioned(
                top: 4,
                right: 6,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.foregroundColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    size: 8,
                    color: theme.backgroundColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularButton(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;
    final hasAdditionalChars = widget.additionalCharacters != null &&
        widget.additionalCharacters!.isNotEmpty;

    return Material(
      color: widget.active
          ? theme.backgroundColor.withOpacity(0.9)
          : theme.backgroundColor,
      borderRadius: theme.borderRadius,
      elevation: widget.active ? 4 : 0,
      child: InkWell(
        borderRadius: theme.borderRadius,
        onTap: () {
          final char = widget.label ?? '';
          if (char.isNotEmpty && widget.onTap != null) {
            widget.onTap!(char);
          } else if (widget.icon != null && widget.onTap != null) {
            widget.onTap!('');
          }
        },
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Основной контент
              widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: theme.foregroundColor,
                      size: 24,
                    )
                  : Text(
                      widget.label ?? '',
                      style: theme.textStyle,
                    ),

              // Индикатор дополнительных символов (маленький значок в углу)
              if (hasAdditionalChars && widget.label != null)
                Positioned(
                  top: 4,
                  right: 6,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: theme.foregroundColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      size: 8,
                      color: theme.backgroundColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;
    
    return Padding(
      padding: theme.padding,
      child: SizedBox(
        height: 48,
        child: _shouldShowPieMenu()
            ? PieMenu(
                theme: VirtualKeyboardTheme.of(context).pieTheme.toPieTheme(),
                actions: _buildPieActions(),
                onPressed: () {
                  final char = widget.label ?? '';
                  if (char.isNotEmpty && widget.onTap != null) {
                    widget.onTap!(char);
                  }
                },
                child: _buildPieMenuContent(context),
              )
            : _buildRegularButton(context),
      ),
    );
  }

  List<PieAction> _buildPieActions() {
    if (widget.additionalCharacters == null ||
        widget.additionalCharacters!.isEmpty) {
      return [];
    }

    return widget.additionalCharacters!
        .map(
          (char) => PieAction(
            tooltip: Text(
              char,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            onSelect: () {
              if (widget.onTap != null) {
                widget.onTap!(char);
              }
            },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                char,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
