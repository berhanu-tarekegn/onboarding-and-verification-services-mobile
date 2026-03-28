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
import 'package:kifiya_rendering_engine_example/passkey/futuristic_auth_theme.dart';
import 'package:kifiya_rendering_engine_example/submission_outcome_screen.dart';
import 'package:kifiya_rendering_engine_example/success_screen.dart';
import 'package:kifiya_rendering_engine_example/theme/futuristic_mesh_background.dart';

Widget _futuristicScaffoldShell({
  required String title,
  required Widget child,
}) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: FuturisticAuthTheme.overlayStyle,
    child: Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: FuturisticMeshBackground.bgTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        systemOverlayStyle: FuturisticAuthTheme.overlayStyle,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FuturisticMeshBackground(),
          SafeArea(child: child),
        ],
      ),
    ),
  );
}

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
            return _futuristicScaffoldShell(
              title: 'KYB',
              child: const Center(
                child: Text(
                  'This template has no question groups.',
                  style: TextStyle(color: Colors.white70),
                ),
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
        error: (error, stackTrace) => _futuristicScaffoldShell(
          title: 'Error',
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
        loading: () => _futuristicScaffoldShell(
          title: 'KYB',
          child: const Center(
            child: CircularProgressIndicator(
              color: FuturisticMeshBackground.cyan,
            ),
          ),
        ),
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
      error: (error, stackTrace) => _futuristicScaffoldShell(
        title: 'Error',
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
      loading: () => _futuristicScaffoldShell(
        title: 'Form',
        child: const Center(
          child: CircularProgressIndicator(
            color: FuturisticMeshBackground.cyan,
          ),
        ),
      ),
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

    final accent = schema.buttonColor.isNotEmpty
        ? Color(int.parse(schema.buttonColor))
        : FuturisticMeshBackground.cyan;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FuturisticAuthTheme.overlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: FuturisticMeshBackground.bgTop,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white.withValues(alpha: 0.9),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: _AppBarTitles(
            stepTitle: schema.title,
            flowSubtitle: isRemote ? remoteDefinition!.displayTitle : null,
          ),
          systemOverlayStyle: FuturisticAuthTheme.overlayStyle,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const FuturisticMeshBackground(),
            SafeArea(
              child: Column(
                children: [
                  if (totalStepsForStepper > 1)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: FuturisticStepIndicator(
                        currentStep: step,
                        totalSteps: totalStepsForStepper,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        children: [
                          Expanded(
                            child: FuturisticAuthTheme.glassPanel(
                              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                              child: SingleChildScrollView(
                                child: DynamicForm(
                                  key: groupUniqueKey != null
                                      ? ValueKey<String>(
                                          'form_step_${groupUniqueKey}_$step',
                                        )
                                      : ValueKey<String>('asset_$step'),
                                  schema: schema,
                                  controller: _controller,
                                  widgetFactory: const CustomWidgetFactory(),
                                  layout: const FormLayoutConfig.vertical(
                                    spacing: 18.0,
                                  ),
                                  showSubmitButton: false,
                                  onSubmit: (_) {},
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              if (showBack)
                                Expanded(
                                  child: _FuturisticOutlineButton(
                                    label: 'Back',
                                    onPressed: () {
                                      if (isRemote) {
                                        ref
                                            .read(
                                              remoteKybStepProvider.notifier,
                                            )
                                            .state = step - 1;
                                      } else {
                                        final prevStep = step - 1;
                                        ref
                                                .read(
                                                  formAssetPathProvider
                                                      .notifier,
                                                )
                                                .state =
                                            'assets/step_$prevStep.json';
                                      }
                                    },
                                  ),
                                ),
                              if (showBack) const SizedBox(width: 12),
                              Expanded(
                                flex: showBack ? 2 : 1,
                                child: _FuturisticPrimaryButton(
                                  label: step == totalStepsForStepper
                                      ? 'Submit'
                                      : 'Continue',
                                  accent: accent,
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
                                            .read(
                                              formAssetPathProvider.notifier,
                                            )
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
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

    // Fire-and-forget: demo always shows success UI; errors are ignored.
    try {
      if (templateId.isNotEmpty) {
        await ref.read(kyFormRepositoryProvider).submitForm(
              FormSubmissionRequest(
                templateId: templateId,
                formData: Map<String, dynamic>.from(values),
                submitterId: cfg.submitterId,
              ),
            );
      }
    } catch (_) {}

    if (!context.mounted) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const SubmissionOutcomeScreen(isSuccess: true),
      ),
    );
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
    const cyan = FuturisticMeshBackground.cyan;
    if (flowSubtitle == null || flowSubtitle!.isEmpty) {
      return Text(
        stepTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 17,
          height: 1.2,
        ),
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          flowSubtitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: cyan.withValues(alpha: 0.75),
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _FuturisticOutlineButton extends StatelessWidget {
  const _FuturisticOutlineButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            color: Colors.white.withValues(alpha: 0.04),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FuturisticPrimaryButton extends StatelessWidget {
  const _FuturisticPrimaryButton({
    required this.label,
    required this.accent,
    required this.onPressed,
  });

  final String label;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cyan = FuturisticMeshBackground.cyan;
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: cyan.withValues(alpha: 0.45), width: 1),
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: 0.95),
                accent.withValues(alpha: 0.75),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: cyan.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Futuristic step rail aligned with success / landing visuals.
class FuturisticStepIndicator extends StatelessWidget {
  const FuturisticStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    const cyan = FuturisticMeshBackground.cyan;
    const violet = FuturisticMeshBackground.violet;
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isOdd) {
              final stepBefore = (index ~/ 2) + 1;
              final isCompleted = stepBefore < currentStep;
              return Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: isCompleted
                        ? LinearGradient(
                            colors: [
                              cyan.withValues(alpha: 0.9),
                              violet.withValues(alpha: 0.6),
                            ],
                          )
                        : null,
                    color: isCompleted
                        ? null
                        : Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              );
            } else {
              final stepNumber = (index ~/ 2) + 1;
              final isActive = stepNumber == currentStep;
              final isCompleted = stepNumber < currentStep;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? cyan.withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.2),
                    width: isActive ? 1.5 : 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: cyan.withValues(alpha: 0.35),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                  gradient: isCompleted || isActive
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isCompleted
                              ? [cyan.withValues(alpha: 0.45), violet.withValues(alpha: 0.35)]
                              : [
                                  const Color(0xFF1a2338).withValues(alpha: 0.95),
                                  const Color(0xFF0d1528).withValues(alpha: 0.98),
                                ],
                        )
                      : null,
                  color: (!isCompleted && !isActive)
                      ? Colors.white.withValues(alpha: 0.06)
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(Icons.check_rounded, color: cyan, size: 18)
                      : Text(
                          '$stepNumber',
                          style: TextStyle(
                            color: isActive
                                ? cyan.withValues(alpha: 0.95)
                                : Colors.white.withValues(alpha: 0.45),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 10),
        Text(
          'SEGMENT $currentStep / $totalSteps',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
