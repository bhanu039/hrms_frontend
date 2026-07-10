import '../data/notification_modal.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
 

  NotificationLoaded({
    required this.notifications,
  });
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}