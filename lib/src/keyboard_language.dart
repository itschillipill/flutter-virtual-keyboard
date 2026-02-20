class KeyboardChar {
  final String lower;
  final String upper;
  final Iterable<String> additionalLower;
  final Iterable<String> additionalUpper;

  const KeyboardChar(
      {required this.lower,
      required this.upper,
      this.additionalLower = const [],
      this.additionalUpper = const []});

  factory KeyboardChar.symbol(String char,
          [Iterable<String> additional = const []]) =>
      KeyboardChar(
          lower: char,
          upper: char,
          additionalLower: additional,
          additionalUpper: additional);

  @override
  String toString() =>
      'KeyboardChar(lower: $lower, upper: $upper, additionalLower: $additionalLower, additionalUpper: $additionalUpper)';
}

class KeyboardLanguageConfig {
  final String name;
  final Iterable<_KeyboardRow> rows; // Ряды клавиш

  const KeyboardLanguageConfig({
    required this.name,
    required this.rows,
  });
}

typedef _KeyboardRow = Iterable<KeyboardChar>;

KeyboardLanguageConfig numbers = KeyboardLanguageConfig(name: "Numbers", rows: [
  [
    KeyboardChar.symbol('1', ['!', '¹', '¡']),
    KeyboardChar.symbol('2', ['@', '²']),
    KeyboardChar.symbol('3', ['#', '³', '£']),
    KeyboardChar.symbol('4', ['\$', '€', '¥', '₽']),
    KeyboardChar.symbol('5', ['%', '‰']),
    KeyboardChar.symbol('6', ['^', '&']),
    KeyboardChar.symbol('7', ['&', '*', '⅞']),
    KeyboardChar.symbol('8', ['*', '×', '∞']),
    KeyboardChar.symbol('9', ['(', '[', '{']),
    KeyboardChar.symbol('0', [')', ']', '}', '°']),
  ]
]);


KeyboardLanguageConfig phoneLayout = KeyboardLanguageConfig(
  name: "Phone layout", 
  rows: [
    [
    KeyboardChar.symbol('1'),
    KeyboardChar.symbol('2'),
    KeyboardChar.symbol('3'),
    KeyboardChar.symbol("-")
    ],
    [
    KeyboardChar.symbol('4'),
    KeyboardChar.symbol('5'),
    KeyboardChar.symbol('6'),
    KeyboardChar.symbol('space')
    ],
    [
    KeyboardChar.symbol('7'),
    KeyboardChar.symbol('8'),
    KeyboardChar.symbol('9'),
    KeyboardChar.symbol('backspace')
    ],
    [
    KeyboardChar.symbol(','),
    KeyboardChar.symbol('0', ['+']),
    KeyboardChar.symbol('.'),
    KeyboardChar.symbol('action') 
    ]
]);


KeyboardChar dot = KeyboardChar.symbol(".", [',']);

class KeyboardLanguages {
  static const KeyboardLanguageConfig english = const KeyboardLanguageConfig(
    name: 'English',
    rows: [
      [
        KeyboardChar(lower: 'q', upper: 'Q'),
        KeyboardChar(lower: 'w', upper: 'W'),
        KeyboardChar(
          lower: 'e',
          upper: 'E',
          additionalLower: ['é', 'ê', 'ë', 'ē'],
          additionalUpper: ['É', 'Ê', 'Ë', 'Ē'],
        ),
        KeyboardChar(lower: 'r', upper: 'R'),
        KeyboardChar(lower: 't', upper: 'T'),
        KeyboardChar(lower: 'y', upper: 'Y'),
        KeyboardChar(
          lower: 'u',
          upper: 'U',
          additionalLower: ['ú', 'û', 'ü'],
          additionalUpper: ['Ú', 'Û', 'Ü'],
        ),
        KeyboardChar(
          lower: 'i',
          upper: 'I',
          additionalLower: ['í', 'î', 'ï'],
          additionalUpper: ['Í', 'Î', 'Ï'],
        ),
        KeyboardChar(
          lower: 'o',
          upper: 'O',
          additionalLower: ['ó', 'ô', 'ö'],
          additionalUpper: ['Ó', 'Ô', 'Ö'],
        ),
        KeyboardChar(lower: 'p', upper: 'P'),
      ],
      [
        KeyboardChar(
          lower: 'a',
          upper: 'A',
          additionalLower: ['á', 'à', 'â', 'ä'],
          additionalUpper: ['Á', 'À', 'Â', 'Ä'],
        ),
        KeyboardChar(lower: 's', upper: 'S'),
        KeyboardChar(lower: 'd', upper: 'D'),
        KeyboardChar(lower: 'f', upper: 'F'),
        KeyboardChar(lower: 'g', upper: 'G'),
        KeyboardChar(lower: 'h', upper: 'H'),
        KeyboardChar(lower: 'j', upper: 'J'),
        KeyboardChar(lower: 'k', upper: 'K'),
        KeyboardChar(lower: 'l', upper: 'L'),
      ],
      [
        KeyboardChar(lower: 'z', upper: 'Z'),
        KeyboardChar(lower: 'x', upper: 'X'),
        KeyboardChar(
          lower: 'c',
          upper: 'C',
          additionalLower: ['ç'],
          additionalUpper: ['Ç'],
        ),
        KeyboardChar(lower: 'v', upper: 'V'),
        KeyboardChar(lower: 'b', upper: 'B'),
        KeyboardChar(lower: 'n', upper: 'N'),
        KeyboardChar(lower: 'm', upper: 'M'),
      ],
    ],
  );

  static const KeyboardLanguageConfig russian = const KeyboardLanguageConfig(
    name: 'Russian',
    rows: [
      [
        KeyboardChar(lower: 'ц', upper: 'Ц'),
        KeyboardChar(lower: 'у', upper: 'У'),
        KeyboardChar(lower: 'к', upper: 'К'),
        KeyboardChar(
          lower: 'е',
          upper: 'Е',
          additionalLower: ['ё'],
          additionalUpper: ['Ё'],
        ),
        KeyboardChar(lower: 'н', upper: 'Н'),
        KeyboardChar(lower: 'г', upper: 'Г'),
        KeyboardChar(lower: 'ш', upper: 'Ш'),
        KeyboardChar(lower: 'щ', upper: 'Щ'),
        KeyboardChar(lower: 'з', upper: 'З'),
        KeyboardChar(lower: 'х', upper: 'Х'),
      ],
      [
        KeyboardChar(lower: 'ф', upper: 'Ф'),
        KeyboardChar(lower: 'ы', upper: 'Ы'),
        KeyboardChar(lower: 'в', upper: 'В'),
        KeyboardChar(lower: 'а', upper: 'А'),
        KeyboardChar(lower: 'п', upper: 'П'),
        KeyboardChar(lower: 'р', upper: 'Р'),
        KeyboardChar(lower: 'о', upper: 'О'),
        KeyboardChar(lower: 'л', upper: 'Л'),
        KeyboardChar(lower: 'д', upper: 'Д'),
        KeyboardChar(lower: 'ж', upper: 'Ж'),
        KeyboardChar(lower: 'э', upper: 'Э'),
      ],
      [
        KeyboardChar(lower: 'я', upper: 'Я'),
        KeyboardChar(lower: 'ч', upper: 'Ч'),
        KeyboardChar(lower: 'с', upper: 'С'),
        KeyboardChar(lower: 'м', upper: 'М'),
        KeyboardChar(
          lower: 'и',
          upper: 'И',
          additionalLower: ['й'],
          additionalUpper: ['Й'],
        ),
        KeyboardChar(lower: 'т', upper: 'Т'),
        KeyboardChar(
          lower: 'ь',
          upper: 'Ь',
          additionalLower: ['ъ'],
          additionalUpper: ['Ъ'],
        ),
        KeyboardChar(lower: 'б', upper: 'Б'),
        KeyboardChar(lower: 'ю', upper: 'Ю'),
      ],
    ],
  );
}
