import 'package:flutter/material.dart';

/// Theme data class containing all styling properties for the form engine.
///
/// This centralizes all visual customization in one place, decoupling
/// styling from form data/schema.
class KifiyaFormThemeData {
  /// Text field styling
  final InputDecoration? textFieldDecoration;
  final TextStyle? textFieldStyle;

  /// Dropdown styling
  final InputDecoration? dropdownDecoration;
  final TextStyle? dropdownItemStyle;

  /// Checkbox styling
  final Color? checkboxActiveColor;
  final Color? checkboxCheckColor;
  final Color? checkboxFillColor;
  final Color? checkboxHoverColor;
  final OutlinedBorder? checkboxShape;

  /// Radio button styling
  final Color? radioActiveColor;
  final Color? radioHoverColor;
  final EdgeInsets? radioContentPadding;
  final TextStyle? radioLabelStyle;
  final ShapeBorder? radioShape;

  /// Date picker styling
  final InputDecoration? dateFieldDecoration;
  final TextStyle? dateFieldStyle;

  /// File upload styling
  final ButtonStyle? fileUploadButtonStyle;
  final TextStyle? fileUploadTextStyle;

  /// Signature styling
  final Color? signaturePenColor;
  final Color? signatureBackgroundColor;
  final ButtonStyle? signatureButtonStyle;
  final TextStyle? signatureTextStyle;

  /// Submit button styling
  final ButtonStyle? submitButtonStyle;

  /// Error text styling
  final TextStyle? errorTextStyle;

  /// Label styling
  final TextStyle? labelStyle;

  const KifiyaFormThemeData({
    this.textFieldDecoration,
    this.textFieldStyle,
    this.dropdownDecoration,
    this.dropdownItemStyle,
    this.checkboxActiveColor,
    this.checkboxCheckColor,
    this.checkboxFillColor,
    this.checkboxHoverColor,
    this.checkboxShape,
    this.radioActiveColor,
    this.radioHoverColor,
    this.radioContentPadding,
    this.radioLabelStyle,
    this.radioShape,
    this.dateFieldDecoration,
    this.dateFieldStyle,
    this.fileUploadButtonStyle,
    this.fileUploadTextStyle,
    this.signaturePenColor,
    this.signatureBackgroundColor,
    this.signatureButtonStyle,
    this.signatureTextStyle,
    this.submitButtonStyle,
    this.errorTextStyle,
    this.labelStyle,
  });

  /// Creates a copy of this theme with the given fields replaced.
  KifiyaFormThemeData copyWith({
    InputDecoration? textFieldDecoration,
    TextStyle? textFieldStyle,
    InputDecoration? dropdownDecoration,
    TextStyle? dropdownItemStyle,
    Color? checkboxActiveColor,
    Color? checkboxCheckColor,
    Color? checkboxFillColor,
    Color? checkboxHoverColor,
    OutlinedBorder? checkboxShape,
    Color? radioActiveColor,
    Color? radioHoverColor,
    EdgeInsets? radioContentPadding,
    TextStyle? radioLabelStyle,
    ShapeBorder? radioShape,
    InputDecoration? dateFieldDecoration,
    TextStyle? dateFieldStyle,
    ButtonStyle? fileUploadButtonStyle,
    TextStyle? fileUploadTextStyle,
    Color? signaturePenColor,
    Color? signatureBackgroundColor,
    ButtonStyle? signatureButtonStyle,
    TextStyle? signatureTextStyle,
    ButtonStyle? submitButtonStyle,
    TextStyle? errorTextStyle,
    TextStyle? labelStyle,
  }) {
    return KifiyaFormThemeData(
      textFieldDecoration: textFieldDecoration ?? this.textFieldDecoration,
      textFieldStyle: textFieldStyle ?? this.textFieldStyle,
      dropdownDecoration: dropdownDecoration ?? this.dropdownDecoration,
      dropdownItemStyle: dropdownItemStyle ?? this.dropdownItemStyle,
      checkboxActiveColor: checkboxActiveColor ?? this.checkboxActiveColor,
      checkboxCheckColor: checkboxCheckColor ?? this.checkboxCheckColor,
      checkboxFillColor: checkboxFillColor ?? this.checkboxFillColor,
      checkboxHoverColor: checkboxHoverColor ?? this.checkboxHoverColor,
      checkboxShape: checkboxShape ?? this.checkboxShape,
      radioActiveColor: radioActiveColor ?? this.radioActiveColor,
      radioHoverColor: radioHoverColor ?? this.radioHoverColor,
      radioContentPadding: radioContentPadding ?? this.radioContentPadding,
      radioLabelStyle: radioLabelStyle ?? this.radioLabelStyle,
      radioShape: radioShape ?? this.radioShape,
      dateFieldDecoration: dateFieldDecoration ?? this.dateFieldDecoration,
      dateFieldStyle: dateFieldStyle ?? this.dateFieldStyle,
      fileUploadButtonStyle:
          fileUploadButtonStyle ?? this.fileUploadButtonStyle,
      fileUploadTextStyle: fileUploadTextStyle ?? this.fileUploadTextStyle,
      signaturePenColor: signaturePenColor ?? this.signaturePenColor,
      signatureBackgroundColor:
          signatureBackgroundColor ?? this.signatureBackgroundColor,
      signatureButtonStyle: signatureButtonStyle ?? this.signatureButtonStyle,
      signatureTextStyle: signatureTextStyle ?? this.signatureTextStyle,
      submitButtonStyle: submitButtonStyle ?? this.submitButtonStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      labelStyle: labelStyle ?? this.labelStyle,
    );
  }

  /// Default theme with sensible defaults
  static KifiyaFormThemeData defaults() {
    return const KifiyaFormThemeData(
      textFieldDecoration: InputDecoration(border: OutlineInputBorder()),
      dropdownDecoration: InputDecoration(border: OutlineInputBorder()),
      dateFieldDecoration: InputDecoration(border: OutlineInputBorder()),
      radioContentPadding: EdgeInsets.zero,
    );
  }

  /// Merges this theme with another, with the other taking precedence
  KifiyaFormThemeData merge(KifiyaFormThemeData? other) {
    if (other == null) return this;
    return copyWith(
      textFieldDecoration: other.textFieldDecoration,
      textFieldStyle: other.textFieldStyle,
      dropdownDecoration: other.dropdownDecoration,
      dropdownItemStyle: other.dropdownItemStyle,
      checkboxActiveColor: other.checkboxActiveColor,
      checkboxCheckColor: other.checkboxCheckColor,
      checkboxFillColor: other.checkboxFillColor,
      checkboxHoverColor: other.checkboxHoverColor,
      checkboxShape: other.checkboxShape,
      radioActiveColor: other.radioActiveColor,
      radioHoverColor: other.radioHoverColor,
      radioContentPadding: other.radioContentPadding,
      radioLabelStyle: other.radioLabelStyle,
      radioShape: other.radioShape,
      dateFieldDecoration: other.dateFieldDecoration,
      dateFieldStyle: other.dateFieldStyle,
      fileUploadButtonStyle: other.fileUploadButtonStyle,
      fileUploadTextStyle: other.fileUploadTextStyle,
      signaturePenColor: other.signaturePenColor,
      signatureBackgroundColor: other.signatureBackgroundColor,
      signatureButtonStyle: other.signatureButtonStyle,
      signatureTextStyle: other.signatureTextStyle,
      submitButtonStyle: other.submitButtonStyle,
      errorTextStyle: other.errorTextStyle,
      labelStyle: other.labelStyle,
    );
  }
}

/// InheritedWidget for propagating theme data down the widget tree.
///
/// Wrap your app or form in this widget to provide theme data to all
/// child form widgets.
class KifiyaFormTheme extends InheritedWidget {
  final KifiyaFormThemeData data;

  const KifiyaFormTheme({super.key, required this.data, required super.child});

  /// Gets the theme data from the nearest ancestor, or defaults if not found.
  static KifiyaFormThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<KifiyaFormTheme>();
    return theme?.data ?? KifiyaFormThemeData.defaults();
  }

  /// Gets the theme data from the nearest ancestor, returning null if not found.
  static KifiyaFormThemeData? maybeOf(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<KifiyaFormTheme>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(KifiyaFormTheme oldWidget) {
    return data != oldWidget.data;
  }
}
