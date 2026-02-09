import 'package:flutter/material.dart';

import 'layout/alphabetic_keyboard_layout.dart';
import 'layout/numeric_keyboard_layout.dart';
import 'virtual_keyboard_controller.dart';
import 'virtual_keyboard_options.dart';

final class VirtualKeyboardWidget extends StatefulWidget {
  const VirtualKeyboardWidget({
    super.key,
    required this.controller,
    required this.virtualKeyboardHeight,
  });

  final double virtualKeyboardHeight;
  final VirtualKeyboardController controller;

  @override
  State<VirtualKeyboardWidget> createState() => _VirtualKeyboardWidgetState();
}

class _VirtualKeyboardWidgetState extends State<VirtualKeyboardWidget> {
  late VirtualKeyboardOptions _options;

  @override
  void initState() {
    super.initState();
    _init();
    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    _init();
    setState(() {});
  }

  void _init() {
    _options = widget.controller.options;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Durations.medium1,
      child: switch (_options.type) {
        VirtualKeyboardType.alphabetic => AlphabeticKeyboardLayout(
            controller: widget.controller,
            options: _options,
          ),
        VirtualKeyboardType.numeric => NumericKeyboardLayout(
            controller: widget.controller,
            options: _options,
          ),
        _ => const Center(
            child: Material(child: Text("not implemented yet")),
          )
      },
    );
  }
}
