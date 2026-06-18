import 'dart:io';

abstract class EmpFullRegEvent {}

class NextStep extends EmpFullRegEvent {
  
  
}

class PrevStep extends EmpFullRegEvent {}

class UpdateField extends EmpFullRegEvent {
  final String key;
  final dynamic value;

  UpdateField( this.key,  this.value);
}

class PickFile extends EmpFullRegEvent {
  final String type;
  final File file;

  PickFile(this.type, this.file);
}

class SubmitForm extends EmpFullRegEvent {}

class ToggleSwitch extends EmpFullRegEvent {
  final bool value;
  ToggleSwitch(this.value);
}
