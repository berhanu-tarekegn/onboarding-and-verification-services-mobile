import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';

class CheckboxFieldWidget extends ConsumerWidget {
  final FieldSchema field;
  final String? error;

  const CheckboxFieldWidget({super.key, required this.field, this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(formControllerProvider.notifier);
    final value = ref.watch(formControllerProvider)[field.id] ?? false;
    final theme = KifiyaFormTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text(field.label, style: theme.labelStyle),
          shape: theme.checkboxShape,
          hoverColor: theme.checkboxHoverColor,
          checkColor: theme.checkboxCheckColor,
          fillColor: theme.checkboxFillColor != null
              ? WidgetStateProperty.all(theme.checkboxFillColor)
              : null,
          activeColor: theme.checkboxActiveColor,
          value: value as bool,
          onChanged: (val) => controller.updateField(field.id, val, ref),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16),
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
