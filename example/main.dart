import 'package:flutter/material.dart';
import 'package:flutter_vitual_keyboard/virtual_keyboard.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'Virtual Keyboard Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const KeyboardTestPage(),
      builder: (context, child) => VirtualKeyboardScope(child: child!),
    );
  }
}

class KeyboardTestPage extends StatefulWidget {
  const KeyboardTestPage({super.key});

  @override
  State<KeyboardTestPage> createState() => _KeyboardTestPageState();
}

class _KeyboardTestPageState extends State<KeyboardTestPage> {
  final controllers = <VirtualKeyboardType, TextEditingController>{
    VirtualKeyboardType.alphabetic: TextEditingController(),
    VirtualKeyboardType.numeric: TextEditingController(),
    VirtualKeyboardType.phone: TextEditingController(),
    VirtualKeyboardType.email: TextEditingController(),
  };

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  VirtualKeyboardOptions getOptions(VirtualKeyboardType type) {
    switch (type) {
      case VirtualKeyboardType.alphabetic:
        return const VirtualKeyboardOptions(
          initialLanguage: KeyboardLanguage.ru,
          additionalLanguages: [KeyboardLanguage.en],
          type: VirtualKeyboardType.alphabetic,
          action: KeyboardAction.done,
        );
      case VirtualKeyboardType.numeric:
        return const VirtualKeyboardOptions(
          type: VirtualKeyboardType.numeric,
          action: KeyboardAction.done,
        );
      case VirtualKeyboardType.phone:
        return const VirtualKeyboardOptions(
          type: VirtualKeyboardType.phone,
          action: KeyboardAction.done,
        );
      case VirtualKeyboardType.email:
        return const VirtualKeyboardOptions(
          initialLanguage: KeyboardLanguage.en,
          type: VirtualKeyboardType.email,
          action: KeyboardAction.done,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.read<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Keyboard Test"),
        actions: [
          IconButton(
            icon: Icon(
              themeController.isDark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () => themeController.toggle(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: VirtualKeyboardType.values.map((type) {
            final controller = controllers[type]!;
            final options = getOptions(type);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "${type.name.toUpperCase()} Keyboard",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Options: "
                        "initialLanguage=${options.initialLanguage.name}, "
                        "additionalLanguages=[${options.additionalLanguages.map((e) => e.name).join(', ')}], "
                        "action=${options.action.name}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      VirtualKeyboardTextField(
                        controller: controller,
                        keyboardOptions: options,
                        maxLines:
                            type == VirtualKeyboardType.alphabetic ? 2 : 1,
                        onSubmitted: (value) =>
                            debugPrint("${type.name} submitted: $value"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ThemeController extends ChangeNotifier {
  bool isDark = false;

  void toggle() {
    isDark = !isDark;
    notifyListeners();
  }
}
