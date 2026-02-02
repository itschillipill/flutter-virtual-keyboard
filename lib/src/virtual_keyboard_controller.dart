import 'package:flutter/material.dart';

import 'virtual_keyboard_options.dart';
import 'virtual_keyboard_text_field.dart' show VirtualKeyboardTextFieldState;

final class VirtualKeyboardController extends ChangeNotifier {
  TextEditingController? _active;
  ScrollController? _scrollController;
  FocusNode? activeFocus;
  VirtualKeyboardOptions _currentOptions = VirtualKeyboardOptions.def;
  TextEditingValue _value = TextEditingValue.empty;
  VoidCallback? _textListener;
  void Function(String value)? _onSubmitted;
  GlobalKey<VirtualKeyboardTextFieldState>? _aciveTextFieldKey;
  GlobalKey<EditableTextState>? _editableTextKey;

  static const double SUGGESTION_ROW_HIEGHT = 50;

  TextEditingValue get value => _value;
  VirtualKeyboardOptions get options => _currentOptions;
  GlobalKey<VirtualKeyboardTextFieldState>? get textFieldKey =>
      _aciveTextFieldKey;

  double get keyboardHeight =>
      _currentOptions.type.height +
      (_currentOptions.hasSuggestions ? SUGGESTION_ROW_HIEGHT : 0);

  // === Attach ===
  void attach(
    TextEditingController controller,
    FocusNode focusNode,
    VirtualKeyboardOptions options,
    GlobalKey<EditableTextState> editableKey,
    GlobalKey<VirtualKeyboardTextFieldState> key, {
    ScrollController? scrollController,
    void Function(String value)? onSubmitted,
  }) {
    if (_active == controller &&
        activeFocus == focusNode &&
        _currentOptions == options &&
        _scrollController == scrollController &&
        _onSubmitted == onSubmitted &&
        _aciveTextFieldKey == key &&
        _editableTextKey == editableKey) {
      return;
    }
    _active?.removeListener(_textListener ?? () {});

    _active = controller;
    activeFocus = focusNode;
    _currentOptions = options;
    _scrollController = scrollController;
    _onSubmitted = onSubmitted;
    _aciveTextFieldKey = key;
    _editableTextKey = editableKey;

    _textListener = () {
      _value = controller.value;
      notifyListeners();
    };

    controller.addListener(_textListener!);

    _value = controller.value;
    _scrollToCaret();
    notifyListeners();
  }

  void detach() {
    _active?.removeListener(_textListener ?? () {});
    _active = null;
    activeFocus = null;
    _currentOptions = VirtualKeyboardOptions.def;
    _scrollController = null;
    _onSubmitted = null;
    _aciveTextFieldKey = null;
    _editableTextKey = null;
    _value = TextEditingValue.empty;
    notifyListeners();
  }

  bool get isOpen => _active != null;

  // === Submit ===
  void submit() {
    if (_active == null) return;
    _onSubmitted?.call(_active!.text);
    hide(unfocusField: true);
  }

  // === Вставка текста ===
  void insert(String text) {
    if (_active == null) return;

    final controller = _active!;
    final value = controller.value;
    final selection = value.selection;

    final newText = value.text.replaceRange(
      selection.start,
      selection.end,
      text,
    );

    final newSelectionIndex = selection.start + text.length;

    controller.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
      composing: TextRange.empty,
    );
    _scrollToCaret();
    notifyListeners();
  }

  // === Backspace ===
  void backspace() {
    if (_active == null) return;

    final controller = _active!;
    final value = controller.value;
    final selection = value.selection;

    if (selection.start == 0 && selection.end == 0) return;

    final start = selection.start == selection.end
        ? selection.start - 1
        : selection.start;

    final newText = value.text.replaceRange(start, selection.end, '');

    controller.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start),
      composing: TextRange.empty,
    );
    _scrollToCaret();
    notifyListeners();
  }

  // === Hide ===
  void hide({bool unfocusField = false}) {
    if (unfocusField) activeFocus?.unfocus();
    detach();
  }

  void _scrollToCaret() {
    final key = _editableTextKey;
    if (key == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final EditableTextState? state = key.currentState;
      if (state == null) return;

      final selection = state.widget.controller.selection;
      if (!selection.isValid) return;

      state.bringIntoView(selection.extent);
    });
  }
}
