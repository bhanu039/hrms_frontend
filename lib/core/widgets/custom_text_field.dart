import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;

  final TextInputType keyboardType;
  final bool isPassword;
  final bool readOnly;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final VoidCallback? onTap;
  final String? hintText;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.onTap,
    this.hintText,
    this.validator,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController? _internalController;
  bool _obscure = true;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? "",
      );
    } else {
      _internalController = null;
    }
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue) {
      _internalController?.text = widget.initialValue ?? "";
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: _controller,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        obscureText: widget.isPassword && _obscure,
        maxLines: widget.isPassword ? 1 : (widget.maxLines ?? 1),
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onTap: widget.onTap,

        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),

        cursorColor: AppColors.primary,

        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,

          labelStyle: const TextStyle(
            color: AppColors.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),

          hintStyle: const TextStyle(
            color: AppColors.textSecondaryColor,
            fontSize: 14,
          ),

          filled: true,
          fillColor: AppColors.backgroundColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          prefixIcon: widget.prefixIcon,

          suffixIcon: widget.isPassword
              ? IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.textSecondaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : widget.suffixIcon,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
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

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
            ),
          ),

          counterStyle: const TextStyle(
            color: AppColors.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}