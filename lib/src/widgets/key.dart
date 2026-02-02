import 'package:flutter/material.dart';

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
    this.aditionalCharacters,
  });

  final String? label;
  final List<String>? aditionalCharacters;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool active;
  final int flex;

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();

  static KeyboardKey buildCharKey(
          String char, VirtualKeyboardController controller,
          {List<String>? additional}) =>
      KeyboardKey(
        label: char,
        aditionalCharacters: additional,
        onTap: () => controller.insert(char),
      );

  static KeyboardKey buildSpaceKey(VirtualKeyboardController controller,
          {int flex = 5}) =>
      KeyboardKey(
          label: 'space', flex: flex, onTap: () => controller.insert(' '));

  static KeyboardKey buildBackspaceKey(VirtualKeyboardController controller) =>
      KeyboardKey(icon: Icons.backspace, onTap: () => controller.backspace());

  static KeyboardKey buildActionKey(
          VirtualKeyboardController controller, KeyboardAction action) =>
      KeyboardKey.buildIconKey(
        icon: action.icon,
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
  }) =>
      KeyboardKey(icon: icon, onTap: onTap, active: active);
}

class _KeyboardKeyState extends State<KeyboardKey> {
  OverlayEntry? _overlayEntry;

  void _showAdditionalKeys(BuildContext context, Offset position) {
    // TODO: itschillipill/ show additional keys
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPressStart: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          _showAdditionalKeys(context, position);
        },
        onLongPressEnd: (_) => _removeOverlay(),
        child: Material(
          color: widget.active
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            child: SizedBox(
              height: 48,
              child: Center(
                child: widget.icon != null
                    ? Icon(widget.icon)
                    : Text(widget.label!, style: theme.textTheme.titleMedium),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
