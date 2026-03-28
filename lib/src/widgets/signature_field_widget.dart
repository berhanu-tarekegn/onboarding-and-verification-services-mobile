import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine/src/theme/form_theme.dart';

class SignatureFieldWidget extends ConsumerStatefulWidget {
  final FieldSchema field;
  final String? error;

  const SignatureFieldWidget({super.key, required this.field, this.error});

  @override
  ConsumerState<SignatureFieldWidget> createState() =>
      _SignatureFieldWidgetState();
}

class _SignatureFieldWidgetState extends ConsumerState<SignatureFieldWidget> {
  late SignatureController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with default values - will be updated in didChangeDependencies
    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final theme = KifiyaFormTheme.maybeOf(context);
      // Reinitialize with theme colors if available
      _controller.dispose();
      _controller = SignatureController(
        penStrokeWidth: 2,
        penColor: theme?.signaturePenColor ?? Colors.black,
        exportBackgroundColor: theme?.signatureBackgroundColor ?? Colors.white,
      );
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveSignature() async {
    if (_controller.isNotEmpty) {
      Uint8List? data = await _controller.toPngBytes();
      if (data != null) {
        String base64Signature = base64Encode(data);
        ref
            .read(formControllerProvider.notifier)
            .updateField(widget.field.id, base64Signature, ref);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Signature saved!'),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please draw your signature first'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = KifiyaFormTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.label,
          style: theme.labelStyle ?? Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.2),
                color: theme.signatureBackgroundColor ?? Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Signature(
                  controller: _controller,
                  backgroundColor:
                      theme.signatureBackgroundColor ?? Colors.grey[200]!,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            _controller.clear();
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(24, 24),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          tooltip: 'Clear',
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: _saveSignature,
                          icon: const Icon(Icons.check, size: 16),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(24, 24),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          tooltip: 'Save',
                        ),
                        const SizedBox(width: 8),
                        // Color Picker
                        PopupMenuButton<Color>(
                          tooltip: 'Change Color',
                          offset: const Offset(
                            0,
                            -120,
                          ), // Show above the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          icon: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _controller.penColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                          ),
                          onSelected: (Color color) {
                            setState(() {
                              _controller = SignatureController(
                                penColor: color,
                                penStrokeWidth: _controller.penStrokeWidth,
                                exportBackgroundColor:
                                    _controller.exportBackgroundColor,
                                points: _controller.points,
                              );
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<Color>>[
                                const PopupMenuItem<Color>(
                                  value: Colors.black,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.black,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Black'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<Color>(
                                  value: Colors.blue,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.blue,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Blue'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<Color>(
                                  value: Colors.red,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Red'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<Color>(
                                  value: Colors.green,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.green,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Green'),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.error!,
              style:
                  theme.errorTextStyle ??
                  TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}
