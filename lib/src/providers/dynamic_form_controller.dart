import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';

import 'form_providers.dart';

class DynamicFormController {
  WidgetRef? _ref;
  FormSchema? _schema;

  /// Called internally by the DynamicForm widget to link the controller
  void bind(WidgetRef ref, FormSchema schema) {
    _ref = ref;
    _schema = schema;
  }

  Map<String, dynamic> get values {
    _assertBound();
    return _ref!.read(formControllerProvider);
  }

  Map<String, String> validate() {
    _assertBound();
    final controller = _ref!.read(formControllerProvider.notifier);
    final errors = controller.validate(_schema!);
    _ref!.read(formErrorsProvider.notifier).state = errors;
    return errors;
  }

  bool get isValid => validate().isEmpty;

  void submit(Function(Map<String, dynamic>) onSubmit) {
    final errors = validate();
    if (errors.isEmpty) {
      onSubmit(values);
    }
  }

  void _assertBound() {
    if (_ref == null || _schema == null) {
      throw Exception(
        'DynamicFormController is not bound. '
            'Pass it to the DynamicForm widget first.',
      );
    }
  }
}
