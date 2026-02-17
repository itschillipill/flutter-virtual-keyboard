import 'package:flutter/material.dart';
import 'package:flutter_virtual_keyboard/src/virtual_keyboard_theme.dart';

import '../flutter_virtual_keyboard.dart' show VirtualKeyboardTextFieldState;
import 'virtual_keyboard_controller.dart';
import 'virtual_keyboard_widget.dart';

/// {@template vk_scope}
/// VirtualKeyboardScope widget.
/// {@endtemplate}
class VirtualKeyboardScope extends StatefulWidget {
  /// {@macro vk_scope}
  const VirtualKeyboardScope({super.key, required this.child, this.themeData});

  final Widget child;
  final VirtualKeyboardThemeData? themeData;

  static VirtualKeyboardController of(BuildContext context) {
    final scope = context.findAncestorStateOfType<_VirtualKeyboardScopeState>();
    assert(scope != null, 'VirtualKeyboardScope not found');
    return scope!._controller;
  }

  @override
  State<VirtualKeyboardScope> createState() => _VirtualKeyboardScopeState();
}

class _VirtualKeyboardScopeState extends State<VirtualKeyboardScope> {
  final VirtualKeyboardController _controller = VirtualKeyboardController();
  final _keyboardKey =
      GlobalKey<State<VirtualKeyboardWidget>>(debugLabel: "virtualKeyboard");
  VirtualKeyboardThemeData _defaultThemeData = VirtualKeyboardThemeData.light();

  bool _isPointerOnActiveField(
      Offset globalPosition, GlobalKey<VirtualKeyboardTextFieldState>? key) {
    if (key?.currentContext == null) return false;

    final renderBox = key!.currentContext?.findRenderObject();
    if (renderBox case RenderBox r) {
      final textField = r.localToGlobal(Offset.zero) & r.size;
      return textField.contains(globalPosition);
    }
    return false;
  }

  bool _isPointerOnKeyboard(Offset globalPosition) {
    if (_keyboardKey.currentContext == null) return false;

    final renderBox =
        _keyboardKey.currentContext!.findRenderObject() as RenderBox;
    final keyboardRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    return keyboardRect.contains(globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final isOpen = _controller.isOpen;
          double keyboardHeight = _controller.keyboardHeight;
          return PopScope(
            canPop: !isOpen,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop && isOpen) {
                _controller.hide(unfocusField: true);
              }
            },
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
                viewInsets: EdgeInsets.only(
                  bottom: isOpen ? keyboardHeight : 0,
                ),
              ),
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (event) {
                  if (_controller.activeFocus != null) {
                    final isOnKeyboard = _isPointerOnKeyboard(event.position) ||
                        _isPointerOnActiveField(
                            event.position, _controller.textFieldKey);
                    if (!isOnKeyboard) {
                      _controller.hide(unfocusField: true);
                    }
                  }
                },
                child: Stack(
                  children: [
                    widget.child,
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      left: 0,
                      right: 0,
                      bottom: isOpen ? 0 : -keyboardHeight * 2,
                      child: VirtualKeyboardTheme(
                        data: widget.themeData ?? _defaultThemeData,
                        child: VirtualKeyboardWidget(
                          key: _keyboardKey,
                          controller: _controller,
                          virtualKeyboardHeight: keyboardHeight,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
