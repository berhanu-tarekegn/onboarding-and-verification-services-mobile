import 'package:flutter/material.dart';
import '../models/field_schema.dart';
import '../models/form_schema.dart';

/// Abstract factory for creating form field widgets.
///
/// This interface allows consuming applications to provide their own
/// widget implementations while the rendering engine handles all the
/// business logic (state management, validation, visibility, etc.).
///
/// The engine will call these factory methods with the current state
/// and callbacks. Your custom widgets should:
/// 1. Display the provided value
/// 2. Call onChanged when the user interacts
/// 3. Display error messages if provided
///
/// Example implementation:
/// ```dart
/// class MyCustomFactory implements FormWidgetFactory {
///   @override
///   Widget createTextField({
///     required BuildContext context,
///     required FieldSchema field,
///     required String? value,
///     required String? error,
///     required ValueChanged<String?> onChanged,
///   }) {
///     return MyCustomTextField(
///       label: field.label,
///       value: value,
///       error: error,
///       onChanged: onChanged,
///     );
///   }
///   // ... implement other methods
/// }
/// ```
abstract class FormWidgetFactory {
  /// Creates a text field widget.
  Widget createTextField({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  });

  /// Creates a dropdown field widget.
  Widget createDropdown({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  });

  /// Creates a radio button group widget.
  Widget createRadio({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  });

  /// Creates a checkbox widget.
  Widget createCheckbox({
    required BuildContext context,
    required FieldSchema field,
    required bool? value,
    required String? error,
    required ValueChanged<bool?> onChanged,
  });

  /// Creates a date picker field widget.
  Widget createDateField({
    required BuildContext context,
    required FieldSchema field,
    required DateTime? value,
    required String? error,
    required ValueChanged<DateTime?> onChanged,
  });

  /// Creates a file upload field widget.
  Widget createFileUpload({
    required BuildContext context,
    required FieldSchema field,
    required FormSchema schema,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  });

  /// Creates a signature field widget.
  Widget createSignature({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  });

  /// Creates an image capture field widget.
  ///
  /// The widget should allow users to capture an image using their device's camera.
  /// The [value] parameter contains the base64-encoded image or file path.
  /// Call [onChanged] with the captured image data (base64 or file path).
  Widget createImageCapture({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  });

  /// Creates a submit button widget.
  Widget createSubmitButton({
    required BuildContext context,
    required VoidCallback onSubmit,
    required bool isSubmitting,
  });

  /// Optionally wraps a field widget with additional UI (labels, spacing, etc.).
  ///
  /// This is called for each field and allows you to add consistent
  /// wrapping elements. Return [child] unchanged if no wrapping is needed.
  Widget wrapField({
    required BuildContext context,
    required FieldSchema field,
    required String? error,
    required Widget child,
  }) {
    // Default implementation: no wrapping
    return child;
  }
}
