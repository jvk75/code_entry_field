import 'package:flutter/material.dart';

/// Defines the visual styling for the [CodeEntryField] widget.
@immutable
class CodeEntryFieldStyle {
  /// The background color of each character box.
  final Color? boxBackgroundColor;

  /// The color of the border around each character box.
  final Color? boxBorderColor;

  /// The width of the border around each character box.
  final double? boxBorderWidth;

  /// The radius for the corners of each character box.
  final double? boxCornerRadius;

  /// The color of the selection highlight when a box is focused.
  final Color? selectionColor;

  /// The text style for the characters entered in the boxes.
  final TextStyle? textStyle;

  /// Creates a [CodeEntryFieldStyle] instance.
  const CodeEntryFieldStyle({
    this.boxBackgroundColor,
    this.boxBorderColor,
    this.boxBorderWidth,
    this.boxCornerRadius,
    this.selectionColor,
    this.textStyle,
  });

  /// The deafult style of the widget
  static final Default = CodeEntryFieldStyle(
      boxBackgroundColor: Colors.white,
      boxBorderColor: Colors.black,
      boxBorderWidth: 1.0,
      boxCornerRadius: 20.0,
      selectionColor: Colors.black,
      textStyle: TextStyle(
        fontSize: 20,
      ));

  /// copyWith method for changing default style values
  CodeEntryFieldStyle copyWith({
    Color? boxBackgroundColor,
    Color? boxBorderColor,
    double? boxBorderWidth,
    double? cornerRadius,
    Color? selectionColor,
    TextStyle? textStyle,
  }) {
    return CodeEntryFieldStyle(
      boxBackgroundColor: boxBackgroundColor ?? this.boxBackgroundColor,
      boxBorderColor: boxBorderColor ?? this.boxBorderColor,
      boxBorderWidth: boxBorderWidth ?? this.boxBorderWidth,
      boxCornerRadius: cornerRadius ?? this.boxCornerRadius,
      selectionColor: selectionColor ?? this.selectionColor,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
