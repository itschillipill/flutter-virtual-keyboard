import 'dart:ui' as ui;

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'virtual_keyboard_options.dart';
import 'virtual_keyboard_scope.dart';

class VirtualKeyboardTextField extends StatefulWidget {
  VirtualKeyboardTextField({
    super.key,
    this.groupId = EditableText,
    this.keyboardOptions = VirtualKeyboardOptions.def,
    this.undoController,
    this.decoration = const InputDecoration(),
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.readOnly = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.selectionHeightStyle,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionWidthStyle,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.restorationId,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.hintLocales,
    required this.controller,
  })  : assert(obscuringCharacter.length == 1),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        // Assert the following instead of setting it directly to avoid surprising the user by silently changing the value they set.
        assert(
          !(keyboardOptions.action == KeyboardAction.newLine && maxLines == 1),
          "VirtualKeyboardTextField: must be maxLines > 1 when action == KeyboardAction.newLine",
        );

  final TextEditingController controller;
  final VirtualKeyboardOptions keyboardOptions;
  final InputDecoration decoration;
  final Object groupId;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final String obscuringCharacter;
  final bool obscureText;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final Color? cursorColor;
  final ui.BoxHeightStyle? selectionHeightStyle;
  final ui.BoxWidthStyle? selectionWidthStyle;
  final EdgeInsets scrollPadding;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final bool stylusHandwritingEnabled;
  final bool enableIMEPersonalizedLearning;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final UndoHistoryController? undoController;
  final List<Locale>? hintLocales;

  @override
  State<VirtualKeyboardTextField> createState() =>
      _VirtualKeyboardTextFieldState();
}

class _VirtualKeyboardTextFieldState extends State<VirtualKeyboardTextField>
    implements TextSelectionGestureDetectorBuilderDelegate {
  late final FocusNode _focusNode;
  late ScrollController _scrollController;
  final GlobalKey<EditableTextState> _key = GlobalKey<EditableTextState>();
  late _TextFieldSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocus);
    _scrollController = widget.scrollController ?? ScrollController();
    _selectionGestureDetectorBuilder =
        _TextFieldSelectionGestureDetectorBuilder(state: this);
  }

  void _handleFocus() {
    if (widget.readOnly) return;

    final vk = VirtualKeyboardScope.of(context);

    if (_focusNode.hasFocus) {
      vk.attach(
        widget.controller,
        _focusNode,
        widget.keyboardOptions,
        _key,
        scrollController: _scrollController,
        onSubmitted: widget.onSubmitted,
      );
    }
    setState(() {});
  }

  bool get isEditing =>
      VirtualKeyboardScope.of(context).activeFocus == _focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputDecorator(
      decoration: widget.decoration,
      isFocused: _focusNode.hasFocus,
      isEmpty: widget.controller.text.isEmpty,
      child: _selectionGestureDetectorBuilder.buildGestureDetector(
        child: EditableText(
          key: _key,
          restorationId: widget.restorationId,
          groupId: widget.groupId,
          undoController: widget.undoController,
          controller: widget.controller,
          focusNode: _focusNode,
          readOnly: true,
          stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
          enableInteractiveSelection: true,
          selectionControls:
              widget.selectionControls ?? materialTextSelectionControls,
          hintLocales: widget.hintLocales,
          showCursor: true,
          forceLine: true,
          autofocus: false,
          backgroundCursorColor: theme.disabledColor,
          style: widget.style ??
              theme.textTheme.bodyLarge ??
              const TextStyle(fontSize: 16),
          cursorColor: widget.cursorColor ?? theme.primaryColor,
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorOpacityAnimates: widget.cursorOpacityAnimates ?? true,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          textCapitalization: widget.textCapitalization,
          selectionColor: (widget.cursorColor ?? theme.primaryColor),
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          scrollController: _scrollController,
          scrollPhysics: widget.scrollPhysics ?? const ClampingScrollPhysics(),
          scrollPadding: widget.scrollPadding,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          onEditingComplete: widget.onEditingComplete,
          inputFormatters: widget.inputFormatters,
          dragStartBehavior: widget.dragStartBehavior,
          rendererIgnoresPointer: false,
          paintCursorAboveText: true,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          contextMenuBuilder:
              widget.contextMenuBuilder ?? _defaultContextMenuBuilder,
          selectionWidthStyle:
              widget.selectionWidthStyle ?? ui.BoxWidthStyle.tight,
          selectionHeightStyle:
              widget.selectionHeightStyle ?? ui.BoxHeightStyle.tight,
          strutStyle: widget.strutStyle,
          autofillHints: widget.autofillHints,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
        ),
      ),
    );
  }

  Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  GlobalKey<EditableTextState> get editableTextKey => _key;

  @override
  bool get forcePressEnabled => true;

  @override
  bool get selectionEnabled => true;
}

class _TextFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _TextFieldSelectionGestureDetectorBuilder(
      {required _VirtualKeyboardTextFieldState state})
      : _state = state,
        super(delegate: state);

  final _VirtualKeyboardTextFieldState _state;

  @override
  bool get onUserTapAlwaysCalled => _state.widget.onTapAlwaysCalled;

  @override
  void onUserTap() {
    _state.widget.onTap?.call();
  }
}
