import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/company/state/employee_state.dart';


import '../../services/api_service.dart';


class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final ApiService apiService;

  EmployeeBloc(this.apiService) : super(EmployeeLoading()) {
    on<LoadEmployees>((event, emit) async {
      try {
        emit(EmployeeLoading());

        final employees = await apiService.getEmployees();

        emit(EmployeeLoaded(employees));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });
  on<CreateEmployee>((event, emit) async {
  try {
    emit(EmployeeCreating()); // ✅ correct

    await apiService.createEmployee(event.data);

    final employees = await apiService.getEmployees();

    emit(EmployeeLoaded(employees));

  } catch (e) {
    emit(EmployeeError("Failed to create employee"));
  }


});
  }
}
