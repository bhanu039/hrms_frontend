import 'package:flutter/material.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String value)? onChanged;
   final Widget? prefixIcon;
  final Widget? suffixIcon;
    final String? Function(String?)? validator;

  final IconData? icon;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: (value != null && value!.isNotEmpty) ? value : null,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        validator: validator,

        decoration: InputDecoration(
          
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          filled: true,
          fillColor: Colors.grey.shade50,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 1.5,
            ),
          ),
        ),

        dropdownColor: Colors.white,
        elevation: 3,

        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            )
            .toList(),

        onChanged: (newValue) {
          if (newValue != null) {
            onChanged?.call(newValue);
          }
        },
      ),
    );
  }
}


//call ike this 

  // AppDropdown(
  //       label: "Country",
  //       value: state.model.country,
  //       items: const ["India", "USA", "UK"],
  //       onChanged: (val) {
  //         context.read<FullRegBloc>().add(UpdateField("Country", val));
  //       },
  //     ),