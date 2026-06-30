import 'package:flutter_bloc/flutter_bloc.dart';
import 'employee_model.dart';
import '../core/services/api_service.dart';


// ================= EVENTS =================
abstract class EmployeeListEvent {}

class FetchEmployeesEvent extends EmployeeListEvent {
  final String role;
  final String dataType;
  FetchEmployeesEvent({required this.role, required this.dataType});
}

class DeleteEmployeeEvent extends EmployeeListEvent {
  final String id;
  DeleteEmployeeEvent(this.id);
}

class ActivateEmployeeEvent extends EmployeeListEvent {
  final String id;
  ActivateEmployeeEvent(this.id);
}

// ================= STATES =================
enum EmployeeListStatus { initial, loading, success, failure }

class EmployeeListState {
  final EmployeeListStatus status;
  final List<EmployeeModel> employees;
  final bool isActionLoading;
  final String? alertMessage;
  final bool isActionSuccess;

  EmployeeListState({
    this.status = EmployeeListStatus.initial,
    this.employees = const [],
    this.isActionLoading = false,
    this.alertMessage,
    this.isActionSuccess = false,
  });

  EmployeeListState copyWith({
    EmployeeListStatus? status,
    List<EmployeeModel>? employees,
    bool? isActionLoading,
    String? alertMessage,
    bool? isActionSuccess,
  }) {
    return EmployeeListState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      alertMessage: alertMessage, // Don't preserve past dialogue values natively
      isActionSuccess: isActionSuccess ?? this.isActionSuccess,
    );
  }
}

// ================= BLOC LOGIC =================
class EmployeeListBloc extends Bloc<EmployeeListEvent, EmployeeListState> {
  final ApiService apiService = ApiService();
  String _cachedRole = '';
  String _cachedDataType = '';

  EmployeeListBloc() : super(EmployeeListState()) {
    on<FetchEmployeesEvent>(_onFetchEmployees);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
    on<ActivateEmployeeEvent>(_onActivateEmployee);
  }

  Future<void> _onFetchEmployees(FetchEmployeesEvent event, Emitter<EmployeeListState> emit) async {
    _cachedRole = event.role;
    _cachedDataType = event.dataType;
    emit(state.copyWith(status: EmployeeListStatus.loading));
    try {
      final data = await ApiService.getEmployees(event.role, event.dataType);
      emit(state.copyWith(status: EmployeeListStatus.success, employees: data));
    } catch (e) {
      emit(state.copyWith(status: EmployeeListStatus.failure));
    }
  }

  Future<void> _onDeleteEmployee(DeleteEmployeeEvent event, Emitter<EmployeeListState> emit) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      final bool success = await apiService.softDeleteEmp(event.id);
      if (success) {
        final data = await ApiService.getEmployees(_cachedRole, _cachedDataType);
        emit(state.copyWith(
          status: EmployeeListStatus.success, 
          employees: data, 
          isActionLoading: false, 
          isActionSuccess: true, 
          alertMessage: "Employee Deleted Success"
        ));
      } else {
        emit(state.copyWith(isActionLoading: false, isActionSuccess: false, alertMessage: "Deleted failed."));
      }
    } catch (_) {
      emit(state.copyWith(isActionLoading: false, isActionSuccess: false, alertMessage: "Deleted failed."));
    }
  }

  Future<void> _onActivateEmployee(ActivateEmployeeEvent event, Emitter<EmployeeListState> emit) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      final bool success = await apiService.activateEmp(event.id);
      if (success) {
        final data = await ApiService.getEmployees(_cachedRole, _cachedDataType);
        emit(state.copyWith(
          status: EmployeeListStatus.success, 
          employees: data, 
          isActionLoading: false, 
          isActionSuccess: true, 
          alertMessage: "Employee Activated Success"
        ));
      } else {
        emit(state.copyWith(isActionLoading: false, isActionSuccess: false, alertMessage: "Activation failed."));
      }
    } catch (_) {
      emit(state.copyWith(isActionLoading: false, isActionSuccess: false, alertMessage: "Activation failed."));
    }
  }
}
