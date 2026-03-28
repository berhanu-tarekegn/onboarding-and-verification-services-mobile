# Kifiya Rendering Engine Plugin - QA Testing Guide

> **Version**: 1.0.0  
> **Last Updated**: January 2026  
> **Scope**: Plugin functionality testing (not example app)

---

## 1. Plugin Core Components

### 1.1 DynamicForm Widget

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| DF-001 | Instantiate `DynamicForm` with valid `FormSchema` | Widget renders without errors | Critical |
| DF-002 | `DynamicForm` with null schema | Graceful error handling, no crash | Critical |
| DF-003 | `onSubmit` callback receives form data | Callback invoked with `Map<String, dynamic>` on valid submission | Critical |
| DF-004 | `onSubmit` not called on invalid form | Callback NOT invoked if validation fails | Critical |
| DF-005 | `theme` parameter applies `KifiyaFormThemeData` | All child widgets reflect theme | High |
| DF-006 | `layout` parameter applies `FormLayoutConfig` | Layout changes per config (grid/list) | High |
| DF-007 | `builders` parameter overrides default field builders | Custom builders render instead of defaults | Medium |

---

### 1.2 FormSchema Parsing

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| FS-001 | `FormSchema.fromJson()` with valid JSON | Schema object created correctly | Critical |
| FS-002 | `FormSchema.fromJson()` with missing `title` | Error thrown or default applied | High |
| FS-003 | `FormSchema.fromJson()` with missing `fields` | Error thrown or empty list | High |
| FS-004 | `FormSchema.fromJson()` with extra unknown keys | Extra keys ignored, no crash | Medium |
| FS-005 | `title` property accessible | Returns correct string value | High |
| FS-006 | `submitApiUrl` property accessible | Returns correct URL string | High |
| FS-007 | `nextFormApiUrl` property accessible | Returns correct URL string | High |
| FS-008 | `sequentialFileUpload` defaults to `false` | Boolean defaults correctly | High |
| FS-009 | `sequentialFileUpload: true` in JSON | Property set to true | High |
| FS-010 | `buttonColor` (deprecated) still parses | Legacy support works | Low |

---

### 1.3 FieldSchema Parsing

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| FD-001 | `FieldSchema.fromJson()` with valid JSON | Schema object created | Critical |
| FD-002 | All `FieldType` enum values parse correctly | `text`, `dropdown`, `radio`, `date`, `checkbox`, `fileUpload`, `signature` | Critical |
| FD-003 | Unknown `type` value in JSON | Error thrown or graceful fallback | High |
| FD-004 | `required` defaults to `false` | Boolean defaults correctly | High |
| FD-005 | `flex` defaults to `1.0` | Double defaults correctly | Medium |
| FD-006 | `columnSpan` defaults to `1` | Integer defaults correctly | Medium |
| FD-007 | `startNewRow` defaults to `false` | Boolean defaults correctly | Medium |
| FD-008 | `options` parses as `List<String>` | Dropdown/radio options available | High |
| FD-009 | `regex` property parses | String pattern accessible | High |
| FD-010 | `minDate`/`maxDate` parse as `DateTime` | Date constraints accessible | High |
| FD-011 | `dependsOn` property parses | String ID accessible | High |
| FD-012 | `visibleWhenEquals` parses dynamic values | Supports string, bool, int | High |
| FD-013 | `keyboardType` enum parses | `text`, `number`, `email`, `phone` | Medium |
| FD-014 | `defaultValue` parses dynamic types | Supports string, bool, null | Medium |
| FD-015 | `dateFormat` parses | Format string accessible | Medium |
| FD-016 | `rowGroup` parses | Group ID string accessible | Medium |

---

## 2. Field Widget Rendering

### 2.1 TextFieldWidget

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| TF-001 | Renders for `FieldType.text` | TextField widget displayed | Critical |
| TF-002 | `label` displays correctly | Label text shown | High |
| TF-003 | `required` shows indicator | Required marker visible | High |
| TF-004 | `defaultValue` pre-populates | Field has initial value | Medium |
| TF-005 | `keyboardType` applies correct keyboard | Email/phone/number keyboards | Medium |
| TF-006 | Text input updates form state | State provider reflects changes | Critical |
| TF-007 | `regex` validation triggers | Invalid input shows error | High |

### 2.2 DropdownFieldWidget

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| DD-001 | Renders for `FieldType.dropdown` | Dropdown widget displayed | Critical |
| DD-002 | `options` populate dropdown items | All options selectable | Critical |
| DD-003 | Empty `options` array | Graceful handling | High |
| DD-004 | Selection updates form state | State provider reflects selection | Critical |
| DD-005 | `defaultValue` pre-selects option | Default option selected | Medium |

### 2.3 RadioFieldWidget

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| RD-001 | Renders for `FieldType.radio` | Radio buttons displayed | Critical |
| RD-002 | `options` create radio items | All options as buttons | Critical |
| RD-003 | Only one selectable at a time | Mutual exclusivity works | Critical |
| RD-004 | Selection updates form state | State provider reflects selection | Critical |
| RD-005 | `defaultValue` pre-selects | Default option selected | Medium |

### 2.4 DateFieldWidget

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| DT-001 | Renders for `FieldType.date` | Date picker trigger displayed | Critical |
| DT-002 | Tap opens date picker | Native picker appears | Critical |
| DT-003 | `dateFormat` displays selected date | Format applied correctly | High |
| DT-004 | `minDate` constrains picker | Dates before min disabled | High |
| DT-005 | `maxDate` constrains picker | Dates after max disabled | High |
| DT-006 | Selection updates form state | State provider reflects date | Critical |
| DT-007 | `defaultValue` pre-populates | Default date shown | Medium |

### 2.5 CheckboxFieldWidget

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| CB-001 | Renders for `FieldType.checkbox` | Checkbox widget displayed | Critical |
| CB-002 | `label` displays correctly | Label text shown | High |
| CB-003 | Toggle updates form state | State changes between true/false | Critical |
| CB-004 | `defaultValue: true` pre-checks | Checkbox initially checked | Medium |

### 2.6 FileFieldWidget / UploadContainer

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| FF-001 | Renders for `FieldType.fileUpload` | Upload container displayed | Critical |
| FF-002 | Tap triggers file picker | Native picker opens | Critical |
| FF-003 | Selected file shows preview/name | File info displayed | High |
| FF-004 | Metadata fields (doc number, dates) render | Input fields for metadata | High |
| FF-005 | File data updates form state | `FileUploadData` in state | Critical |
| FF-006 | Remove file clears state | State reset to null | High |
| FF-007 | Sequential mode: first field enabled | When `sequentialFileUpload: true` | High |
| FF-008 | Sequential mode: subsequent disabled | Locked until previous complete | High |
| FF-009 | Sequential mode: unlocks on complete | Previous file + metadata filled | High |

### 2.7 SignatureFieldWidget

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| SG-001 | Renders for `FieldType.signature` | Signature canvas displayed | Critical |
| SG-002 | Drawing on canvas works | Strokes appear | Critical |
| SG-003 | Clear button clears canvas | All strokes removed | High |
| SG-004 | Save button captures signature | Base64 PNG generated | Critical |
| SG-005 | Color picker changes pen color | New strokes use color | Medium |
| SG-006 | Saved signature updates form state | Base64 string in state | Critical |
| SG-007 | Toolbar renders correctly | Clear/Save/Color accessible | High |

---

## 3. Validation Engine

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| VE-001 | `required: true` field empty on submit | Validation error returned | Critical |
| VE-002 | `required: true` field filled | No validation error | Critical |
| VE-003 | `required: false` field empty | No validation error | High |
| VE-004 | `regex` pattern match | No validation error | High |
| VE-005 | `regex` pattern mismatch | Validation error with message | High |
| VE-006 | Empty field with `regex` (required) | "Required" error, not regex error | Medium |
| VE-007 | Multiple validation errors | All errors collected and shown | High |
| VE-008 | Validation error clears on valid input | Error disappears | High |
| VE-009 | `minDate` constraint violated | Date validation error | High |
| VE-010 | `maxDate` constraint violated | Date validation error | High |
| VE-011 | Signature required but empty | Validation error | High |
| VE-012 | File required but not selected | Validation error | High |

---

## 4. State Management (Riverpod Providers)

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| SM-001 | `DynamicFormController` initializes | Controllers created for all fields | Critical |
| SM-002 | Field value changes update provider state | `ref.watch` receives updates | Critical |
| SM-003 | Form data collected on submit | All field values in result map | Critical |
| SM-004 | Hidden field data excluded | `dependsOn` hidden fields not in data | High |
| SM-005 | File upload data structured correctly | Contains `filePath`, `documentNumber`, dates | High |
| SM-006 | Signature data as base64 | String encoded PNG | High |
| SM-007 | State resets on schema change | New schema clears old state | Medium |
| SM-008 | Sequential file upload state tracked | Unlock state computed correctly | High |

---

## 5. Conditional Visibility (dependsOn)

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| CV-001 | `dependsOn` field hidden initially | Condition not met = hidden | Critical |
| CV-002 | `visibleWhenEquals` string match | Field shows when value matches | Critical |
| CV-003 | `visibleWhenEquals` boolean match | Checkbox true/false triggers | Critical |
| CV-004 | `visibleWhenEquals` hides on mismatch | Value changes = field hides | High |
| CV-005 | Nested dependencies work | A → B → C chain | Medium |
| CV-006 | Hidden field excluded from validation | Required hidden field passes | High |
| CV-007 | Hidden field excluded from submit data | Not in `onSubmit` map | High |

---

## 6. Layout System

### 6.1 FormLayoutBuilder

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| LB-001 | Default layout renders vertically | Fields stack vertically | High |
| LB-002 | `FormLayoutConfig.grid(gridColumns: 2)` | 2-column grid layout | Medium |
| LB-003 | `FormLayoutConfig.grid(gridColumns: 3)` | 3-column grid layout | Medium |

### 6.2 Field-Level Layout

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| FL-001 | `rowGroup` groups fields horizontally | Same group = same row | High |
| FL-002 | Different `rowGroup` = different rows | Grouping works correctly | High |
| FL-003 | `flex` controls width ratio | `flex: 2` = double width | Medium |
| FL-004 | `columnSpan` in grid | Field spans columns | Medium |
| FL-005 | `startNewRow: true` forces new row | Field breaks to new line | Medium |

---

## 7. Theming (KifiyaFormTheme)

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| TH-001 | `KifiyaFormThemeData` applies to text fields | `textFieldDecoration` used | Medium |
| TH-002 | `submitButtonStyle` styles button | Button appearance changes | Medium |
| TH-003 | `checkboxActiveColor` applies | Checkbox fill color | Low |
| TH-004 | Theme inheritance from parent | Nested widget gets theme | Medium |
| TH-005 | No theme = default styling | Falls back to Material defaults | Medium |

---

## 8. Custom Builders (FormBuilders)

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| FB-001 | `textFieldBuilder` overrides default | Custom widget renders for text | Medium |
| FB-002 | `dropdownBuilder` overrides default | Custom widget for dropdown | Medium |
| FB-003 | Builder receives correct params | `field`, `value`, `error`, `onChanged` | High |
| FB-004 | Partial builders work | Only specified types overridden | Medium |
| FB-005 | Builder `onChanged` updates state | State syncs with custom widget | High |

---

## 9. Data Models

### 9.1 FileUploadData

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| FD-001 | `FileUploadData` serializes to JSON | `toJson()` returns map | High |
| FD-002 | `filePath` property accessible | String path value | High |
| FD-003 | `documentNumber` property accessible | String value | Medium |
| FD-004 | `issuedDate` property accessible | String date | Medium |
| FD-005 | `expiredDate` property accessible | String date | Medium |
| FD-006 | `FileUploadData.fromJson()` parses | Object created from map | High |
| FD-007 | `isComplete` getter works | True when file + metadata filled | High |

---

## 10. Error Handling

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| EH-001 | Invalid JSON schema | Parse error thrown, no crash | Critical |
| EH-002 | Unknown `FieldType` string | Graceful handling | High |
| EH-003 | Null `options` for dropdown | Empty list or error | High |
| EH-004 | Invalid `regex` pattern | Error caught, field works | Medium |
| EH-005 | Invalid date format string | Fallback to default format | Medium |
| EH-006 | `dependsOn` references missing field | Graceful handling | Medium |

---

## 11. Integration Points

| TC ID | Test Case | Expected Behavior | Priority |
|-------|-----------|-------------------|----------|
| IP-001 | Plugin exports all public APIs | `kifiya_rendering_engine.dart` barrel | High |
| IP-002 | `DynamicForm` is exported | Accessible to consumers | Critical |
| IP-003 | `FormSchema` is exported | Accessible to consumers | Critical |
| IP-004 | `FieldSchema` is exported | Accessible to consumers | Critical |
| IP-005 | `FieldType` enum is exported | Accessible to consumers | Critical |
| IP-006 | `KifiyaFormThemeData` is exported | Accessible to consumers | High |
| IP-007 | `FormLayoutConfig` is exported | Accessible to consumers | High |
| IP-008 | `FormBuilders` is exported | Accessible to consumers | Medium |

---

## 12. Test Data Samples

### Valid FormSchema JSON
```json
{
  "title": "Test Form",
  "submitApiUrl": "/api/submit",
  "nextFormApiUrl": "/api/next",
  "sequentialFileUpload": false,
  "fields": [
    {"id": "name", "type": "text", "label": "Name", "required": true},
    {"id": "role", "type": "dropdown", "label": "Role", "options": ["A", "B"]}
  ]
}
```

### FieldSchema with All Properties
```json
{
  "id": "test_field",
  "type": "text",
  "label": "Test",
  "required": true,
  "defaultValue": "default",
  "regex": "^[A-Z]+$",
  "keyboardType": "text",
  "rowGroup": "group1",
  "flex": 1.5,
  "columnSpan": 2,
  "startNewRow": true
}
```

### Conditional Visibility
```json
{
  "id": "details",
  "type": "text",
  "label": "Details",
  "dependsOn": "show_details",
  "visibleWhenEquals": true
}
```

---

## Bug Report Template

| Field | Value |
|-------|-------|
| **TC ID** | |
| **Component** | (e.g., SignatureFieldWidget, ValidationEngine) |
| **Summary** | |
| **Steps** | |
| **Expected** | |
| **Actual** | |
| **Schema JSON** | |
| **Severity** | Critical / High / Medium / Low |
