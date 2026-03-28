// Async provider that loads JSON and parses it
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';

final formProvider = FutureProvider.family<FormSchema, String>((
  ref,
  assetPath,
) async {
  final String response = await rootBundle.loadString(assetPath);
  await Future.delayed(const Duration(milliseconds: 500));
  return FormSchema.fromJson(json.decode(response));
});

// Current form step path
final formAssetPathProvider = StateProvider<String>(
  (ref) => 'assets/fayda_identity_verification.json',
);

// Total number of steps
const int totalSteps = 5;

// Map of step paths to step numbers
const Map<String, int> stepNumbers = {
  'assets/fayda_identity_verification.json': 1,
  'assets/fayda_step_2.json': 2,
  'assets/fayda_step_3.json': 3,
  'assets/fayda_step_4.json': 4,
  'assets/step_5.json': 5,
};

// Provider for current step number
final currentStepProvider = Provider<int>((ref) {
  final path = ref.watch(formAssetPathProvider);
  return stepNumbers[path] ?? 1;
});
