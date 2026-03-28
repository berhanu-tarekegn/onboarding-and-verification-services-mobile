import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kifiya_rendering_engine_example/core/di/injection.dart';
import 'package:kifiya_rendering_engine_example/core/models/form_template_model.dart';

/// Current step for remote KYB wizard (1-based), aligned with [sortedGroups] index + 1.
final remoteKybStepProvider = StateProvider<int>((ref) => 1);

/// Loaded definition with [question_groups] sorted by `display_order` (one group = one step).
class RemoteKybSession {
  const RemoteKybSession({
    required this.definition,
    required this.sortedGroups,
  });

  /// Includes parsed [rulesConfig], ids, and question groups from the API.
  final TemplateDefinitionModel definition;

  /// Question groups in display order; length is the number of steps.
  final List<QuestionGroupModel> sortedGroups;
}

/// Fetches definition from [kyFormRepositoryProvider]. Mapping to [FormSchema] is per-step in UI.
final remoteKybFormSessionProvider = FutureProvider<RemoteKybSession>((ref) async {
  final repo = ref.read(kyFormRepositoryProvider);
  final definition = await repo.fetchTemplate();
  final groups = [...definition.questionGroups]
    ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  return RemoteKybSession(definition: definition, sortedGroups: groups);
});
