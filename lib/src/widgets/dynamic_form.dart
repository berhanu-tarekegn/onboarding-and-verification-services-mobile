import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/src/builders/form_widget_factory.dart';
import 'package:kifiya_rendering_engine/src/builders/default_form_widget_factory.dart';
import 'package:kifiya_rendering_engine/src/layout/form_layout.dart';
import 'package:kifiya_rendering_engine/src/models/form_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/dynamic_form_controller.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';
import '../models/field_schema.dart';

/// A dynamic form widget that renders form fields based on a schema.
///
/// The form supports customization through:
/// - **Widget Factory**: Use [widgetFactory] to provide completely custom widget implementations
/// - **Theme**: Use [theme] or wrap with [KifiyaFormTheme] for consistent styling
/// - **Layout**: Use [layout] to control how fields are arranged (vertical, horizontal, grid, wrap)
///
/// Example with custom widget factory:
/// ```dart
/// DynamicForm(
///   schema: mySchema,
///   widgetFactory: MyCustomWidgetFactory(),
///   onSubmit: (values) => print(values),
/// )
/// ```
///
/// Example with theme:
/// ```dart
/// DynamicForm(
///   schema: mySchema,
///   theme: KifiyaFormThemeData(
///     textFieldDecoration: InputDecoration(filled: true),
///     radioActiveColor: Colors.blue,
///   ),
///   onSubmit: (values) => print(values),
/// )
/// ```
class DynamicForm extends ConsumerWidget {
  /// The form schema defining the fields to render
  final FormSchema schema;

  /// Callback when the form is submitted with valid data
  final ValueChanged<Map<String, dynamic>>? onSubmit;

  /// Widget factory for creating custom field widgets.
  /// If not provided, uses [DefaultFormWidgetFactory].
  final FormWidgetFactory? widgetFactory;

  /// Theme data for styling form fields.
  /// If not provided, will look for [KifiyaFormTheme] ancestor or use defaults.
  final KifiyaFormThemeData? theme;

  /// Layout configuration for how fields are arranged.
  /// Defaults to vertical layout with 16px spacing.
  final FormLayoutConfig layout;

  /// Controller for programmatic form interaction
  final DynamicFormController? controller;

  /// Whether to show the submit button
  final bool showSubmitButton;

  /// Label for the submit button. Defaults to "Submit".
  final String submitButtonLabel;

  const DynamicForm({
    super.key,
    required this.schema,
    this.onSubmit,
    this.controller,
    this.widgetFactory,
    this.theme,
    this.layout = const FormLayoutConfig.vertical(),
    this.showSubmitButton = true,
    this.submitButtonLabel = 'Submit',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize form state with default values if not already initialized
    // We use post frame callback to avoid state updates during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final formController = ref.read(formControllerProvider.notifier);
      final currentValues = ref.read(formControllerProvider);

      // Only initialize defaults if form is empty (fresh start)
      if (currentValues.isEmpty) {
        for (var field in schema.fields) {
          if (field.defaultValue != null) {
            formController.updateField(field.id, field.defaultValue, ref);
          }
        }
      }
    });

    // Provide theme and layout
    return KifiyaFormTheme(
      data: theme ?? KifiyaFormTheme.of(context),
      child: _DynamicFormContent(
        schema: schema,
        controller: controller,
        onSubmit: onSubmit,
        widgetFactory: widgetFactory,
        layout: layout,
        showSubmitButton: showSubmitButton,
        submitButtonLabel: submitButtonLabel,
      ),
    );
  }
}

class _DynamicFormContent extends ConsumerWidget {
  final FormSchema schema;
  final DynamicFormController? controller;
  final ValueChanged<Map<String, dynamic>>? onSubmit;
  final FormWidgetFactory? widgetFactory;
  final FormLayoutConfig layout;
  final bool showSubmitButton;
  final String submitButtonLabel;

  const _DynamicFormContent({
    required this.schema,
    this.controller,
    this.onSubmit,
    this.widgetFactory,
    required this.layout,
    this.showSubmitButton = true,
    this.submitButtonLabel = 'Submit',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bind the controller if provided so it can access form state
    if (controller != null) {
      controller!.bind(ref, schema);
    }

    // Determine which factory to use
    final factory = widgetFactory ?? const DefaultFormWidgetFactory();

    // Get current form values for logic checks
    final formValues = ref.watch(formControllerProvider);
    final errors = ref.watch(formErrorsProvider);

    // Filter fields based on visibility rules
    final visibleFields = schema.fields.where((field) {
      if (field.dependsOn != null && field.visibleWhenEquals != null) {
        final dependentValue = formValues[field.dependsOn];

        // Handle list of possible values (OR logic)
        if (field.visibleWhenEquals is List) {
          return (field.visibleWhenEquals as List).contains(dependentValue);
        }

        // Handle single value
        return dependentValue == field.visibleWhenEquals;
      }
      return true;
    }).toList();

    // Build field widgets with field info for layout control
    final fieldsWithWidgets = visibleFields.map((field) {
      final error = errors[field.id];
      final widget = _buildFieldWidget(context, ref, field, factory, error);

      // Wrap field with common wrapper (spacing, etc.) from factory
      final wrappedWidget = factory.wrapField(
        context: context,
        field: field,
        error: error,
        child: widget,
      );

      return FieldWithWidget(field: field, widget: wrappedWidget);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use layout builder with field info for row grouping support
        FormLayoutBuilder(config: layout, fieldsWithWidgets: fieldsWithWidgets),

        if (showSubmitButton) ...[
          const SizedBox(height: 24),
          _buildSubmitButton(context, ref, factory),
        ],
      ],
    );
  }

  Widget _buildFieldWidget(
    BuildContext context,
    WidgetRef ref,
    FieldSchema field,
    FormWidgetFactory factory,
    String? error,
  ) {
    final formController = ref.read(formControllerProvider.notifier);

    // Use widget factory to create widgets
    switch (field.type) {
      case FieldType.text:
        final value = ref.watch(formControllerProvider)[field.id] as String?;
        return factory.createTextField(
          context: context,
          field: field,
          value: value,
          error: error,
          onChanged: (val) => formController.updateField(field.id, val, ref),
        );
      case FieldType.radio:
        final value = ref.watch(formControllerProvider)[field.id] as String?;
        return factory.createRadio(
          context: context,
          field: field,
          value: value,
          error: error,
          onChanged: (val) => formController.updateField(field.id, val, ref),
        );
      case FieldType.dropdown:
        final value = ref.watch(formControllerProvider)[field.id] as String?;
        return factory.createDropdown(
          context: context,
          field: field,
          value: value,
          error: error,
          onChanged: (val) => formController.updateField(field.id, val, ref),
        );
      case FieldType.date:
        final value = ref.watch(formControllerProvider)[field.id];
        final dateValue = value != null
            ? DateTime.tryParse(value as String)
            : null;
        return factory.createDateField(
          context: context,
          field: field,
          value: dateValue,
          error: error,
          onChanged: (val) =>
              formController.updateField(field.id, val?.toIso8601String(), ref),
        );
      case FieldType.checkbox:
        final value =
            ref.watch(formControllerProvider)[field.id] as bool? ?? false;
        return factory.createCheckbox(
          context: context,
          field: field,
          value: value,
          error: error,
          onChanged: (val) => formController.updateField(field.id, val, ref),
        );
      case FieldType.fileUpload:
        final value = ref.watch(formControllerProvider)[field.id] as String?;
        return factory.createFileUpload(
          context: context,
          field: field,
          schema: schema,
          value: value,
          error: error,
          onChanged: (val) => formController.updateField(field.id, val, ref),
        );
      case FieldType.signature:
        final value = ref.watch(formControllerProvider)[field.id] as String?;
        return factory.createSignature(
          context: context,
          field: field,
          value: value,
          error: error,
          onChanged: (val) => formController.updateField(field.id, val, ref),
        );
      case FieldType.imageCapture:
        final value = ref.watch(formControllerProvider)[field.id] as String?;
        return factory.createImageCapture(
          context: context,
          field: field,
          value: value,
          error: error,
          onChanged: (val) => formController.updateField(field.id, val, ref),
        );
    }
  }

  Widget _buildSubmitButton(
    BuildContext context,
    WidgetRef ref,
    FormWidgetFactory factory,
  ) {
    final formController = ref.read(formControllerProvider.notifier);
    final isSubmitting = ref.watch(formSubmittingProvider);

    return factory.createSubmitButton(
      context: context,
      isSubmitting: isSubmitting,
      onSubmit: () async {
        final errors = formController.validate(schema);
        ref.read(formErrorsProvider.notifier).state = errors;

        if (errors.isEmpty) {
          final values = ref.read(formControllerProvider);
          if (onSubmit != null) {
            onSubmit!(values);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please correct the errors in the form'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }
}
