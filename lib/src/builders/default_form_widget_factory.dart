import 'package:flutter/material.dart';
import '../models/field_schema.dart';
import '../models/form_schema.dart';
import '../widgets/checkbox_field_widget.dart';
import '../widgets/date_field_widget.dart';
import '../widgets/dropdown_field_widget.dart';
import '../widgets/file_field_widget.dart';
import '../widgets/radio_field_widget.dart';
import '../widgets/signature_field_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/image_capture_field_widget.dart';
import 'form_widget_factory.dart';

/// Default implementation of [FormWidgetFactory] that uses the engine's
/// built-in widgets.
///
/// This factory returns the standard widgets provided by the rendering engine:
/// - [TextFieldWidget]
/// - [CheckboxFieldWidget]
/// - [RadioFieldWidget]
/// - [DropdownFieldWidget]
/// - [DateFieldWidget]
/// - [FileFieldWidget]
/// - [SignatureFieldWidget]
///
/// These widgets are Riverpod-aware and will automatically connect to the
/// form state providers. The [value] and [onChanged] parameters passed to
/// factory methods are ignored by these widgets since they manage their own
/// state through Riverpod.
class DefaultFormWidgetFactory implements FormWidgetFactory {
  const DefaultFormWidgetFactory();

  @override
  Widget createTextField({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return TextFieldWidget(field: field, error: error);
  }

  @override
  Widget createDropdown({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownFieldWidget(field: field, error: error);
  }

  @override
  Widget createRadio({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return RadioFieldWidget(field: field, error: error);
  }

  @override
  Widget createCheckbox({
    required BuildContext context,
    required FieldSchema field,
    required bool? value,
    required String? error,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxFieldWidget(field: field, error: error);
  }

  @override
  Widget createDateField({
    required BuildContext context,
    required FieldSchema field,
    required DateTime? value,
    required String? error,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return DateFieldWidget(field: field, error: error);
  }

  @override
  Widget createFileUpload({
    required BuildContext context,
    required FieldSchema field,
    required FormSchema schema,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return FileFieldWidget(field: field, error: error, schema: schema);
  }

  @override
  Widget createSignature({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return SignatureFieldWidget(field: field, error: error);
  }

  @override
  Widget createImageCapture({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return ImageCaptureFieldWidget(field: field, error: error);
  }

  @override
  Widget createSubmitButton({
    required BuildContext context,
    required VoidCallback onSubmit,
    required bool isSubmitting,
  }) {
    // This will be handled by DynamicForm's default submit button
    // or can be customized by the factory implementation
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onSubmit,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            isSubmitting ? 'Submitting...' : 'Submit',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrapField({
    required BuildContext context,
    required FieldSchema field,
    required String? error,
    required Widget child,
  }) {
    // Default implementation: no wrapping, just return the child
    return child;
  }
}
