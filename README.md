Готовый файл `README.md` для вашего пакета:

---

# Virtual Keyboard (WIP)

⚠️ **Work in progress / Experimental**

Custom virtual keyboard for Flutter applications.  
Designed for cases where application UI theme must fully control keyboard appearance.

---

## 📦 Installation

### 1. Add dependency

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_virtual_keyboard:
    git:
      url: https://github.com/itschillipill/flutter-virtual-keyboard.git
```

Then run:

```bash
flutter pub get
```

---

### 2. Import the package

```dart
import 'package:flutter_virtual_keyboard/flutter_virtual_keyboard.dart';
```

---

## 🚀 Quick Start

Wrap your **home screen** with `VirtualKeyboardScope` **inside** `MaterialApp`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_virtual_keyboard/flutter_virtual_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtual Keyboard Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system, // or your custom theme controller
      home: VirtualKeyboardScope(
        // Optional: custom theme
        themeData: VirtualKeyboardThemeData.light(), // or .dark()
        child: const KeyboardTestPage(),
      ),
    );
  }
}

class KeyboardTestPage extends StatelessWidget {
  const KeyboardTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: VirtualKeyboardTextField(
          controller: TextEditingController(),
          decoration: const InputDecoration(
            hintText: 'Tap to open keyboard',
          ),
        ),
      ),
    );
  }
}
```

---

## 🎨 Theming

You can provide custom theme data:

```dart
VirtualKeyboardScope(
  themeData: VirtualKeyboardThemeData(
    // your theme
  ),
  child: YourApp(),
)
```

Built-in themes:
- `VirtualKeyboardThemeData.light()`
- `VirtualKeyboardThemeData.dark()`
- `VirtualKeyboardThemeData.material(ColorScheme colorScheme)`

---

## 🧩 Core Components

| Component | Description |
|----------|-------------|
| `VirtualKeyboardScope` | **Required**. Wraps your app and provides keyboard functionality |
| `VirtualKeyboardTextField` | Text field that triggers the virtual keyboard |
| `VirtualKeyboardController` | Programmatically control keyboard visibility |
| `VirtualKeyboardThemeData` | Custom theme configuration |

---

## 🕹️ Controller Usage

```dart
final controller = VirtualKeyboardController();

// Show keyboard
controller.show();

// Hide keyboard
controller.hide();

// Check if keyboard is open
bool isOpen = controller.isOpen;

// Get keyboard height
double height = controller.keyboardHeight;
```

Access controller anywhere:

```dart
final controller = VirtualKeyboardScope.of(context);
```

---

## ❗ Important Notes

✅ **Do's:**
- Always wrap your app with `VirtualKeyboardScope`
- Place `VirtualKeyboardScope` **inside** `MaterialApp` (not in `builder`)
- Use `VirtualKeyboardTextField` instead of default `TextField` for Virtual Keyboard
- U can still use native keyboard by using default `TextField`

❌ **Don'ts:**
- Don't place `VirtualKeyboardScope` outside `MaterialApp`
- Don't use multiple `VirtualKeyboardScope` instances
- Don't expect system keyboard features (autocorrect, IME, etc.)

---

## ⚠️ Limitations

This package **does NOT replace system keyboard** due to OS limitations:

- ❌ No native autocorrect
- ❌ No IME features
- ❌ No system language handling
- ❌ No OS-level prediction
- ❌ No third-party keyboard support

Keyboard works **only inside the application**.

---

## ✅ Implemented

- Alphabetic keyboard layout
- Numeric keyboard layout
- App-based theming
- Custom controller
- Keyboard scope
- Animated show / hide
- Long-press additional characters

---

## 🚧 In Progress / Planned

- Accessibility improvements
- Performance optimizations
- Suggestions builder

---

## 🎯 Intended Use Cases

✅ **Recommended for:**
- Numeric / PIN input
- Calculators
- Terminals and POS systems
- Kiosk applications
- Controlled enterprise apps
- Custom branded keyboards

❌ **Not recommended for:**
- Full text input replacement
- Messaging apps
- Editors and word processors
- IME-like behavior
- Multilingual heavy input

---

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Android | ✅ Tested |
| iOS | ⚠️ Not tested |
| Web | ✅ Tested |
| Windows | ✅ Tested |
| macOS | ⚠️ Not tested |
| Linux | ⚠️ Not tested |

Technically in all platforms shoud work.

---

## 📄 License

MIT

---

## Contributing

This package is under active development.  
Feel free to open issues or submit PRs on [GitHub](https://github.com/itschillipill/flutter-virtual-keyboard).

---

**Made with ❤️ by [itschillipill](https://github.com/itschillipill)**