import 'package:code_entry_field/code_entry_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character Entry Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _characters = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Code Entry Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Enter the characters:'),
            const SizedBox(height: 20),
            CodeEntryField(
              characterCount: 6,
              onChanged: (characters) {
                setState(() {
                  _characters = characters.join();
                });
              },
              boxSize: Size(50, 50),
              initialCharacters: ['1', '2', '3'],
              style: CodeEntryFieldStyle.Default.copyWith(
                boxBackgroundColor: Colors.grey.withAlpha(50),
              ),
              capitalization: Capitalization.alwaysAllcaps,
            ),
            const SizedBox(height: 20),
            Text(
              'Entered characters: $_characters',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
