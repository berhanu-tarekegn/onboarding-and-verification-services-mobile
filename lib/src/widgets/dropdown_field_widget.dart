import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';

class DropdownFieldWidget extends ConsumerWidget {
  final FieldSchema field;
  final String? error;

  const DropdownFieldWidget({super.key, required this.field, this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(formControllerProvider.notifier);
    final value = ref.watch(formControllerProvider)[field.id] as String?;
    final theme = KifiyaFormTheme.of(context);

    return DropdownButtonFormField<String>(
      value: value,
      style: theme.dropdownItemStyle,
      decoration:
          (theme.dropdownDecoration ??
                  const InputDecoration(border: OutlineInputBorder()))
              .copyWith(labelText: field.label, errorText: error),
      items: field.options
          ?.map((o) => DropdownMenuItem(value: o, child: Text(o)))
          .toList(),
      onChanged: (val) {
        if (val != null) controller.updateField(field.id, val, ref);
      },
    );
  }
}
