import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final double? width;
  final List<String> items;
  final void Function(String value)? onChanged;
  final String? Function(String?)? validator;

  final IconData? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.width,
    this.onChanged,
    this.validator,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: DropdownButtonFormField<String>(
        value: (value == null || value!.isEmpty) ? null : value,
        isExpanded: true,
        validator: validator,

        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.textSecondaryColor,
        ),

        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),

        decoration: InputDecoration(
          labelText: label,

          labelStyle: const TextStyle(
            color: AppColors.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),

          hintStyle: const TextStyle(
            color: AppColors.textSecondaryColor,
          ),

          prefixIcon: prefixIcon ??
              (icon != null
                  ? Icon(
                      icon,
                      color: AppColors.primary,
                    )
                  : null),

          suffixIcon: suffixIcon,

          filled: true,
          fillColor: AppColors.backgroundColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.red,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.danger,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.danger,
              width: 2,
            ),
          ),
        ),

        dropdownColor: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 6,

        items: [
          DropdownMenuItem(
            value: "",
            child: Text(
              "Any $label",
              style: const TextStyle(
                color: AppColors. textSecondaryColor,
              ),
            ),
          ),
          ...items.map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ),
        ],

        onChanged: (value) {
          if (value != null) {
            onChanged?.call(value);
          }
        },
      ),
    );
  }
}