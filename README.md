# Kifiya Rendering Engine

A Flutter plugin that dynamically generates forms based on a JSON schema. This engine supports various field types, validation, and customization options.

## Features

*   **Dynamic Form Generation:** Create forms on the fly from a JSON schema.
*   **Variety of Field Types:** Supports a wide range of input fields:
    *   Text
    *   Radio buttons
    *   Dropdowns
    *   Date pickers
    *   Checkboxes
    *   File uploads
    *   Signature pads
*   **Customization:** Easily customize the appearance of form elements to match your app's design.
*   **State Management:** Built with Riverpod for robust state management.
*   **Validation:** Comes with built-in validation logic.

## Getting Started

To use this plugin, you need to provide a `FormSchema` object to the `DynamicForm` widget.

### `FormSchema`

The `FormSchema` defines the structure of the form. It requires the following:

*   `title`: The title of the form.
*   `fields`: A list of `FieldSchema` objects, each representing a form field.
*   `submitApiUrl`: The URL where the form data will be submitted.
*   `buttonColor`: The color of the submit button.
*   `nextFormApiUrl`: The URL to fetch the next form schema.

### `FieldSchema`

Each field in the form is defined by a `FieldSchema`, which contains properties like `id`, `type`, `label`, `required`, and other type-specific attributes.

## Usage

Here's a basic example of how to use the `DynamicForm` widget:

'''dart
import 'package:flutter/material.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';

class MyFormPage extends StatelessWidget {
  final formSchema = FormSchema(
    title: 'My Dynamic Form',
    fields: [
      // Define your FieldSchema objects here
    ],
    submitApiUrl: 'https://api.example.com/submit',
    buttonColor: '#FF5722',
    nextFormApiUrl: 'https://api.example.com/next_form',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formSchema.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: DynamicForm(
          schema: formSchema,
          onSubmit: (formData) {
            // Handle form submission
            print(formData);
          },
        ),
      ),
    );
  }
}
'''

## Customization

You can customize the look and feel of the form widgets by passing various decoration and style parameters to the `DynamicForm` widget.

*   `inputDecoration`: For text fields.
*   `dropDownDecoration`: For dropdown fields.
*   `datePickerDecoration`: For date fields.
*   `buttonStyle`: For buttons.
*   `textStyle`: For text elements.
*   And many more...
