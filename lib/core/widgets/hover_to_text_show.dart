import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class HoverStatus extends StatefulWidget {
  final String status;
  final IconData icon;
  final Color color;
  const HoverStatus({
    super.key,
    required this.status,
    required this.icon,
    required this.color,
  });
  @override
  State<HoverStatus> createState() => _HoverStatusState();
}

class _HoverStatusState extends State<HoverStatus> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isHover
              ? widget.color.withValues(alpha: 0.10)
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isHover
                ? widget.color.withValues(alpha: 0.4)
                : AppColors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: widget.color, size: 20),
            const SizedBox(width: 6),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: isHover
                  ? Text(
                      widget.status,
                      style: TextStyle(
                        color: widget.color,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}  // it is the corser //call liske this    // HoverStatus( //   status: "Active", //   icon: Icons.check_circle, //   color: AppColors.green, // ) 
