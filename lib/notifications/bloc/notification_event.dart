abstract class NotificationEvent {}

class GetNotifications extends NotificationEvent {
  final int page;
  final int limit;
  final bool? isRead;

  GetNotifications({
    this.page = 1,
    this.limit = 20,
    this.isRead,
  });
}