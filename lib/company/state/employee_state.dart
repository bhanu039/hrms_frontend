

import '../models/employee_model.dart';

abstract class EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;

  EmployeeLoaded(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;

  EmployeeError(this.message);
}
abstract class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}
class EmployeeCreating extends EmployeeState {}

class CreateEmployee extends EmployeeEvent {
  final Map<String, dynamic> data;

  CreateEmployee(this.data);
}