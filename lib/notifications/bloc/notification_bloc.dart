import 'package:flutter_bloc/flutter_bloc.dart';

import '../notification_repo.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService repository;

  NotificationBloc(this.repository)
      : super(NotificationInitial()) {
    on<GetNotifications>(_getNotifications);
  }

 Future<void> _getNotifications(
  GetNotifications event,
  Emitter<NotificationState> emit,
) async {
  emit(NotificationLoading());

  try {
    final notifications = await repository.getNotifications(
      page: event.page,
      limit: event.limit,
      isRead: event.isRead,
    );

    emit(
      NotificationLoaded(
        notifications: notifications,
      ),
    );
  } catch (e) {
    emit(NotificationError(e.toString()));
  }
}
}