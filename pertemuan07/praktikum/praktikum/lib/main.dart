import 'package:flutter/material.dart';
import 'package:praktikum/bottom_navbar.dart';
import 'package:praktikum/input_form.dart';
import 'package:praktikum/input_validation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: false),
      home: DynamicBottomNavbar(),
    );
  }
}

class MyInput extends StatefulWidget {
  const MyInput({super.key});

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  final TextEditingController _controller = TextEditingController();

  bool lightOn = false;
  String? language;
  bool agree = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showLanguageSnackbar() {
    if (language != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected: $language'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void showAgreeSnackbar(bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Agree' : 'Disagree'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Widget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Write your name here...',
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Hello, ${_controller.text}!'),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            // Switch Widget
            Switch(
              value: lightOn,
              onChanged: (bool value) {
                setState(() {
                  lightOn = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(lightOn ? 'Light On' : 'Light Off'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // RadioListTile untuk bahasa
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Dart'),
                  value: 'Dart',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showLanguageSnackbar();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Kotlin'),
                  value: 'Kotlin',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showLanguageSnackbar();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Swift'),
                  value: 'Swift',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showLanguageSnackbar();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Agree / Disagree'),
                  value: agree,
                  onChanged: (bool? value) {
                    setState(() {
                      agree = value!;
                      showAgreeSnackbar(agree);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}