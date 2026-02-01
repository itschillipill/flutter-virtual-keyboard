import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'virtual_keyboard_controller.dart';
import 'virtual_keyboard_widget.dart';

/// {@template vk_scope}
/// VirtualKeyboardScope widget.
/// {@endtemplate}
class VirtualKeyboardScope extends StatefulWidget {
  /// {@macro vk_scope}
  const VirtualKeyboardScope({super.key, required this.child});

  final Widget child;

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

  bool _isPointerOnCurrentTextField(
      Offset globalPosition, FocusNode activeFocus) {
    if (_keyboardKey.currentContext == null || activeFocus.context == null) {
      return false;
    }
    final renderBox = activeFocus.context!.findRenderObject() as RenderBox;
    final textField = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    return textField.contains(globalPosition);
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final isOpen = _controller.isOpen;
        // ignore: prefer_const_declarations
        double keyboardHeight = 300;
        // ignore: deprecated_member_use
        return PopScope(
          canPop: !_controller.isOpen,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && _controller.isOpen) {
              _controller.hide();
            }
          },
          child: Directionality(
            textDirection: TextDirection.ltr,
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
                        _isPointerOnCurrentTextField(
                            event.position, _controller.activeFocus!);
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
                      curve: Curves.easeOut,
                      left: 0,
                      right: 0,
                      bottom: isOpen ? 0 : -keyboardHeight,
                      child: VirtualKeyboardWidget(
                        key: _keyboardKey,
                        controller: _controller,
                        virtualKeyboardHeight: keyboardHeight,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
