import 'package:flutter_bloc/flutter_bloc.dart';

import '../privacy_policy_repository.dart';
import 'privacy_policy_event.dart';
import 'privacy_policy_state.dart';

class PrivacyPolicyBloc
    extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final PrivacyPolicyRepository repository;

  PrivacyPolicyBloc(this.repository)
      : super(PrivacyPolicyInitial()) {
    on<FetchPrivacyPolicy>(_fetchPolicy);
  }

  Future<void> _fetchPolicy(
    FetchPrivacyPolicy event,
    Emitter<PrivacyPolicyState> emit,
  ) async {
    emit(PrivacyPolicyLoading());

    try {
      final policy = await repository.getPrivacyPolicy(event.data);

      emit(PrivacyPolicyLoaded(policy));
    } catch (e) {
      emit(
        PrivacyPolicyError(e.toString()),
      );
    }
  }
}