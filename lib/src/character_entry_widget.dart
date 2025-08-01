import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeEntryField extends StatefulWidget {
  final int characterCount;
  final void Function(List<String>) onChanged;
  final double cornerRadius;
  final double boxSize;
  final List<String>? initialCharacters;

  const CodeEntryField({
    super.key,
    required this.characterCount,
    required this.onChanged,
    this.cornerRadius = 8.0,
    this.boxSize = 50.0,
    this.initialCharacters,
  });

  @override
  State<CodeEntryField> createState() => _CodeEntryFieldState();
}

class _EmptyTextSelectionControls extends TextSelectionControls {
  @override
  Size getHandleSize(double textLineHeight) => const Size(0, 0);

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight,
    [VoidCallback? onTap]
  ) {
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

  @override
  void initState() {
    super.initState();
    _characters = List.generate(widget.characterCount, (index) => '');
    if (widget.initialCharacters != null) {
      for (int i = 0; i < widget.initialCharacters!.length && i < widget.characterCount; i++) {
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

        WidgetsBinding.instance.addPostFrameCallback((_) => widget.onChanged(_characters));

        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            _controllers[index].selection = TextSelection(
              baseOffset: 0,
              extentOffset: _controllers[index].text.length,
            );
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

          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isNotEmpty) {
              _controllers[index].clear();
              _characters[index] = '';
              widget.onChanged(_characters);
            } else if (index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
            return KeyEventResult.handled;
          }

          final char = event.character;
          if (char != null &&
              char.isNotEmpty &&
              RegExp(r'^[a-zA-Z0-9]$').hasMatch(char)) {
            _controllers[index].text = char;
            _characters[index] = char;
            widget.onChanged(_characters);

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
            width: widget.boxSize,
            height: widget.boxSize,
            margin: const EdgeInsets.all(4),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              readOnly: true,
              showCursor: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              selectionControls: _EmptyTextSelectionControls(),
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.cornerRadius),
                ),
              ),
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
