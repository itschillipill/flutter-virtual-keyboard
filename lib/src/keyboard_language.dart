enum KeyboardLanguage {
  en,
  ru;

  List<String> get characters => switch (this) {
        KeyboardLanguage.ru => ['йцукенгшщзхъ', 'фывапролджэ', 'ячсмитьбю'],
        KeyboardLanguage.en => ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'],
      };

  Map<String, List<String>> get additional => switch (this) {
        KeyboardLanguage.en => {
            'e': ['é', 'ê', 'ë', 'ē'],
            'a': ['á', 'à', 'â', 'ä'],
            'i': ['í', 'î', 'ï'],
            'o': ['ó', 'ô', 'ö'],
            'u': ['ú', 'û', 'ü'],
            'c': ['ç'],
            
            '1': ['!', '¹'],
            '2': ['@', '²'],
            '3': ['#', '³'],
            '4': ['\$', '₴'],
            '5': ['%', '/'],
            '6': ['^', '&'],
            '7': ['&', '*'],
            '8': ['*', '×'],
            '9': ['(', ')'],
            '0': ['+', '='],
        },
        KeyboardLanguage.ru => {
            'е': ['ё'],
            'ь': ['ъ'],
            'и': ['й'],
            '1': ['!'],
            '2': ['"'],
            '3': ['№'],
            '4': [';'],
            '5': ['%'],
            '6': [':'],
            '7': ['?'],
            '8': ['*'],
            '9': ['('],
            '0': [')'],
        },
      };
}
