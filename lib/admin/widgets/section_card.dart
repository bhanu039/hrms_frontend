import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;

  const SectionCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(onPressed: () {}, child: const Text("View All"))
            ],
          ),
          const Divider(),
          const Text("Data will come from API here...")
        ],
      ),
    );
  }
}