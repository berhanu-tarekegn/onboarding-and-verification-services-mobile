import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kifiya_rendering_engine/src/builders/form_widget_factory.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/models/form_schema.dart';

/// Example custom widget factory demonstrating how to implement
/// completely custom UI while the engine handles all the logic.
///
/// This factory creates widgets with a custom purple theme and
/// different visual styles to showcase the separation of UI and logic.
class CustomWidgetFactory implements FormWidgetFactory {
  const CustomWidgetFactory();

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
        Text(
          field.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: TextEditingController(text: value)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: value?.length ?? 0),
              ),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Enter ${field.label.toLowerCase()}',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: value ?? false,
                onChanged: onChanged,
                activeColor: Colors.deepPurple,
              ),
              Expanded(
                child: Text(
                  field.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 12),
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
        Text(
          field.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text('Select ${field.label.toLowerCase()}'),
            items: field.options?.map((option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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
        Text(
          field.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
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
                              activeColor: Colors.deepPurple,
                            ),
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(fontSize: 14),
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
                        title: Text(option),
                        value: option,
                        groupValue: value,
                        onChanged: onChanged,
                        activeColor: Colors.deepPurple,
                      );
                    }),
                  ],
                ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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
        Text(
          field.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: field.minDate ?? DateTime(1900),
              lastDate: field.maxDate ?? DateTime(2100),
            );
            if (date != null) {
              onChanged(date);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Text(
                  value != null
                      ? '${value.day}/${value.month}/${value.year}'
                      : 'Select date',
                  style: TextStyle(
                    fontSize: 16,
                    color: value != null ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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
        Text(
          field.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.upload_file, color: Colors.deepPurple),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value ?? 'No file selected',
                  style: TextStyle(
                    color: value != null ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Simulate file selection
                  onChanged('example_file.pdf');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text('Choose File'),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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
        Text(
          field.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: Center(
            child: Text(
              value != null ? 'Signature captured' : 'Tap to sign',
              style: TextStyle(
                color: value != null ? Colors.deepPurple : Colors.grey,
              ),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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
        Text(
          field.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: error != null ? Colors.red : Colors.deepPurple,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepPurple.shade50,
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
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
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
                          Icons.camera_alt,
                          size: 64,
                          color: Colors.deepPurple.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap to capture image',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purpleAccent],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 8,
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
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isSubmitting ? 'Submitting...' : 'Submit Form',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
