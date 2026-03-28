import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/models/file_upload_data.dart';
import 'package:kifiya_rendering_engine/src/models/form_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_controller.dart';

final formControllerProvider =
    StateNotifierProvider<FormController, Map<String, dynamic>>(
      (ref) => FormController(),
    );

final visibleFieldsProvider = Provider.family<List<FieldSchema>, FormSchema>((
  ref,
  schema,
) {
  final formState = ref.watch(formControllerProvider);
  final controller = ref.read(formControllerProvider.notifier);
  return schema.fields
      .where((field) => controller.isFieldVisible(field, formState))
      .toList();
});
// Reactive map of fieldId -> error message
final formErrorsProvider = StateProvider<Map<String, String>>((ref) => {});

/// Computes which file upload fields are currently active (unlocked).
/// Returns a Set of field IDs that should be active.
///
/// When [FormSchema.sequentialFileUpload] is true:
/// - The first file field is always active
/// - Subsequent fields unlock only after the previous one is complete
///
/// When [FormSchema.sequentialFileUpload] is false:
/// - All file fields are active
final activeFileFieldsProvider = Provider.family<Set<String>, FormSchema>((
  ref,
  schema,
) {
  final fileFields = schema.fields
      .where((f) => f.type == FieldType.fileUpload)
      .toList();

  // If sequential mode is disabled, all file fields are active
  if (!schema.sequentialFileUpload) {
    return fileFields.map((f) => f.id).toSet();
  }

  final formState = ref.watch(formControllerProvider);
  final activeIds = <String>{};

  for (int i = 0; i < fileFields.length; i++) {
    final fieldId = fileFields[i].id;

    if (i == 0) {
      // First file field is always active
      activeIds.add(fieldId);
    } else {
      // Check if previous file field is complete
      final previousId = fileFields[i - 1].id;
      final previousData = formState[previousId];

      if (previousData is FileUploadData && previousData.isComplete) {
        activeIds.add(fieldId);
      } else {
        break; // Stop at first incomplete
      }
    }
  }

  return activeIds;
});

final formSubmittingProvider = StateProvider<bool>((ref) => false);
