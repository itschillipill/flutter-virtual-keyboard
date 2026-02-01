enum KeyboardLanguage {
  en,
  ru;

  List<String> get characters => switch (this) {
        KeyboardLanguage.ru => ['йцукенгшщзхъ', 'фывапролджэ', 'ячсмитьбю'],
        KeyboardLanguage.en => ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'],
      };
}
