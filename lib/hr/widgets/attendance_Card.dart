import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/hover_to_text_show.dart';

Widget attendanceCard({
  required String name,
  required String department,
  required String status,
  String? checkIn,
  String? checkout,
  String? pic,
  required VoidCallback onTap,
}) {
  String intime = checkIn != null
      ? DateFormat('HH:mm').format(DateTime.parse(checkIn).toLocal())
      : "--";

  String outtime = checkout != null
      ? DateFormat('HH:mm').format(DateTime.parse(checkout!).toLocal())
      : "--";

  return InkWell(
    onTap: onTap,
    child: Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // ⭐ IMPORTANT
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 👤 IMAGE
              CircleAvatar(
                radius: 22,
                backgroundImage: (pic?.isNotEmpty ?? false)
                    ? NetworkImage(pic!)
                    : null,
                child: (pic?.isNotEmpty ?? false)
                    ? null
                    : const Icon(Icons.person),
              ),

              const SizedBox(width: 15),

              // NAME
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              status == "PRESENT"
                    ? HoverStatus(
                        status: status,
                        icon: Icons.how_to_reg,
                        color: Colors.green,
                      )
                    : status.contains("EARLY_EXIT")
                    ? HoverStatus(
                        status: status,
                        icon: Icons.exit_to_app,
                        color: const Color.fromARGB(255, 233, 190, 1),
                      )
                    : HoverStatus(
                        status: status,
                        icon: Icons.person_off_outlined,
                        color: Colors.red,
                      ),

              const SizedBox(width: 25),

              // DEPARTMENT
              Text(department),

              const SizedBox(width: 25),

              // STATUS
               

              const SizedBox(width: 25),

              // CHECK IN
              Text("IN: $intime"),

              const SizedBox(width: 25),

              // CHECK OUT
              Text("OUT: $outtime"),
            ],
          ),
        ),
      ),
    ),
  );
}
