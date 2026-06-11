import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String? title;
  final String? count;
  final IconData? icon;
  final Color? color;

  const StatCard({
    super.key,
     this.title,
     this.count,
     this.icon, 
     this.color,
    // this.color = Colors.blue,
      onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.indigo, size: 30),
          const SizedBox(height: 10),
          Text(
            count??"",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(title!, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}