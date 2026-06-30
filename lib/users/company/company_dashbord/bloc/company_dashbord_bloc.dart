import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/company_dashbord_modal.dart';
import '../data/company_dashbord_repo.dart';
import 'company_dashbord_state.dart';
import 'company_dashbords_event.dart';

class CompanyDashboardBloc
    extends Bloc<CompanyDashboardEvent, CompanyDashboardState> {
  final CompanyDashboardRepository repository;

  CompanyDashboardBloc(this.repository) : super(CompanyDashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefresh);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<CompanyDashboardState> emit,
  ) async {
    emit(CompanyDashboardLoading());

    try {
      final result = await repository.getDashboard();
      print(result.data);

      final data = CompanyDashboardModel.fromJson(
        Map<String, dynamic>.from(result.data as Map),
      );

      emit(CompanyDashboardLoaded(data));
    }  on DioException  catch (e) {
       final message = e.response?.data?['message'] ?? e.message;
      emit(CompanyDashboardError(message));
    }
  }

  Future<void> _onRefresh(
    RefreshDashboard event,
    Emitter<CompanyDashboardState> emit,
  ) async {
    try {
      final result = await repository.getDashboard();
      print(result.data);

      final data = CompanyDashboardModel.fromJson(
        Map<String, dynamic>.from(result.data as Map),
      );

      emit(CompanyDashboardLoaded(data));
    }  on DioException  catch (e) {
       final message = e.response?.data?['message'] ?? e.message;
      emit(CompanyDashboardError(message));
    }
  }
}
