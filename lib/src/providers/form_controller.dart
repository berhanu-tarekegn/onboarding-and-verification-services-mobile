import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/models/form_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';

class FormController extends StateNotifier<Map<String, dynamic>> {
  FormController() : super({});

  /// Update a specific field value and clear error if exists
  void updateField(String id, dynamic value, WidgetRef ref) {
    state = {...state, id: value};

    // Remove the error for this field if it exists
    final errors = ref.read(formErrorsProvider.notifier);
    errors.update((e) {
      final copy = {...e};
      copy.remove(id);
      return copy;
    });
  }

  /// Validate required fields in the form schema
  Map<String, String> validate(FormSchema schema) {
    final errors = <String, String>{};

    for (var field in schema.fields) {
      final value = state[field.id];

      // Skip non-required fields
      if (!field.required) continue;

      bool isEmpty = false;
      bool isVisible = false;

      switch (field.type) {
        case FieldType.text:
          isEmpty = value == null || value.toString().trim().isEmpty;
          isVisible = isFieldVisible(field, state);
          // Regex validation
          if (!isEmpty && field.regex != null && isVisible) {
            final regExp = RegExp(field.regex!);
            if (!regExp.hasMatch(value.toString())) {
              errors[field.id] = '${field.label} format is invalid';
              continue; // skip required check since regex failed
            }
          }
          break;
        case FieldType.dropdown:
          isVisible = isFieldVisible(field, state);
          isEmpty = value == null || value.toString().trim().isEmpty;
        case FieldType.radio:
          isVisible = isFieldVisible(field, state);
          isEmpty = value == null || value.toString().trim().isEmpty;
          break;
        case FieldType.checkbox:
          isVisible = isFieldVisible(field, state);
          isEmpty = value != true; // must be true if required
          break;
        case FieldType.date:
          isVisible = isFieldVisible(field, state);
          isEmpty = value == null || value.toString().isEmpty;
          // Optional: validate min/max date if defined
          if (!isEmpty &&
              field.minDate != null &&
              value is DateTime &&
              isVisible) {
            if (value.isBefore(field.minDate!)) {
              errors[field.id] =
                  '${field.label} must be after ${field.minDate}';
            }
          }
          if (!isEmpty &&
              field.maxDate != null &&
              value is DateTime &&
              isVisible) {
            if (value.isAfter(field.maxDate!)) {
              errors[field.id] =
                  '${field.label} must be before ${field.maxDate}';
            }
          }
          break;
        case FieldType.fileUpload:
          isVisible = isFieldVisible(field, state);
          isEmpty = value == null || value.toString().isEmpty;
          break;
        case FieldType.signature:
          isVisible = isFieldVisible(field, state);
          isEmpty = value == null || value.toString().isEmpty;
          break;
        case FieldType.imageCapture:
          isVisible = isFieldVisible(field, state);
          isEmpty = value == null || value.toString().isEmpty;
          break;
      }

      if (isEmpty && isVisible) {
        errors[field.id] = '${field.label} is required';
      }
    }

    return errors;
  }

  dynamic getValue(String fieldId) => state[fieldId];

  /// Determine if a field should be visible based on dependency rules
  bool isFieldVisible(FieldSchema field, Map<String, dynamic> formState) {
    // No dependency → always visible
    if (field.dependsOn == null) return true;

    final dependsValue = formState[field.dependsOn];
    final condition = field.visibleWhenEquals;

    // No condition → always visible
    if (condition == null) return true;

    // If the condition is a list → check if the dependsValue is in it
    if (condition is List) {
      return condition.contains(dependsValue);
    }

    // Otherwise, check for direct equality
    return dependsValue == condition;
  }
}
