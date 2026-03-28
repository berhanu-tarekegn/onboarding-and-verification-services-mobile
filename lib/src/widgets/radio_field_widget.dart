import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';

class RadioFieldWidget extends ConsumerWidget {
  final FieldSchema field;
  final String? error;

  const RadioFieldWidget({super.key, required this.field, this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(formControllerProvider.notifier);
    final value = ref.watch(formControllerProvider)[field.id] as String?;
    final theme = KifiyaFormTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: theme.labelStyle ?? Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        ...?field.options?.map(
          (option) => RadioListTile<String>(
            contentPadding: theme.radioContentPadding ?? EdgeInsets.zero,
            title: Text(option, style: theme.radioLabelStyle),
            value: option,
            hoverColor: theme.radioHoverColor,
            activeColor: theme.radioActiveColor,
            shape: theme.radioShape,
            groupValue: value,
            onChanged: (val) {
              if (val != null) controller.updateField(field.id, val, ref);
            },
          ),
        ),
        if (error != null)
          Text(
            error!,
            style:
                theme.errorTextStyle ??
                TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }
}
