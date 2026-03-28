import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';
import 'custom_widget_factory.dart';

/// Example page demonstrating the custom widget factory.
/// This shows how apps can provide their own UI while the engine handles logic.
class CustomFactoryExamplePage extends StatelessWidget {
  const CustomFactoryExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Widget Factory Example'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ProviderScope(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Custom UI with Engine Logic',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This form uses a custom widget factory to render completely '
                'custom UI while the rendering engine handles all the logic '
                '(state management, validation, visibility, etc.)',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              DynamicForm(
                schema: _createExampleSchema(),
                widgetFactory: const CustomWidgetFactory(),
                showSubmitButton: true,
                onSubmit: (values) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Form submitted: $values'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  FormSchema _createExampleSchema() {
    return FormSchema(
      submitApiUrl: "",
      sequentialFileUpload: true,
      nextFormApiUrl: "assets/form.json",
      title: 'Custom Factory Demo',
      buttonColor: '0xFF673AB7',
      fields: [
        const FieldSchema(
          id: 'name',
          type: FieldType.text,
          label: 'Full Name',
          required: true,
        ),
        const FieldSchema(
          id: 'email',
          type: FieldType.text,
          label: 'Email Address',
          required: true,
          keyboardType: KeyboardInputType.email,
        ),
        FieldSchema(
          id: 'gender',
          type: FieldType.radio,
          label: 'Gender',
          required: true,
          options: ['Male', 'Female', 'Other'],
        ),
        FieldSchema(
          id: 'country',
          type: FieldType.dropdown,
          label: 'Country',
          required: true,
          options: ['USA', 'Canada', 'UK', 'Australia', 'Ethiopia'],
        ),
        const FieldSchema(
          id: 'birthdate',
          type: FieldType.date,
          label: 'Date of Birth',
          required: true,
        ),
        const FieldSchema(
          id: 'profile_photo',
          type: FieldType.imageCapture,
          label: 'Profile Photo',
          required: false,
        ),
        const FieldSchema(
          id: 'terms',
          type: FieldType.checkbox,
          label: 'I agree to the terms and conditions',
          required: true,
        ),
      ],
    );
  }
}
