import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/employe/emp_dashbord/data/repository_emp_dashboard.dart';

import '../data/emp_dashborad_modal.dart';
import 'emp_dashboard_event.dart';
import 'emp_dashboard_state.dart';

class EmpDashboardBloc extends Bloc<EmpDashboardEvent, EmpDashboardState> {
  final RepositoryEmpDashboard repositoryEmp;

  EmpDashboardBloc(this.repositoryEmp) : super(EmpDashboardInitial()) {
    on<EmpLoadDashboard>(_loadDashboard);
    on<CheckInEvent>(_checkIn);
    on<CheckOutEvent>(_checkOut);
  }

  Future<void> _loadDashboard(
    EmpLoadDashboard event,
    Emitter<EmpDashboardState> emit,
  ) async {
    try {
      emit(EmpDashboardLoading());

      final res = await repositoryEmp.getDashboard();

      final data = EmpDashboardModel.fromJson(res);

      emit(EmpDashboardLoaded(data));
    } on DioException catch (e) {
      final message = e.response?.data?['message']??e.message;
      emit(EmpDashboardError(message));
    }
  }

  Future<void> _checkIn(
    CheckInEvent event,
    Emitter<EmpDashboardState> emit,
  ) async {
    try {
      final current = state;

      if (current is EmpDashboardLoaded) {
        final res = await repositoryEmp.checkIn();

        final updated = EmpDashboardModel.fromJson(res);

        emit(EmpDashboardLoaded(updated));
      }
    } catch (e) {
      emit(EmpDashboardError(e.toString()));
    }
  }

  Future<void> _checkOut(
    CheckOutEvent event,
    Emitter<EmpDashboardState> emit,
  ) async {
    try {
      final current = state;

      if (current is EmpDashboardLoaded) {
        final res = await repositoryEmp.checkOut();

        final updated = EmpDashboardModel.fromJson(res);

        emit(EmpDashboardLoaded(updated));
      }
    } catch (e) {
      emit(EmpDashboardError(e.toString()));
    }
  }
}
