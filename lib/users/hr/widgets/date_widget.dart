import 'package:flutter/material.dart';

class DateFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const DateFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select Date',
        prefixIcon: const Icon(Icons.calendar_month),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}