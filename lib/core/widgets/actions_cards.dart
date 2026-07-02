import 'package:flutter/material.dart';

import '../app_constants/app_color.dart';

class CardDetail {
  final IconData icon;
  final String label;

  const CardDetail({required this.icon, required this.label});
}

class CardAction {
  final IconData icon;
  final String tooltip;
  final Color? color;
  final VoidCallback onPressed;

  const CardAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });
}

class UniversalActionCard extends StatelessWidget {
  final String? datatype;
  final String? imageUrl;
  final String? employeeName;
  final String? designation;

  final String title;
  final String description;

  final String status;
  final Color statusColor;

  final List<CardDetail> details;
  final List<CardAction>? actions;

  const UniversalActionCard({
    this.datatype,
    super.key,
    this.imageUrl,
    this.employeeName,
    this.designation,
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.details,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("Employee Name: $employeeName");

    return Card(

      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          // Header
          if (datatype != null && datatype != "me")Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.backgroundColor,
                    backgroundImage:
                        (imageUrl != null &&
                            imageUrl!.isNotEmpty &&
                            imageUrl!.startsWith('http'))
                        ? NetworkImage(imageUrl!)
                        : null,
                    child:
                        (imageUrl == null ||
                            imageUrl!.isEmpty ||
                            !imageUrl!.startsWith('http'))
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employeeName!,
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        if (designation != null)
                          Text(
                            designation!,
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: AppColors.textColor.withOpacity(.7),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Chip(
                    backgroundColor: statusColor.withOpacity(.15),
                    side: BorderSide.none,
                    label: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const Divider(height: 1),

          // Title
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Spacer(),
              if ( datatype == "me")
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Chip(
                    backgroundColor: statusColor.withOpacity(.15),
                    side: BorderSide.none,
                    label: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(description, style: theme.textTheme.bodyMedium),
            ),
          ),

          // Details
          
         Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 18,
              runSpacing: 12,
              children: details
                  .map(
                    (e) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(e.icon, size: 18, color: AppColors.iconPrimary),

                        const SizedBox(width: 6),

                        Expanded(child: Text(e.label)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 16),

          const Divider(height: 1),

          // Actions
          if(datatype != "me") Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!
                  .map(
                    (action) => IconButton(
                      tooltip: action.tooltip,
                      onPressed: action.onPressed,
                      icon: Icon(action.icon, color: action.color),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
} 

// UniversalActionCard(
//   employeeName: "Bhanu Prakash",
//   designation: "Flutter Developer",

//   title: "Permission Request",

//   description:
//       "Need permission to visit the bank for document verification.",

//   status: "Approved",

//   statusColor: Colors.green,

//   details: const [

//     CardDetail(
//       icon: Icons.calendar_today,
//       label: "01 Jul 2026",
//     ),

//     CardDetail(
//       icon: Icons.access_time,
//       label: "10:00 AM - 12:00 PM",
//     ),

//     CardDetail(
//       icon: Icons.location_on,
//       label: "Hyderabad",
//     ),

//     CardDetail(
//       icon: Icons.business,
//       label: "Development",
//     ),
//   ],

//   actions: [

//     CardAction(
//       icon: Icons.visibility_outlined,
//       tooltip: "View",
//       onPressed: () {},
//     ),

//     CardAction(
//       icon: Icons.edit_outlined,
//       tooltip: "Edit",
//       onPressed: () {},
//     ),

//     CardAction(
//       icon: Icons.check_circle_outline,
//       tooltip: "Approve",
//       color: Colors.green,
//       onPressed: () {},
//     ),

//     CardAction(
//       icon: Icons.cancel_outlined,
//       tooltip: "Reject",
//       color: Colors.red,
//       onPressed: () {},
//     ),

//     CardAction(
//       icon: Icons.more_vert,
//       tooltip: "More",
//       onPressed: () {},
//     ),
//   ],
// )