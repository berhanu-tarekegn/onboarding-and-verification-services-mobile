import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';

class TextFieldWidget extends ConsumerWidget {
  final FieldSchema field;
  final String? error;

  const TextFieldWidget({super.key, required this.field, this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(formControllerProvider.notifier);
    final value = ref.watch(formControllerProvider)[field.id] ?? '';
    final theme = KifiyaFormTheme.of(context);

    return TextFormField(
      initialValue: value,
      keyboardType: _mapKeyboardType(field.keyboardType),
      style: theme.textFieldStyle,
      decoration:
          (theme.textFieldDecoration ??
                  const InputDecoration(border: OutlineInputBorder()))
              .copyWith(
                labelText: field.label,
                hintText: field.label,
                errorText: error,
              ),
      onChanged: (val) => controller.updateField(field.id, val, ref),
    );
  }

  TextInputType _mapKeyboardType(KeyboardInputType? type) {
    switch (type) {
      case KeyboardInputType.number:
        return TextInputType.number;
      case KeyboardInputType.email:
        return TextInputType.emailAddress;
      case KeyboardInputType.phone:
        return TextInputType.phone;
      case KeyboardInputType.text:
      default:
        return TextInputType.text;
    }
  }
}
