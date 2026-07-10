import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_bloc.dart';
import '../bloc/notification_state.dart';

class NotificationModal extends StatelessWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .75,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 15),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is NotificationError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is NotificationLoaded) {
                  if (state.notifications.isEmpty) {
                    return const Center(
                      child: Text("No notifications"),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final item = state.notifications[index];

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            item.sender.name[0],
                          ),
                        ),
                        title: Text(item.title),
                        subtitle: Text(item.message),
                        trailing: item.isRead
                            ? null
                            : const Icon(
                                Icons.circle,
                                color: Colors.red,
                                size: 10,
                              ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}



// IconButton(
//   icon: const Icon(Icons.notifications_outlined),
//   onPressed: () {
//     context.read<NotificationBloc>().add(GetNotifications());

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(24),
//         ),
//       ),
//       builder: (_) => BlocProvider.value(
//         value: context.read<NotificationBloc>(),
//         child: const NotificationModal(),
//       ),
//     );
//   },
// )