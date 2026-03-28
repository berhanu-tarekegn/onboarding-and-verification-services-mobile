import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';
import 'package:kifiya_rendering_engine/native_file_picker.dart';
import 'package:kifiya_rendering_engine/src/models/file_upload_data.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';

class UploadContainer extends ConsumerWidget {
  const UploadContainer({required this.field, required this.error, super.key});
  final FieldSchema field;
  final String? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(formControllerProvider.notifier);
    final value = ref.watch(formControllerProvider)[field.id];
    final theme = KifiyaFormTheme.of(context);

    // Helper to get typed data safely
    FileUploadData currentData;
    if (value is FileUploadData) {
      currentData = value;
    } else if (value is String) {
      // Handle legacy string path case
      currentData = FileUploadData(filePath: value);
    } else {
      currentData = const FileUploadData();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent.shade400, width: 0.5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              labelWidget(label: currentData.hasFile?currentData.filePath!:field.label),
              ElevatedButton(
                style:
                    theme.fileUploadButtonStyle ??
                    ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                onPressed: () async {
                  final path = await NativeFilePicker.pickFile(
                    allowedTypes: ['jpg', 'jpeg', 'png'],
                  );
                  if (path != null) {
                    controller.updateField(
                      field.id,
                      currentData.copyWith(filePath: path.toString()),
                      ref,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text('Error picking file'),
                      ),
                    );
                  }
                },
                child: Text(
                  currentData.hasFile ? 'Change File' : 'Upload Now',
                  style:
                      theme.fileUploadTextStyle?.copyWith(fontSize: 12) ??
                      const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (currentData.hasFile)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // spacing: 8, // 'spacing' is not available in Column in all Flutter versions, using SizedBox
              children: [
                Text(
                  "Document Number",
                  style:
                      theme.labelStyle?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade400,
                      ) ??
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: currentData.documentNumber,
                  style: theme.textFieldStyle,
                  decoration:
                      (theme.textFieldDecoration ??
                              const InputDecoration(
                                border: OutlineInputBorder(),
                              ))
                          .copyWith(
                            labelText: field.label,
                            hintText: field.label,
                            errorText: error,
                          ),
                  onChanged: (val) {
                    controller.updateField(
                      field.id,
                      currentData.copyWith(documentNumber: val),
                      ref,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final firstDate = field.minDate ?? DateTime(1900);
                          final lastDate = field.maxDate ?? DateTime(2100);

                          DateTime initialDate;
                          if (currentData.issuedDate != null) {
                            try {
                              initialDate = DateTime.parse(
                                currentData.issuedDate!,
                              );
                            } catch (_) {
                              initialDate = DateTime.now();
                            }
                          } else {
                            final now = DateTime.now();
                            if (now.isAfter(lastDate)) {
                              initialDate = lastDate;
                            } else if (now.isBefore(firstDate)) {
                              initialDate = firstDate;
                            } else {
                              initialDate = now;
                            }
                          }

                          final picked = await showDatePicker(
                            context: context,
                            firstDate: firstDate,
                            lastDate: lastDate,
                            initialDate: initialDate,
                          );
                          if (picked != null) {
                            controller.updateField(
                              field.id,
                              currentData.copyWith(
                                issuedDate: picked.toIso8601String(),
                              ),
                              ref,
                            );
                          }
                        },
                        child: InputDecorator(
                          decoration:
                              (theme.dateFieldDecoration?.copyWith(
                                        suffixIcon: const Icon(Icons.schedule),
                                      ) ??
                                      const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ))
                                  .copyWith(errorText: error),
                          child: Text(
                            currentData.issuedDate != null
                                ? (field.dateFormat != null
                                      ? DateFormat(field.dateFormat).format(
                                          DateTime.parse(
                                            currentData.issuedDate!,
                                          ),
                                        )
                                      : currentData.issuedDate!
                                            .split('T')
                                            .first)
                                : 'Issued Date',
                            style:
                                theme.dateFieldStyle ??
                                TextStyle(
                                  color: currentData.issuedDate != null
                                      ? Colors.black87
                                      : Colors.black54,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final firstDate = field.minDate ?? DateTime(1900);
                          final lastDate = field.maxDate ?? DateTime(2100);

                          DateTime initialDate;
                          if (currentData.expiredDate != null) {
                            try {
                              initialDate = DateTime.parse(
                                currentData.expiredDate!,
                              );
                            } catch (_) {
                              initialDate = DateTime.now();
                            }
                          } else {
                            final now = DateTime.now();
                            if (now.isAfter(lastDate)) {
                              initialDate = lastDate;
                            } else if (now.isBefore(firstDate)) {
                              initialDate = firstDate;
                            } else {
                              initialDate = now;
                            }
                          }

                          final picked = await showDatePicker(
                            context: context,
                            firstDate: firstDate,
                            lastDate: lastDate,
                            initialDate: initialDate,
                          );
                          if (picked != null) {
                            controller.updateField(
                              field.id,
                              currentData.copyWith(
                                expiredDate: picked.toIso8601String(),
                              ),
                              ref,
                            );
                          }
                        },
                        child: InputDecorator(
                          decoration:
                              (theme.dateFieldDecoration?.copyWith(
                                        suffixIcon: const Icon(Icons.schedule),
                                      ) ??
                                      const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ))
                                  .copyWith(errorText: error),
                          child: Text(
                            currentData.expiredDate != null
                                ? (field.dateFormat != null
                                      ? DateFormat(field.dateFormat).format(
                                          DateTime.parse(
                                            currentData.expiredDate!,
                                          ),
                                        )
                                      : currentData.expiredDate!
                                            .split('T')
                                            .first)
                                : 'Expired Date',
                            style:
                                theme.dateFieldStyle ??
                                TextStyle(
                                  color: currentData.expiredDate != null
                                      ? Colors.black87
                                      : Colors.black54,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Widget labelWidget({required String label}) {
  return Row(
    // spacing: 8, // Not available in older Flutter versions
    children: [
      Container(
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent.shade400,
        ),
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
          width: 150,
          child: Text(label,
              style: const TextStyle(color: Colors.black54, overflow: TextOverflow.ellipsis))),
    ],
  );
}
