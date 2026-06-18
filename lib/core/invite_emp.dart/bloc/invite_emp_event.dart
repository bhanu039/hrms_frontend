abstract class InviteEmpEvent {}

class LoadEmployeeInitialData extends  InviteEmpEvent{
  final String companyId;
  LoadEmployeeInitialData(this.companyId);
}

class SelectDepartment extends InviteEmpEvent {
  final String departmentId;
  SelectDepartment(this.departmentId);
}

class SelectDesignation extends InviteEmpEvent {
  final String designationId;
  SelectDesignation(this.designationId);
}

class ToggleNewHire extends InviteEmpEvent {
  final bool isNewHire;
  ToggleNewHire(this.isNewHire);
}

class SubmitEmployee extends InviteEmpEvent {
  final Map<String, dynamic> body;
  SubmitEmployee(this.body);
}