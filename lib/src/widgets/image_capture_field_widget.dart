import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';
import 'dart:convert';

/// Widget for capturing images using the device camera.
///
/// This widget allows users to:
/// - Capture a new image using the camera
/// - View the captured image
/// - Remove the captured image
///
/// The captured image is stored as a base64-encoded string in the form state.
class ImageCaptureFieldWidget extends ConsumerWidget {
  final FieldSchema field;
  final String? error;

  const ImageCaptureFieldWidget({super.key, required this.field, this.error});

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
          style: theme.labelStyle ?? const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: error != null ? Colors.red : Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: value != null && value.isNotEmpty
              ? _buildImagePreview(context, value, controller, ref)
              : _buildCaptureButton(context, controller, ref),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
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

  Widget _buildCaptureButton(
    BuildContext context,
    dynamic controller,
    WidgetRef ref,
  ) {
    return InkWell(
      onTap: () => _captureImage(controller, ref),
      child: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Tap to capture image',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(
    BuildContext context,
    String base64Image,
    dynamic controller,
    WidgetRef ref,
  ) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            base64Decode(base64Image),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            children: [
              // Retake button
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () => _captureImage(controller, ref),
                  tooltip: 'Retake image',
                ),
              ),
              const SizedBox(width: 8),
              // Remove button
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => controller.updateField(field.id, null, ref),
                  tooltip: 'Remove image',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _captureImage(dynamic controller, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();

    try {
      // Capture image from camera
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        // Read image as bytes and convert to base64
        final bytes = await File(image.path).readAsBytes();
        final base64Image = base64Encode(bytes);

        // Update form state
        controller.updateField(field.id, base64Image, ref);
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
      // You could show a snackbar or error dialog here
    }
  }
}
