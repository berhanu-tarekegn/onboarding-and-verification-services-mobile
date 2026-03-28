import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';
import 'package:kifiya_rendering_engine_example/core/di/injection.dart';
import 'package:kifiya_rendering_engine_example/core/models/form_template_model.dart';
import 'package:kifiya_rendering_engine_example/custom_widget_factory.dart';
import 'package:kifiya_rendering_engine_example/data/mappers/form_template_to_form_schema.dart';
import 'package:kifiya_rendering_engine_example/data_provider.dart';
import 'package:kifiya_rendering_engine_example/domain/entities/form_submission_request.dart';
import 'package:kifiya_rendering_engine_example/form_data_source.dart';
import 'package:kifiya_rendering_engine_example/form_session_providers.dart';
import 'package:kifiya_rendering_engine_example/success_screen.dart';

class FormScreen extends ConsumerStatefulWidget {
  const FormScreen({
    super.key,
    this.source = FormDataSource.assetWizard,
  });

  final FormDataSource source;

  @override
  ConsumerState<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends ConsumerState<FormScreen> {
  final DynamicFormController _controller = DynamicFormController();

  @override
  Widget build(BuildContext context) {
    if (widget.source == FormDataSource.remoteKybDemo) {
      final async = ref.watch(remoteKybFormSessionProvider);
      return async.when(
        data: (session) {
          final totalRemoteSteps = session.sortedGroups.length;
          if (totalRemoteSteps == 0) {
            return Scaffold(
              appBar: AppBar(title: const Text('KYB')),
              body: const Center(
                child: Text('This template has no question groups.'),
              ),
            );
          }

          final rawStep = ref.watch(remoteKybStepProvider);
          final step = math.min(
            math.max(rawStep, 1),
            totalRemoteSteps,
          );
          final group = session.sortedGroups[step - 1];
          final schema = mapQuestionGroupToFormSchema(group);

          return _buildScaffold(
            context,
            schema: schema,
            remoteDefinition: session.definition,
            currentStep: step,
            totalStepsForStepper: totalRemoteSteps,
            isRemote: true,
            groupUniqueKey: group.uniqueKey,
          );
        },
        error: (error, stackTrace) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text(error.toString())),
        ),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final formAssetPath = ref.watch(formAssetPathProvider);
    final formAsync = ref.watch(formProvider(formAssetPath));
    final currentStep = ref.watch(currentStepProvider);

    return formAsync.when(
      data: (schema) => _buildScaffold(
        context,
        schema: schema,
        remoteDefinition: null,
        currentStep: currentStep,
        totalStepsForStepper: totalSteps,
        isRemote: false,
        groupUniqueKey: null,
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(error.toString())),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildScaffold(
    BuildContext context, {
    required FormSchema schema,
    required TemplateDefinitionModel? remoteDefinition,
    required int currentStep,
    required int totalStepsForStepper,
    required bool isRemote,
    required String? groupUniqueKey,
  }) {
    final step = currentStep;
    final showBack = step > 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: _AppBarTitles(
          stepTitle: schema.title,
          flowSubtitle: isRemote ? remoteDefinition!.displayTitle : null,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        children: [
          if (totalStepsForStepper > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: StepIndicator(
                currentStep: step,
                totalSteps: totalStepsForStepper,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: DynamicForm(
                        key: groupUniqueKey != null
                            ? ValueKey<String>(
                                'form_step_${groupUniqueKey}_$step',
                              )
                            : ValueKey<String>('asset_$step'),
                        schema: schema,
                        controller: _controller,
                        widgetFactory: CustomWidgetFactory(),
                        layout: const FormLayoutConfig.vertical(
                          spacing: 16.0,
                        ),
                        showSubmitButton: false,
                        onSubmit: (_) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        if (showBack)
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                if (isRemote) {
                                  ref
                                      .read(remoteKybStepProvider.notifier)
                                      .state = step - 1;
                                } else {
                                  final prevStep = step - 1;
                                  ref.read(formAssetPathProvider.notifier).state =
                                      'assets/step_$prevStep.json';
                                }
                              },
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        if (showBack) const SizedBox(width: 12),
                        Expanded(
                          flex: showBack ? 2 : 1,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(
                                schema.buttonColor.isNotEmpty
                                    ? Color(int.parse(schema.buttonColor))
                                    : Colors.blue,
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 14),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _controller.submit((values) {
                                if (isRemote) {
                                  if (step < totalStepsForStepper) {
                                    ref
                                        .read(
                                          remoteKybStepProvider.notifier,
                                        )
                                        .state = step + 1;
                                  } else {
                                    unawaited(
                                      _submitRemoteAndNavigate(
                                        context,
                                        remoteDefinition!,
                                        values,
                                      ),
                                    );
                                  }
                                  return;
                                }
                                if (schema.nextFormApiUrl.isNotEmpty) {
                                  ref
                                      .read(formAssetPathProvider.notifier)
                                      .state = schema.nextFormApiUrl;
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (context) =>
                                          const SuccessScreen(),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Text(
                              step == totalStepsForStepper
                                  ? 'Submit'
                                  : 'Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRemoteAndNavigate(
    BuildContext context,
    TemplateDefinitionModel definition,
    Map<String, dynamic> values,
  ) async {
    final cfg = ref.read(appConfigProvider);
    final templateId =
        (definition.templateId != null && definition.templateId!.isNotEmpty)
            ? definition.templateId!
            : cfg.templateId;
    if (templateId.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing template_id: set TEMPLATE_ID in .env or use a definition that includes template_id.'),
        ),
      );
      return;
    }

    try {
      await ref.read(kyFormRepositoryProvider).submitForm(
            FormSubmissionRequest(
              templateId: templateId,
              formData: Map<String, dynamic>.from(values),
              submitterId: cfg.submitterId,
            ),
          );
      if (!context.mounted) return;
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const SuccessScreen(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submit failed: $e')),
      );
    }
  }
}

class _AppBarTitles extends StatelessWidget {
  const _AppBarTitles({
    required this.stepTitle,
    this.flowSubtitle,
  });

  final String stepTitle;
  final String? flowSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (flowSubtitle == null || flowSubtitle!.isEmpty) {
      return Text(
        stepTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stepTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
        Text(
          flowSubtitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

/// A visual step indicator showing progress through the form.
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isOdd) {
              final stepBefore = (index ~/ 2) + 1;
              final isCompleted = stepBefore < currentStep;
              return Expanded(
                child: Container(
                  height: 3,
                  color: isCompleted ? Colors.blue : Colors.grey.shade300,
                ),
              );
            } else {
              final stepNumber = (index ~/ 2) + 1;
              final isActive = stepNumber == currentStep;
              final isCompleted = stepNumber < currentStep;

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? Colors.blue
                      : isCompleted
                          ? Colors.blue
                          : Colors.grey.shade300,
                  border: isActive
                      ? Border.all(color: Colors.blue.shade200, width: 3)
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '$stepNumber',
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Step $currentStep of $totalSteps',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }
}
