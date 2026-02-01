import 'package:flutter/material.dart';

import 'keyboard_language.dart';

typedef SuggestionBuilder = List<String> Function(String value);

class VirtualKeyboardOptions {
  final KeyboardLanguage initialLanguage;
  final List<KeyboardLanguage> additionalLanguages;
  final VirtualKeyboardType type;
  final KeyboardAction action;
  final SuggestionBuilder? suggestionBuilder;

  const VirtualKeyboardOptions({
    this.initialLanguage = KeyboardLanguage.ru,
    this.additionalLanguages = const [],
    this.type = VirtualKeyboardType.alphabetic,
    this.action = KeyboardAction.done,
    this.suggestionBuilder,
  });

  static const def = VirtualKeyboardOptions(
    initialLanguage: KeyboardLanguage.ru,
    additionalLanguages: [KeyboardLanguage.en],
    type: VirtualKeyboardType.alphabetic,
    action: KeyboardAction.done,
    suggestionBuilder: null,
  );

  VirtualKeyboardOptions copyWith({
    KeyboardLanguage? initialLanguage,
    List<KeyboardLanguage>? additionalLanguages,
    VirtualKeyboardType? type,
    KeyboardAction? action,
    SuggestionBuilder? suggestionBuilder,
  }) {
    return VirtualKeyboardOptions(
      initialLanguage: initialLanguage ?? this.initialLanguage,
      additionalLanguages: additionalLanguages ?? this.additionalLanguages,
      type: type ?? this.type,
      action: action ?? this.action,
      suggestionBuilder: suggestionBuilder ?? this.suggestionBuilder,
    );
  }

  bool get hasSuggestions => suggestionBuilder != null;
  bool get isNumeric => type == VirtualKeyboardType.numeric;
}

enum VirtualKeyboardType { alphabetic, numeric, phone, email }

extension KeyboardHeightX on VirtualKeyboardType {
  double get height {
    switch (this) {
      case VirtualKeyboardType.alphabetic:
        return 280;
      case VirtualKeyboardType.numeric:
        return 210;
      case _:
        return 50;
    }
  }
}

enum KeyboardAction {
  newLine(icon: Icons.keyboard_return),
  search(icon: Icons.search),
  done(icon: Icons.done);

  final IconData icon;
  const KeyboardAction({required this.icon});
}
