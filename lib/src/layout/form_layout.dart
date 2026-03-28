import 'package:flutter/material.dart';
import '../models/field_schema.dart';

/// Enum defining the available layout types for the form.
enum FormLayoutType {
  /// Fields arranged vertically (default)
  vertical,

  /// Fields arranged horizontally in a row
  horizontal,

  /// Fields arranged in a grid with configurable columns
  grid,

  /// Fields wrap to next line when space runs out
  wrap,
}

/// Layout hints for individual fields.
///
/// Use this to customize how specific fields behave within the layout.
class FieldLayoutHint {
  /// For grid layout: how many columns this field should span
  final int? columnSpan;

  /// For horizontal layout: flex value for this field
  final double? flex;

  /// Force this field to start on a new row/line
  final bool startNewRow;

  /// Custom padding for this specific field
  final EdgeInsets? padding;

  const FieldLayoutHint({
    this.columnSpan,
    this.flex,
    this.startNewRow = false,
    this.padding,
  });
}

/// Configuration for form layout.
///
/// Controls how fields are arranged in the form.
class FormLayoutConfig {
  /// The type of layout to use
  final FormLayoutType type;

  /// Number of columns for grid layout
  final int gridColumns;

  /// Spacing between fields (vertical or horizontal depending on layout)
  final double spacing;

  /// Spacing between rows (for wrap and grid layouts)
  final double runSpacing;

  /// Padding around each field
  final EdgeInsets fieldPadding;

  /// Per-field layout hints, keyed by field ID
  final Map<String, FieldLayoutHint>? fieldHints;

  /// Cross-axis alignment for vertical/horizontal layouts
  final CrossAxisAlignment crossAxisAlignment;

  /// Main-axis alignment for horizontal layouts
  final MainAxisAlignment mainAxisAlignment;

  const FormLayoutConfig({
    this.type = FormLayoutType.vertical,
    this.gridColumns = 2,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.fieldPadding = EdgeInsets.zero,
    this.fieldHints,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  /// Vertical layout (default)
  const FormLayoutConfig.vertical({
    this.spacing = 16.0,
    this.fieldPadding = EdgeInsets.zero,
    this.fieldHints,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  }) : type = FormLayoutType.vertical,
       gridColumns = 1,
       runSpacing = 16.0,
       mainAxisAlignment = MainAxisAlignment.start;

  /// Horizontal layout
  const FormLayoutConfig.horizontal({
    this.spacing = 16.0,
    this.fieldPadding = EdgeInsets.zero,
    this.fieldHints,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : type = FormLayoutType.horizontal,
       gridColumns = 1,
       runSpacing = 16.0;

  /// Grid layout
  const FormLayoutConfig.grid({
    required this.gridColumns,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.fieldPadding = EdgeInsets.zero,
    this.fieldHints,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : type = FormLayoutType.grid,
       mainAxisAlignment = MainAxisAlignment.start;

  /// Wrap layout
  const FormLayoutConfig.wrap({
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.fieldPadding = EdgeInsets.zero,
    this.fieldHints,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : type = FormLayoutType.wrap,
       gridColumns = 1,
       mainAxisAlignment = MainAxisAlignment.start;

  /// Gets the layout hint for a specific field, if any
  FieldLayoutHint? getHintForField(String fieldId) {
    return fieldHints?[fieldId];
  }

  /// Creates a copy with some values replaced
  FormLayoutConfig copyWith({
    FormLayoutType? type,
    int? gridColumns,
    double? spacing,
    double? runSpacing,
    EdgeInsets? fieldPadding,
    Map<String, FieldLayoutHint>? fieldHints,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    return FormLayoutConfig(
      type: type ?? this.type,
      gridColumns: gridColumns ?? this.gridColumns,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      fieldPadding: fieldPadding ?? this.fieldPadding,
      fieldHints: fieldHints ?? this.fieldHints,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
    );
  }
}

/// A field with its associated widget for layout purposes.
class FieldWithWidget {
  final FieldSchema field;
  final Widget widget;

  const FieldWithWidget({required this.field, required this.widget});
}

/// Widget that renders a list of fields according to a [FormLayoutConfig].
///
/// This handles field-level layout control including:
/// - Row grouping (fields with same rowGroup appear side-by-side)
/// - Flex values for proportional sizing
/// - Column spans for grid layouts
///
/// Example with row groups:
/// ```dart
/// FormLayoutBuilder(
///   config: FormLayoutConfig.vertical(),
///   fieldsWithWidgets: [
///     FieldWithWidget(field: nameField, widget: nameWidget),
///     // These two will appear side-by-side
///     FieldWithWidget(field: checkbox1.copyWith(rowGroup: 'terms'), widget: w1),
///     FieldWithWidget(field: checkbox2.copyWith(rowGroup: 'terms'), widget: w2),
///   ],
/// )
/// ```
class FormLayoutBuilder extends StatelessWidget {
  final FormLayoutConfig config;

  /// List of fields with their corresponding widgets.
  /// Used for field-level layout control (row groups, flex, etc.)
  final List<FieldWithWidget>? fieldsWithWidgets;

  /// Simple list of widgets (for backward compatibility, no field-level control)
  final List<Widget>? children;

  const FormLayoutBuilder({
    super.key,
    required this.config,
    this.fieldsWithWidgets,
    this.children,
  }) : assert(
         fieldsWithWidgets != null || children != null,
         'Either fieldsWithWidgets or children must be provided',
       );

  @override
  Widget build(BuildContext context) {
    // Use simple children if provided (backward compatible)
    if (fieldsWithWidgets == null) {
      return _buildSimpleLayout(children!);
    }

    // Group fields by rowGroup for field-level layout control
    final groupedItems = _groupFieldsByRowGroup(fieldsWithWidgets!);

    // Build layout with grouped rows
    return _buildGroupedLayout(groupedItems);
  }

  /// Groups consecutive fields that share the same rowGroup
  List<List<FieldWithWidget>> _groupFieldsByRowGroup(
    List<FieldWithWidget> items,
  ) {
    final groups = <List<FieldWithWidget>>[];
    List<FieldWithWidget>? currentGroup;
    String? currentGroupId;

    for (final item in items) {
      final rowGroup = item.field.rowGroup;
      final startNewRow = item.field.startNewRow;

      if (startNewRow && currentGroup != null) {
        // Force new row
        groups.add(currentGroup);
        currentGroup = null;
        currentGroupId = null;
      }

      if (rowGroup != null) {
        // Field belongs to a group
        if (currentGroupId == rowGroup) {
          // Add to existing group
          currentGroup!.add(item);
        } else {
          // Start new group
          if (currentGroup != null) {
            groups.add(currentGroup);
          }
          currentGroup = [item];
          currentGroupId = rowGroup;
        }
      } else {
        // Field is standalone
        if (currentGroup != null) {
          groups.add(currentGroup);
          currentGroup = null;
          currentGroupId = null;
        }
        groups.add([item]);
      }
    }

    // Add remaining group
    if (currentGroup != null) {
      groups.add(currentGroup);
    }

    return groups;
  }

  Widget _buildGroupedLayout(List<List<FieldWithWidget>> groups) {
    final List<Widget> rows = [];

    for (final group in groups) {
      if (group.length == 1) {
        // Single field - render normally
        rows.add(_wrapWithPadding(group.first.widget));
      } else {
        // Multiple fields in a row - render side-by-side
        rows.add(_buildRowGroup(group));
      }
    }

    return Column(
      crossAxisAlignment: config.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: _addSpacing(rows, config.spacing),
    );
  }

  Widget _buildRowGroup(List<FieldWithWidget> group) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _addSpacing(
        group.map((item) {
          return Expanded(
            flex: (item.field.flex * 100).round(), // Convert double to int flex
            child: _wrapWithPadding(item.widget),
          );
        }).toList(),
        config.spacing,
      ),
    );
  }

  Widget _buildSimpleLayout(List<Widget> widgets) {
    // Wrap children with field padding if needed
    final wrappedChildren = widgets
        .map((child) => _wrapWithPadding(child))
        .toList();

    switch (config.type) {
      case FormLayoutType.vertical:
        return Column(
          crossAxisAlignment: config.crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: _addSpacing(wrappedChildren, config.spacing),
        );

      case FormLayoutType.horizontal:
        return Row(
          mainAxisAlignment: config.mainAxisAlignment,
          crossAxisAlignment: config.crossAxisAlignment,
          children: _addSpacing(
            wrappedChildren.map((child) => Expanded(child: child)).toList(),
            config.spacing,
          ),
        );

      case FormLayoutType.grid:
        return _buildGrid(wrappedChildren);

      case FormLayoutType.wrap:
        return Wrap(
          spacing: config.spacing,
          runSpacing: config.runSpacing,
          crossAxisAlignment: _mapCrossAxisToWrap(config.crossAxisAlignment),
          children: wrappedChildren,
        );
    }
  }

  Widget _wrapWithPadding(Widget child) {
    if (config.fieldPadding == EdgeInsets.zero) {
      return child;
    }
    return Padding(padding: config.fieldPadding, child: child);
  }

  Widget _buildGrid(List<Widget> items) {
    final List<Widget> rows = [];
    int currentIndex = 0;

    while (currentIndex < items.length) {
      final List<Widget> rowChildren = [];
      int columnsUsed = 0;

      while (columnsUsed < config.gridColumns && currentIndex < items.length) {
        final remaining = config.gridColumns - columnsUsed;
        final span = 1;

        if (span <= remaining) {
          rowChildren.add(Expanded(flex: span, child: items[currentIndex]));
          columnsUsed += span;
          currentIndex++;
        } else {
          break;
        }
      }

      // Fill remaining space with empty expanded widgets
      while (columnsUsed < config.gridColumns) {
        rowChildren.add(const Expanded(child: SizedBox.shrink()));
        columnsUsed++;
      }

      rows.add(
        Row(
          crossAxisAlignment: config.crossAxisAlignment,
          children: _addSpacing(rowChildren, config.spacing),
        ),
      );
    }

    return Column(
      crossAxisAlignment: config.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: _addSpacing(rows, config.runSpacing),
    );
  }

  WrapCrossAlignment _mapCrossAxisToWrap(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return WrapCrossAlignment.start;
      case CrossAxisAlignment.end:
        return WrapCrossAlignment.end;
      case CrossAxisAlignment.center:
        return WrapCrossAlignment.center;
      default:
        return WrapCrossAlignment.start;
    }
  }

  List<Widget> _addSpacing(List<Widget> widgets, double spacing) {
    if (widgets.isEmpty || spacing == 0) return widgets;

    final result = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(SizedBox(width: spacing, height: spacing));
      }
    }
    return result;
  }
}
