import 'package:flutter_bloc/flutter_bloc.dart';

import '../../leave_repo.dart';
import 'leave_request_event.dart';
import 'leave_request_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
   final LeaveRepository repository;
  // Pass your existing network repository here if needed
  LeaveBloc(this.repository) : super(LeaveInitialState()) {
    on<SubmitLeaveRequestEvent>(_onSubmitLeaveRequest);
    on<FetchLeaveTypesEvent>(_onFetchLeaveTypes);
  }

  Future<void> _onFetchLeaveTypes(
    FetchLeaveTypesEvent event,
    Emitter<LeaveState> emit,
  ) async {
    emit(LeaveTypesLoadingState());

    try {
      final leaveTypes = await repository.getAllLeaveTypes();
      emit(LeaveTypesLoadedState(leaveTypes));
    } catch (e) {
      emit(LeaveTypesErrorState(e.toString()));
    }
  }

  Future<void> _onSubmitLeaveRequest(
    SubmitLeaveRequestEvent event,
    Emitter<LeaveState> emit,
  ) async {
    emit(LeaveSubmittingState());

    try {
      final response = await repository.requestLeave(
        event.request.leaveTypeId,
        DateTime.parse(event.request.fromDate),
        DateTime.parse(event.request.toDate),
        event.request.reason
      );
      print("Leave request response: $response");
      
      // Simulating network call latency
      await Future.delayed(const Duration(seconds: 2));
      if (response['success'] != true) {
        throw Exception(response['message'] ?? "Failed to submit leave request.");
      }else {
        emit(LeaveSuccessState("Leave request submitted successfully!"));
      }
     
    } catch (e) {
      emit(LeaveFailureState(e.toString()));
    }
  }
}
