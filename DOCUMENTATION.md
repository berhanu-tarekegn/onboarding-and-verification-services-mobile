# Kifiya Rendering Engine Documentation

**Kifiya Rendering Engine** is a robust Flutter plugin designed to generate dynamic, schema-driven forms. It abstracts the complexity of form building, validation, and state management, allowing developers to render complex forms entirely from JSON configurations.

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Getting Started](#getting-started)
3. [Schema Reference](#schema-reference)
    - [FormSchema](#formschema)
    - [FieldSchema](#fieldschema)
    - [Field Types](#field-types)
4. [Customization](#customization)
    - [Theming](#theming)
    - [Layout](#layout)
    - [Custom Builders](#custom-builders)
5. [Advanced Features](#advanced-features)
    - [Sequential File Uploads](#sequential-file-uploads)
    - [Signature Pad](#signature-pad)
    - [Dependency & Visibility](#dependency--visibility)

---

## Architecture Overview

The engine is built on **Flutter Riverpod** for reactive state management. It follows a unidirectional data flow:
1. **Schema Input**: A JSON `FormSchema` defines the structure.
2. **State Initialization**: The engine initializes a `DynamicFormController` with controllers for each field.
3. **Rendering**: Widgets are rendered based on `FieldType`. Layouts are handled by `FormLayoutBuilder`.
4. **Interaction**: User input updates the Riverpod state.
5. **Validation**: Validation rules (`required`, `regex`) are applied reactively or on submit.
6. **Submission**: Valid data is returned via the `onSubmit` callback.

---

## Getting Started

### Installation
Add the package to your `pubspec.yaml`:
```yaml
dependencies:
  kifiya_rendering_engine:
    path: ./path/to/kifiya_rendering_engine
```

### Basic Usage
The core widget is `DynamicForm`. It requires a `FormSchema` and an `onSubmit` callback.

```dart
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';

final mySchema = FormSchema(
  title: 'Registration Form',
  submitApiUrl: '/api/submit',
  nextFormApiUrl: '/api/next',
  fields: [
    FieldSchema(
      id: 'full_name',
      type: FieldType.text,
      label: 'Full Name',
      required: true,
    ),
    FieldSchema(
      id: 'role',
      type: FieldType.dropdown,
      label: 'Role',
      options: ['Developer', 'Designer', 'Manager'],
    ),
  ],
);

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: DynamicForm(
      schema: mySchema,
      onSubmit: (data) {
        print('Form Data: $data');
      },
    ),
  );
}
```

---

## Schema Reference

### FormSchema
The root configuration object.

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String` | Title of the form. |
| `fields` | `List<FieldSchema>` | List of fields to render. |
| `submitApiUrl` | `String` | URL for submission key. |
| `nextFormApiUrl` | `String` | URL for next step in flow. |
| `sequentialFileUpload` | `bool` | If `true`, file fields enable sequentially. |
| `buttonColor` | `String` | **Deprecated**. Use `theme` instead. |

### FieldSchema
Defines a single form field.

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier key for data. |
| `type` | `FieldType` | The type of widget to render. |
| `label` | `String` | Display label. |
| `required` | `bool` | If `true`, field cannot be empty. |
| `defaultValue` | `dynamic` | Initial value. |
| `options` | `List<String>` | Options for `dropdown` or `radio`. |
| `regex` | `String` | Regex pattern for validation. |
| `dateFormat` | `String` | Format for date display (e.g., 'yyyy-MM-dd'). |
| `minDate`, `maxDate` | `DateTime` | Constraints for date picker. |
| `dependsOn` | `String` | ID of field this field depends on. |
| `visibleWhenEquals` | `dynamic` | Value of dependency to trigger visibility. |
| `rowGroup` | `String` | Group ID for side-by-side layout. |
| `flex` | `double` | Flex weight in row (default 1.0). |
| `startNewRow` | `bool` | Force field to start a new row. |

### Field Types
Supported types in `FieldType` enum:
- `text`: Standard text input.
- `dropdown`: Dropdown selection.
- `radio`: Radio button group.
- `checkbox`: Checkbox (boolean).
- `date`: Date picker.
- `fileUpload`: specialized widget for file selection.
- `signature`: Drawing pad for signatures.

---

## Customization

### Theming
Style your form using `KifiyaFormTheme` inherited widget or the `theme` parameter.

```dart
DynamicForm(
  schema: schema,
  theme: KifiyaFormThemeData(
    textFieldDecoration: InputDecoration(filled: true, fillColor: Colors.grey[200]),
    submitButtonStyle: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
    checkboxActiveColor: Colors.purple,
  ),
  onSubmit: (val) {},
)
```

### Layout
Control general layout structure via `FormLayoutConfig`.
```dart
DynamicForm(
  layout: FormLayoutConfig.grid(gridColumns: 2), // Grid layout
  // ...
)
```

### Custom Builders
Replace default widgets with your own implementation globally.
```dart
DynamicForm(
  builders: FormBuilders(
    textFieldBuilder: (context, field, value, error, onChanged) {
      return MyCustomTextField(label: field.label, error: error);
    },
  ),
  // ...
)
```

---

## Advanced Features

### Sequential File Uploads
Enable `sequentialFileUpload: true` in `FormSchema`.
- The first file upload field is active by default.
- Subsequent file fields remain disabled until the previous file field is "complete".
- **Complete** means the file is selected, and (if applicable) metadata like Document Number and Expiry Date are filled.

### File Upload Data Model
File fields return a structured object (serialized):
```json
{
  "filePath": "/path/to/file.jpg",
  "documentNumber": "DOC-123",
  "issuedDate": "2023-01-01",
  "expiredDate": "2024-01-01"
}
```

### Signature Pad
The `signature` field type provides a drawing canvas.
- Returns base64 encoded PNG image data.
- Built-in toolbar for clearing, saving, and changing pen color.
- Validates that a signature has been drawn before submission if required.

### Dependency & Visibility
Fields can be dynamic based on other fields.
```dart
FieldSchema(
  id: 'has_car',
  type: FieldType.checkbox,
  label: 'Do you own a car?',
),
FieldSchema(
  id: 'car_model',
  type: FieldType.text,
  label: 'Car Model',
  dependsOn: 'has_car',
  visibleWhenEquals: true, // Only visible if 'has_car' is true
)
```
