import 'package:flutter/material.dart';

class SwipeCheckInButton extends StatefulWidget {
  final bool isCheckedIn;
  final Future<void> Function() onCheckIn;
  final Future<void> Function() onCheckOut;

  const SwipeCheckInButton({
    super.key,
    required this.isCheckedIn,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  @override
  State<SwipeCheckInButton> createState() => _SwipeCheckInButtonState();
}

class _SwipeCheckInButtonState extends State<SwipeCheckInButton>
    with SingleTickerProviderStateMixin {
  double dragPosition = 0;

  @override
  Widget build(BuildContext context) {
    final isIn = widget.isCheckedIn;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: LinearGradient(
          colors: isIn
              ? [Colors.red.shade400, Colors.red.shade700]
              : [Colors.green.shade400, Colors.green.shade700],
        ),
      ),
      child: Stack(
        children: [
          // CENTER TEXT
          Center(
            child: Text(
              isIn ? "Swipe to Check Out →" : "Swipe to Check In →",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),

          // DRAG BUTTON
          AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            left: dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  dragPosition += details.delta.dx;
                  dragPosition = dragPosition.clamp(
                    0,
                    MediaQuery.of(context).size.width - 120,
                  );
                });
              },
              onHorizontalDragEnd: (_) async {
                final maxDrag =
                    MediaQuery.of(context).size.width * 0.6;

                if (dragPosition > maxDrag) {
                  // TRIGGER ACTION
                  if (widget.isCheckedIn) {
                    await widget.onCheckOut();
                  } else {
                    await widget.onCheckIn();
                  }
                }

                setState(() {
                  dragPosition = 0;
                });
              },
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Icon(
                  isIn ? Icons.logout : Icons.login,
                  color: isIn ? Colors.red : Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}