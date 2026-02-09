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
    this.additionalCharacters,
  });

  final String? label;
  final List<String>? additionalCharacters;
  final IconData? icon;
  final Function(String char)? onTap;
  final bool active;
  final int flex;

  bool get hasAdditional =>
      additionalCharacters != null && additionalCharacters!.isNotEmpty;

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();

  static KeyboardKey buildCharKey(
    String char,
    VirtualKeyboardController controller, {
    List<String>? additional,
  }) =>
      KeyboardKey(
        label: char,
        additionalCharacters: additional,
        onTap: controller.insert,
      );

  static KeyboardKey buildSpaceKey(
    VirtualKeyboardController controller, {
    int flex = 5,
  }) =>
      KeyboardKey(
        icon: Icons.space_bar_rounded,
        flex: flex,
        onTap: (_) => controller.insert(' '),
      );

  static KeyboardKey buildBackspaceKey(VirtualKeyboardController controller) =>
      KeyboardKey(
        icon: Icons.backspace,
        onTap: (_) => controller.backspace(),
      );

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
      KeyboardKey(
        icon: icon,
        onTap: (_) => onTap(),
        active: active,
      );
}

class _KeyboardKeyState extends State<KeyboardKey> {
  int _selectedIndex = -1;
  bool _isLongPressing = false;

  void _handleTap() {
    widget.onTap?.call(widget.label ?? '');
  }
 double _calculateMenuLeft(int charCount, double keyWidth) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0;

    final double screenWidth = MediaQuery.of(context).size.width;
    final Offset globalPos = renderBox.localToGlobal(Offset.zero);
    final double menuWidth = charCount * 40.0 + 8; // ширина кнопок + padding

    // Идеальная позиция (центрирование над клавишей)
    double left = (keyWidth / 2) - (menuWidth / 2);

    // Проверка правой границы экрана
    if (globalPos.dx + left + menuWidth > screenWidth) {
      left = screenWidth - globalPos.dx - menuWidth - 8; // 8 - отступ от края экрана
    }

    // Проверка левой границы экрана
    if (globalPos.dx + left < 0) {
      left = -globalPos.dx + 8;
    }

    return left;
  }

    @override
  Widget build(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;
    final allChars = widget.additionalCharacters??[];

    return Padding(
      padding: theme.padding,
      child: LayoutBuilder( 
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: _handleTap,
                onLongPressStart: (details) {
                  if (widget.hasAdditional) {
                    setState(() {
                      _isLongPressing = true;
                      _selectedIndex = 0;
                    });
                  }
                },
                onLongPressMoveUpdate: (details) {
                  if (_isLongPressing) {
                    double menuLeft = _calculateMenuLeft(allChars.length, constraints.maxWidth);
                    
                    double fingerXInMenu = details.localPosition.dx - menuLeft;
                    int newIndex = (fingerXInMenu / 40).floor().clamp(0, allChars.length - 1);
                    
                    if (newIndex != _selectedIndex) {
                      setState(() => _selectedIndex = newIndex);
                    }
                  }
                },
                onLongPressEnd: (details) {
                  if (_isLongPressing) {
                    if (_selectedIndex != -1) {
                      widget.onTap?.call(allChars[_selectedIndex]);
                    }
                    setState(() {
                      _isLongPressing = false;
                      _selectedIndex = -1;
                    });
                  }
                },
                child: _buildButton(context),
              ),
              if (_isLongPressing)
                Positioned(
                  bottom: 55,
                  // Динамически вычисляем отступ слева
                  left: _calculateMenuLeft(allChars.length, constraints.maxWidth),
                  child: Material(
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
                        children: List.generate(allChars.length, (i) {
                          bool isSel = _selectedIndex == i;
                          return Container(
                            width: 40,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel ? Colors.blue : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              allChars[i],
                              style: theme.textStyle.copyWith(
                                color: isSel ? Colors.white : theme.foregroundColor,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: widget.active
            ? theme.backgroundColor.withValues(alpha: 0.9)
            : theme.backgroundColor,
        borderRadius: theme.borderRadius,
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = VirtualKeyboardTheme.of(context).keyTheme;
    return Stack(
      children: [
        Center(
          child: widget.icon != null
              ? Icon(widget.icon, size: 24, color: theme.foregroundColor)
              : Text(widget.label ?? '', style: theme.textStyle),
        ),
        if (widget.hasAdditional && widget.label != null)
          Positioned(
            top: 2,
            right: 4,
            child: Text(
              widget.additionalCharacters!.first,
              style: theme.textStyle
                  .copyWith(fontSize: (theme.textStyle.fontSize ?? 18) * 0.6),
            ),
          ),
      ],
    );
  }
}
