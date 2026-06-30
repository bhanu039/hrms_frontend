import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class AppSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const AppSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onChanged(!value), // 🔥 tap anywhere toggle
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: value ? AppColors.green.shade200 : AppColors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // 🔵 TEXT SECTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: value
                          ? AppColors.green.shade700
                          : AppColors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 10),

            // 🔘 SWITCH
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.white,
              activeTrackColor: AppColors.green,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

//use like this 

/////AppSwitchTile(
//   title: "Declaration Status",
//   subtitle: "Enable if company declaration is completed",
//   value: state.model.declared,
//   onChanged: (val) {
//     context.read<FullRegBloc>().add(
//       UpdateField("declared", val),
//     );
//   },
// ),