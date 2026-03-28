import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';

class DateFieldWidget extends ConsumerWidget {
  final FieldSchema field;
  final String? error;

  const DateFieldWidget({super.key, required this.field, this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(formControllerProvider.notifier);
    final value = ref.watch(formControllerProvider)[field.id];
    final theme = KifiyaFormTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final firstDate = field.minDate ?? DateTime(1900);
            final lastDate = field.maxDate ?? DateTime(2100);

            // Determine initial date, clamped within valid range
            DateTime initialDate;
            if (value != null) {
              initialDate = DateTime.parse(value);
            } else {
              // Default to today, but clamp to valid range
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
              controller.updateField(field.id, picked.toIso8601String(), ref);
            }
          },
          child: InputDecorator(
            decoration:
                (theme.dateFieldDecoration ??
                        const InputDecoration(border: OutlineInputBorder()))
                    .copyWith(labelText: field.label, errorText: error),
            child: Text(
              value != null
                  ? (field.dateFormat != null
                        ? DateFormat(
                            field.dateFormat,
                          ).format(DateTime.parse(value))
                        : value.toString().split('T').first)
                  : 'Select Date',
              style:
                  theme.dateFieldStyle ??
                  TextStyle(
                    color: value != null ? Colors.black87 : Colors.black54,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
