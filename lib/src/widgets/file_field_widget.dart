import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/models/form_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';
import 'package:kifiya_rendering_engine/src/widgets/upload_container.dart';

/// A widget that displays a file upload field with sequential activation support.
///
/// When [FormSchema.sequentialFileUpload] is enabled, file fields activate
/// one-by-one. The first field is always active, subsequent fields unlock
/// only after the previous one is completely filled (file + metadata).
class FileFieldWidget extends ConsumerWidget {
  final FieldSchema field;
  final String? error;
  final FormSchema schema;

  const FileFieldWidget({
    super.key,
    required this.field,
    this.error,
    required this.schema,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = KifiyaFormTheme.of(context);

    // Check if this field is active (unlocked)
    final activeFields = ref.watch(activeFileFieldsProvider(schema));
    final isActive = activeFields.contains(field.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section (always visible)
        if (!isActive)
          GestureDetector(
            onTap: () {
              if (!isActive) {
                // Show message when tapping locked field
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Please complete the previous upload first',
                    ),
                    backgroundColor: Colors.orange.shade700,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isActive ? Colors.grey.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                minTileHeight: 26,
                dense: true,
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.shade600
                        : Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    isActive ? Icons.upload_file : Icons.lock,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  field.label,
                  style: theme.textFieldStyle?.copyWith(
                    color: isActive ? Colors.black87 : Colors.grey.shade500,
                  ),
                ),
                trailing: Icon(
                  isActive
                      ? Icons.keyboard_arrow_down_outlined
                      : Icons.keyboard_arrow_right_outlined,
                  color: isActive ? Colors.black54 : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        // Upload container (only visible when active)
        if (isActive) UploadContainer(field: field, error: error),
        // Error display
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error!,
              style:
                  theme.errorTextStyle ??
                  TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}
