import 'package:flutter/material.dart';
import '../virtual_keyboard_controller.dart';
import '../../flutter_virtual_keyboard.dart';

enum KeyboardKeyType { character, icon }

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({super.key, required this.children});
  final Iterable<KeyboardKey> children;
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
  /// ===== CHARACTER KEY =====
  const KeyboardKey.character({
    required this.keyboardChar,
    required this.onTap,
    this.active = false,
    this.flex = 1,
    this.isUpperCase = false,
    super.key,
  })  : type = KeyboardKeyType.character,
        icon = null;

  /// ===== ICON KEY =====
  const KeyboardKey.icon({
    required this.icon,
    required this.onTap,
    this.active = false,
    this.flex = 1,
    super.key,
  })  : type = KeyboardKeyType.icon,
        keyboardChar = null,
        isUpperCase = false;

  final KeyboardKeyType type;

  final KeyboardChar? keyboardChar;
  final IconData? icon;

  final Function(String char)? onTap;
  final bool active;
  final int flex;
  final bool isUpperCase;

  bool get hasAdditional =>
      type == KeyboardKeyType.character &&
      keyboardChar!.additionalLower.isNotEmpty;

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();

  // ===== FACTORIES =====

  static KeyboardKey buildCharKey(
    KeyboardChar keyboardChar,
    VirtualKeyboardController controller, {
    bool isUpperCase = false,
  }) =>
      KeyboardKey.character(
        keyboardChar: keyboardChar,
        isUpperCase: isUpperCase,
        onTap: controller.insert,
      );

  static KeyboardKey buildSpaceKey(
    VirtualKeyboardController controller, {
    int flex = 5,
  }) =>
      KeyboardKey.icon(
        icon: Icons.space_bar_rounded,
        flex: flex,
        onTap: (_) => controller.insert(' '),
      );

  static KeyboardKey buildBackspaceKey(
    VirtualKeyboardController controller,
  ) =>
      KeyboardKey.icon(
        icon: Icons.backspace,
        onTap: (_) => controller.backspace,
      );

  static KeyboardKey buildActionKey(
    VirtualKeyboardController controller,
    KeyboardAction action,
  ) =>
      KeyboardKey.icon(
        icon: action.icon,
        onTap: (_) {
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
    int flex = 1,
  }) =>
      KeyboardKey.icon(
        icon: icon,
        onTap: (_) => onTap(),
        active: active,
        flex: flex,
      );
}

class _KeyboardKeyState extends State<KeyboardKey> {
  int _selectedIndex = -1;
  bool _isLongPressing = false;

  double _calculateMenuLeft(int charCount, double keyWidth) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0;

    final screenWidth = MediaQuery.of(context).size.width;
    final globalPos = renderBox.localToGlobal(Offset.zero);
    final menuWidth = charCount * 40.0 + 8;

    double left = (keyWidth / 2) - (menuWidth / 2);

    if (globalPos.dx + left + menuWidth > screenWidth) {
      left = screenWidth - globalPos.dx - menuWidth - 8;
    }

    if (globalPos.dx + left < 0) {
      left = -globalPos.dx + 8;
    }

    return left;
  }

  @override
  Widget build(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;

    // ===== ICON KEY =====
    if (widget.type == KeyboardKeyType.icon) {
      return Padding(
        padding: theme.padding,
        child: GestureDetector(
          onTap: () => widget.onTap?.call(""),
          child: _buildIconButton(),
        ),
      );
    }

    // ===== CHARACTER KEY =====
    final char = widget.isUpperCase
        ? widget.keyboardChar!.upper
        : widget.keyboardChar!.lower;

    final additional = widget.isUpperCase
        ? widget.keyboardChar!.additionalUpper
        : widget.keyboardChar!.additionalLower;

    return Padding(
      padding: theme.padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () => widget.onTap?.call(char),
                onLongPressStart: (_) {
                  if (widget.hasAdditional) {
                    setState(() {
                      _isLongPressing = true;
                      _selectedIndex = 0;
                    });
                  }
                },
                onLongPressMoveUpdate: (details) {
                  if (_isLongPressing) {
                    final menuLeft = _calculateMenuLeft(
                        additional.length, constraints.maxWidth);

                    final fingerX = details.localPosition.dx - menuLeft;
                    final newIndex =
                        (fingerX / 40).floor().clamp(0, additional.length - 1);

                    if (newIndex != _selectedIndex) {
                      setState(() => _selectedIndex = newIndex);
                    }
                  }
                },
                onLongPressEnd: (_) {
                  if (_isLongPressing) {
                    if (_selectedIndex != -1) {
                      widget.onTap?.call(additional.elementAt(_selectedIndex));
                    }
                    setState(() {
                      _isLongPressing = false;
                      _selectedIndex = -1;
                    });
                  }
                },
                child: _buildCharButton(char, additional),
              ),
              if (_isLongPressing)
                Positioned(
                  bottom: 55,
                  left: _calculateMenuLeft(
                      additional.length, constraints.maxWidth),
                  child: _buildPopup(additional, theme),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCharButton(String char, Iterable<String> additional) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: widget.active
            ? theme.backgroundColor.withValues(alpha: 0.9)
            : theme.backgroundColor,
        borderRadius: theme.borderRadius,
      ),
      child: Stack(
        children: [
          Center(
            child: Text(char, style: theme.textStyle),
          ),
          if (widget.hasAdditional)
            Positioned(
              top: 2,
              right: 4,
              child: Text(
                additional.first,
                style: theme.textStyle.copyWith(
                  fontSize: (theme.textStyle.fontSize ?? 18) * 0.6,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconButton() {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: widget.active
            ? theme.backgroundColor.withValues(alpha: 0.9)
            : theme.backgroundColor,
        borderRadius: theme.borderRadius,
      ),
      child: Center(
        child: Icon(
          widget.icon,
          color: theme.foregroundColor,
        ),
      ),
    );
  }

  Widget _buildPopup(Iterable<String> additional, KeyboardButtonTheme theme) {
    return Material(
      elevation: 4,
      color: theme.backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(additional.length, (i) {
            final isSel = _selectedIndex == i;
            return Container(
              width: 40,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSel ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                additional.elementAt(i),
                style: theme.textStyle.copyWith(
                  color: isSel ? Colors.white : theme.foregroundColor,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
