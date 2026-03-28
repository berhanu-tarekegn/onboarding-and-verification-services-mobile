import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kifiya_rendering_engine/src/builders/form_widget_factory.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/models/form_schema.dart';
import 'package:kifiya_rendering_engine_example/theme/futuristic_mesh_background.dart';

/// Example custom widget factory demonstrating how to implement
/// completely custom UI while the engine handles all the logic.
///
/// Dark glass + cyan accent — aligned with landing, KYB shell, and success screen.
class CustomWidgetFactory implements FormWidgetFactory {
  const CustomWidgetFactory();

  static const _cyan = FuturisticMeshBackground.cyan;
  static const _violet = FuturisticMeshBackground.violet;

  static TextStyle get _labelStyle => TextStyle(
        fontWeight: FontWeight.w600,
        color: _cyan.withValues(alpha: 0.9),
        fontSize: 13,
        letterSpacing: 0.8,
      );

  static BoxDecoration get _fieldShell => BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        color: Colors.white.withValues(alpha: 0.05),
        boxShadow: [
          BoxShadow(
            color: _cyan.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static TextStyle get _bodyLight => TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 15,
      );

  @override
  Widget createTextField({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: _labelStyle),
        const SizedBox(height: 10),
        Container(
          decoration: _fieldShell,
          child: TextField(
            controller: TextEditingController(text: value)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: value?.length ?? 0),
              ),
            onChanged: onChanged,
            cursorColor: _cyan,
            style: _bodyLight,
            decoration: InputDecoration(
              hintText: 'Enter ${field.label.toLowerCase()}',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget createCheckbox({
    required BuildContext context,
    required FieldSchema field,
    required bool? value,
    required String? error,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        color: Colors.white.withValues(alpha: 0.04),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: value ?? false,
                onChanged: onChanged,
                activeColor: _cyan,
                checkColor: const Color(0xFF0a0f1a),
                side: BorderSide(color: _cyan.withValues(alpha: 0.5)),
              ),
              Expanded(
                child: Text(
                  field.label,
                  style: _bodyLight.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(
                error,
                style: TextStyle(color: Colors.red.shade300, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget createDropdown({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: _labelStyle),
        const SizedBox(height: 10),
        Container(
          decoration: _fieldShell,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: const Color(0xFF141c2e),
            underline: const SizedBox(),
            iconEnabledColor: _cyan.withValues(alpha: 0.85),
            style: _bodyLight,
            hint: Text(
              'Select ${field.label.toLowerCase()}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            ),
            items: field.options?.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option, style: _bodyLight),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade300, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget createRadio({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    // Check if inline property is set
    final isInline = field.properties?.inline ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: _labelStyle),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            color: Colors.white.withValues(alpha: 0.04),
          ),
          padding: const EdgeInsets.all(8),
          child: isInline
              ? Row(
                  children: [
                    ...?field.options?.map((option) {
                      return Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: option,
                              groupValue: value,
                              onChanged: onChanged,
                              activeColor: _cyan,
                              fillColor: WidgetStateProperty.resolveWith(
                                (s) => s.contains(WidgetState.selected)
                                    ? _cyan
                                    : Colors.transparent,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                option,
                                style: _bodyLight.copyWith(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                )
              : Column(
                  children: [
                    ...?field.options?.map((option) {
                      return RadioListTile<String>(
                        title: Text(option, style: _bodyLight.copyWith(fontSize: 14)),
                        value: option,
                        groupValue: value,
                        onChanged: onChanged,
                        activeColor: _cyan,
                        fillColor: WidgetStateProperty.resolveWith(
                          (s) => s.contains(WidgetState.selected)
                              ? _cyan.withValues(alpha: 0.15)
                              : Colors.transparent,
                        ),
                      );
                    }),
                  ],
                ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade300, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget createDateField({
    required BuildContext context,
    required FieldSchema field,
    required DateTime? value,
    required String? error,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: _labelStyle),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: field.minDate ?? DateTime(1900),
              lastDate: field.maxDate ?? DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: _cyan,
                      surface: const Color(0xFF141c2e),
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              onChanged(date);
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: _fieldShell,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.calendar_month_rounded, color: _cyan.withValues(alpha: 0.9)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value != null
                        ? '${value.day}/${value.month}/${value.year}'
                        : 'Select date',
                    style: _bodyLight.copyWith(
                      color: value != null
                          ? Colors.white.withValues(alpha: 0.92)
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade300, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget createFileUpload({
    required BuildContext context,
    required FieldSchema field,
    required FormSchema schema,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    // For this example, we'll use a simple placeholder
    // In a real app, you'd integrate with file_picker or similar
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: _labelStyle),
        const SizedBox(height: 10),
        Container(
          decoration: _fieldShell,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.upload_file_rounded, color: _cyan.withValues(alpha: 0.85)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value ?? 'No file selected',
                  style: _bodyLight.copyWith(
                    color: value != null
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => onChanged('example_file.pdf'),
                style: TextButton.styleFrom(
                  foregroundColor: _cyan,
                  side: BorderSide(color: _cyan.withValues(alpha: 0.45)),
                ),
                child: const Text('Choose'),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade300, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget createSignature({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    // Placeholder for signature - in real app would use signature pad
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: _labelStyle),
        const SizedBox(height: 10),
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            color: Colors.white.withValues(alpha: 0.04),
          ),
          child: Center(
            child: Text(
              value != null ? 'Signature captured' : 'Tap to sign',
              style: TextStyle(
                color: value != null
                    ? _cyan.withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade300, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget createImageCapture({
    required BuildContext context,
    required FieldSchema field,
    required String? value,
    required String? error,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: _labelStyle),
        const SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: error != null
                  ? Colors.red.shade400
                  : Colors.white.withValues(alpha: 0.16),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withValues(alpha: 0.04),
          ),
          child: value != null && value.isNotEmpty
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        const Base64Decoder().convert(value),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cyan.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF0a0f1a)),
                          onPressed: () => onChanged(null),
                          tooltip: 'Remove image',
                        ),
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () async {
                    // Real camera implementation
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

                        // Update form state via onChanged callback
                        onChanged(base64Image);
                      }
                    } catch (e) {
                      // Show error if camera fails
                      print('Error capturing image: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error capturing image: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 56,
                          color: _cyan.withValues(alpha: 0.65),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap to capture image',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.55),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade300, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget createSubmitButton({
    required BuildContext context,
    required VoidCallback onSubmit,
    required bool isSubmitting,
  }) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _cyan.withValues(alpha: 0.45)),
        gradient: LinearGradient(
          colors: [
            _cyan.withValues(alpha: 0.35),
            _violet.withValues(alpha: 0.25),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _cyan.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          isSubmitting ? 'Submitting...' : 'Submit Form',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget wrapField({
    required BuildContext context,
    required FieldSchema field,
    required String? error,
    required Widget child,
  }) {
    // Add some spacing between fields
    return Padding(padding: const EdgeInsets.only(bottom: 20), child: child);
  }
}
