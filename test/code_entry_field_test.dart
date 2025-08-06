import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:code_entry_field/code_entry_field.dart';

void main() {
  testWidgets('CodeEntryField renders with correct number of boxes',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CodeEntryField(
            characterCount: 4,
            onChanged: (characters) {},
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(4));
  });

  testWidgets('onChanged callback is called with correct characters',
      (WidgetTester tester) async {
    List<String> characters = [];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CodeEntryField(
            characterCount: 4,
            onChanged: (newCharacters) {
              characters = newCharacters;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField).first);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
  });

  testWidgets('initialCharacters are displayed correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CodeEntryField(
            characterCount: 4,
            initialCharacters: ['A', 'B', 'C', 'D'],
            onChanged: (characters) {},
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
  });

  testWidgets('Capitalization.alwaysAllcaps works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CodeEntryField(
            characterCount: 4,
            onChanged: (characters) {},
            capitalization: Capitalization.alwaysAllcaps,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField).first);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();

    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('Capitalization.alwaysSmall works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CodeEntryField(
            characterCount: 4,
            onChanged: (characters) {},
            capitalization: Capitalization.alwaysSmall,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField).first);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();

    expect(find.text('a'), findsOneWidget);
  });

  testWidgets('Backspace key works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CodeEntryField(
            characterCount: 4,
            initialCharacters: ['A', 'B'],
            onChanged: (characters) {},
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField).at(1));
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();

    expect(find.text('B'), findsNothing);
  });

  testWidgets('Navigation keys work correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CodeEntryField(
            characterCount: 4,
            onChanged: (characters) {},
          ),
        ),
      ),
    );

    final firstTextField = find.byType(TextField).first;
    final secondTextField = find.byType(TextField).at(1);

    await tester.tap(firstTextField);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(FocusManager.instance.primaryFocus, tester.widget<TextField>(secondTextField).focusNode);
  });
}
