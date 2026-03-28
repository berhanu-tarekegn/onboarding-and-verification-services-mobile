import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';
import 'package:kifiya_rendering_engine/src/providers/dynamic_form_controller.dart';

extension ControllerBinding on DynamicFormController {
  void _bindInternal(WidgetRef ref, FormSchema schema) => bind(ref, schema);
}
