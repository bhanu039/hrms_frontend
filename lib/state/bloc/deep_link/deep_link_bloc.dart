import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'deep_link_event.dart';
import 'deep_link_state.dart';

class DeepLinkBloc extends Bloc<DeepLinkEvent, DeepLinkState> {
  final AppLinks appLinks;

  DeepLinkBloc(this.appLinks) : super(DeepLinkInitial()) {
    on<CheckDeepLink>(_onCheckDeepLink);
  }

  Future<void> _onCheckDeepLink(
      CheckDeepLink event,
      Emitter<DeepLinkState> emit) async {

    final Uri? uri = await appLinks.getInitialLink();

    print("Deep Link: $uri");

    if (uri != null && uri.path == '/reset') {
      final token = uri.queryParameters['token'];

      if (token != null) {
        emit(NavigateToReset(token));
        return;
      }
    }

    emit(NavigateToLogin());
  }
}