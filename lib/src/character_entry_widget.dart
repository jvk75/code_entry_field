import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'code_entry_field_style.dart';

/// Capilization of the characters.
/// allwaysAllcaps - Character is converted to allcaps
/// alwaysSmall - Character is converted to lowercaps
/// keyboardDefined - Character is defined by the keyboard (default)
enum Capitalization {
  alwaysAllcaps,
  alwaysSmall,
  keyboardDefined;
}

/// A Flutter widget for entering single characters at a time in a series of boxes.
///
/// This widget provides a flexible and customizable way to input codes, PINs, or
/// any sequence of single characters. Each character has its own dedicated box,
/// and the widget handles focus management, backspace behavior, and character validation.
class CodeEntryField extends StatefulWidget {
  /// The number of character boxes to display.
  final int characterCount;

  /// A callback function that is called whenever the list of characters changes.
  /// It provides the current list of characters in all boxes.
  final void Function(List<String>) onChanged;

  /// The size (width and height) of each character box.
  /// Defaults to 50.0.
  final Size? boxSize;

  /// An optional list of initial characters to pre-fill the boxes.
  /// If the list is longer than `characterCount`, extra characters are ignored.
  /// If shorter, the remaining boxes will be blank.
  final List<String>? initialCharacters;

  /// The style to apply to the code entry field.
  final CodeEntryFieldStyle? style;

  /// Set the character capitaliztion . Default: keyboadDefined
  final Capitalization capitalization;

  /// Creates a [CodeEntryField] widget.
  const CodeEntryField({
    super.key,
    required this.characterCount,
    required this.onChanged,
    this.boxSize,
    this.initialCharacters,
    this.style,
    this.capitalization = Capitalization.keyboardDefined,
  });

  @override
  State<CodeEntryField> createState() => _CodeEntryFieldState();
}

class _EmptyTextSelectionControls extends TextSelectionControls {
  @override
  Size getHandleSize(double textLineHeight) => const Size(0, 0);

  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [VoidCallback? onTap]) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    return const SizedBox.shrink();
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return const Offset(0, 0);
  }
}

class _CodeEntryFieldState extends State<CodeEntryField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _characters;

  late CodeEntryFieldStyle style;
  static const _zws = '\u200B';

  @override
  void initState() {
    super.initState();

    style = widget.style ?? CodeEntryFieldStyle.Default;

    _characters = List.generate(widget.characterCount, (index) => '');
    if (widget.initialCharacters != null) {
      for (int i = 0;
          i < widget.initialCharacters!.length && i < widget.characterCount;
          i++) {
        _characters[i] = widget.initialCharacters![i];
      }
    }

    _controllers = List.generate(
      widget.characterCount,
      (index) => TextEditingController(text: _characters[index]),
    );

    _focusNodes = List.generate(
      widget.characterCount,
      (index) {
        final focusNode = FocusNode();

        WidgetsBinding.instance
            .addPostFrameCallback((_) => widget.onChanged(_characters));

        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            if (_controllers[index].text.isEmpty) {
              _controllers[index].text = _zws;
              _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length,
              );
            } else {
              _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length,
              );
            }
          } else {
            if (_controllers[index].text == _zws) {
              _controllers[index].text = '';
            }
          }
        });

        focusNode.onKeyEvent = (node, event) {
          if (event is! KeyDownEvent) {
            return KeyEventResult.ignored;
          }

          if (event.logicalKey == LogicalKeyboardKey.tab ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            if (index < widget.characterCount - 1) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[0].requestFocus();
            }
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        };
        return focusNode;
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.characterCount, (index) {
          return Container(
            width: widget.boxSize?.width ?? 50,
            height: widget.boxSize?.height ?? 50,
            margin: const EdgeInsets.all(4),
            clipBehavior: Clip.none,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              readOnly: false,
              showCursor: false,
              clipBehavior: Clip.none,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.top,
              enableSuggestions: false,
              style: widget.style?.textStyle,
              selectionControls: _EmptyTextSelectionControls(),
              maxLength: 1,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: style.boxBackgroundColor,
                focusColor: style.boxBackgroundColor,
                hoverColor: style.boxBackgroundColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: style.selectionColor ?? Colors.black,
                    width: (style.boxBorderWidth ?? 1.0) * 2,
                  ),
                  borderRadius:
                      BorderRadius.circular(style.boxCornerRadius ?? 0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: style.boxBorderColor ?? Colors.black,
                    width: style.boxBorderWidth ?? 1.0,
                  ),
                  borderRadius:
                      BorderRadius.circular(style.boxCornerRadius ?? 0),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  _characters[index] = '';
                  widget.onChanged(_characters);
                  if (index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                  return;
                }

                final char = value.replaceFirst(_zws, '');

                if (char.isEmpty) {
                  return;
                }

                String finalChar = char.substring(char.length - 1);

                switch (widget.capitalization) {
                  case Capitalization.alwaysAllcaps:
                    finalChar = finalChar.toUpperCase();
                    break;
                  case Capitalization.alwaysSmall:
                    finalChar = finalChar.toLowerCase();
                    break;
                  default:
                    break;
                }

                if (RegExp(r'^[a-zA-Z0-9]$').hasMatch(finalChar)) {
                  _controllers[index].text = finalChar;
                  _characters[index] = finalChar;
                  widget.onChanged(_characters);

                  if (index < widget.characterCount - 1) {
                    _focusNodes[index + 1].requestFocus();
                  } else {
                    _focusNodes[0].requestFocus();
                  }
                } else {
                  String revertText;
                  if (_characters[index].isEmpty) {
                    revertText = _zws;
                  } else {
                    revertText = _characters[index];
                  }
                  _controllers[index].text = revertText;
                  _controllers[index].selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: revertText.length,
                  );
                }
              },
              onTap: () {
                _focusNodes[index].requestFocus();
              },
            ),
          );
        }),
      ),
    );
  }
}