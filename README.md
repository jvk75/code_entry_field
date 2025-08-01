# Code Entry Field

A Flutter widget for entering single characters at a time in a series of boxes.

![Example](images/example.png)

## Features

*   Enter single characters in a series of boxes.
*   Focus moves to the next box automatically.
*   Backspace clears the current box or moves to the previous box.
*   Tab and enter keys move focus to the next box.
*   Supports only letters and numbers.
*   Customizable number of character boxes.
*   Callback for when the characters change.

## Getting started

To use this widget, add `code_entry_field` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Usage

```dart
import 'package:code_entry_field/code_entry_field.dart';

CodeEntryField(
  characterCount: 6,
  onChanged: (characters) {
    print(characters);
  },
  cornerRadius: 12.0, // Optional: default is 8.0
  boxSize: 60.0, // Optional: default is 50.0
)
```
