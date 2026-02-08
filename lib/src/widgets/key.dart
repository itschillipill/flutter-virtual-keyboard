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

    bool get hasAdditional =>
      additionalCharacters != null && additionalCharacters!.isNotEmpty;

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
        icon: Icons.space_bar_rounded,
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
  void _handleTap() {
    final value = widget.label ?? '';
    if (widget.onTap != null) {
      widget.onTap!(value);
    }
  }

  Widget _buildContent(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: widget.icon != null
              ? Icon(
                  widget.icon,
                  size: 24,
                  color: theme.foregroundColor,
                )
              : Text(
                  widget.label ?? '',
                  style: theme.textStyle,
                ),
        ),

        if (widget.hasAdditional && widget.label != null)
          Align(
            alignment: Alignment.topRight,
            child: Text(
                  widget.additionalCharacters!.join(''),
                  style: theme.textStyle,
                ),
          ),
      ],
    );
  }
    Widget _buildWithPieMenu(BuildContext context) {
    final pieTheme =
        widget.pieMenuTheme ?? VirtualKeyboardTheme.of(context).pieTheme.toPieTheme();

    return PieMenu(
      theme: pieTheme,
      actions: _buildPieActions(),
      child: _buildButton(context),
    );
  }

  List<PieAction> _buildPieActions() {
    return widget.additionalCharacters!
        .map(
          (char) => PieAction(
            tooltip: Text(char),
            onSelect: () => widget.onTap?.call(char),
            child: Center(
              child: Text(
                char,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildButton(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;

    return Material(
      color: widget.active
          ? theme.backgroundColor.withValues(alpha: 0.9)
          : theme.backgroundColor,
      borderRadius: theme.borderRadius,
      elevation: widget.active ? 4 : 0,
      child: InkWell(
        borderRadius: theme.borderRadius,
        onTap: _handleTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: _buildContent(context),
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
        child: widget.hasAdditional
            ? _buildWithPieMenu(context)
            : _buildButton(context),
      ),
    );
  }
}