import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;

  /// Preferred way (use in real apps / BLoC / edit forms)
  final TextEditingController? controller;

  /// Fallback if controller is not used
  final String? initialValue;

  final TextInputType keyboardType;
  final bool isPassword;
  final bool readOnly;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final VoidCallback? onTap;

  final String? Function(String?)? validator;
  final Function(String value)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;
  TextEditingController? _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null) {
      if (oldWidget.initialValue != widget.initialValue &&
          _internalController != null &&
          _internalController!.text != (widget.initialValue ?? '')) {
        _internalController!.text = widget.initialValue ?? '';
      }
    } else if (oldWidget.controller != widget.controller) {
      _internalController?.dispose();
      _internalController = null;
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
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: widget.controller ?? _internalController,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        onTap: widget.onTap,

        obscureText: widget.isPassword ? _obscure : false,

        onChanged: widget.onChanged,
        validator: widget.validator,

        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),

        decoration: InputDecoration(
          labelText: widget.label,

          labelStyle: TextStyle(color: Colors.grey.shade600),

          filled: true,
          fillColor: Colors.grey.shade50,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          prefixIcon: widget.prefixIcon,

          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : widget.suffixIcon,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
