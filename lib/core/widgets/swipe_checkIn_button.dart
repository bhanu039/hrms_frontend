import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class SwipeCheckInButton extends StatefulWidget {
  final bool isCheckedIn;
  final bool isCheckedOut;
  final Future<void> Function() onCheckIn;
  final Future<void> Function() onCheckOut;

  const SwipeCheckInButton({
    super.key,
    required this.isCheckedIn,
    required this.isCheckedOut,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  @override
  State<SwipeCheckInButton> createState() => _SwipeCheckInButtonState();
}

class _SwipeCheckInButtonState extends State<SwipeCheckInButton> {
  double dragPosition = 0;

  @override
  Widget build(BuildContext context) {
    final isIn = widget.isCheckedIn;
    final isOut = widget.isCheckedOut;

    final double maxWidth = MediaQuery.of(context).size.width - 32;
    const double knobSize = 56;
    final double maxDrag = maxWidth - knobSize - 8;

    // COMPLETED STATE
    if (isOut) {
      return Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.successColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: .08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.white, size: 26),
            SizedBox(width: 10),
            Text(
              "Shift Completed",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: .3,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isIn
              ? [AppColors.danger, AppColors.dangerDark]
              : [AppColors.successColor, AppColors.dangerDark ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isIn ? AppColors.danger : AppColors.successColor).withValues(
              alpha: .25,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // TEXT
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isIn ? "Swipe to Check Out" : "Swipe to Check In",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: .4,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),

          // SWIPE KNOB
          AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            left: dragPosition + 4,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  dragPosition += details.delta.dx;
                  dragPosition = dragPosition.clamp(0.0, maxDrag);
                });
              },
              onHorizontalDragEnd: (_) async {
                if (dragPosition >= maxDrag * .85) {
                  HapticFeedback.mediumImpact();

                  if (isIn) {
                    await widget.onCheckOut();
                  } else {
                    await widget.onCheckIn();
                  }
                }

                setState(() {
                  dragPosition = 0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.white, AppColors.warningColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: .18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isIn ? Icons.logout_rounded : Icons.login_rounded,
                  color: isIn ? AppColors.danger : AppColors.successColor,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
