import 'dart:io';

abstract class FullRegEvent {}

class NextStep extends FullRegEvent {
 
}

class PrevStep extends FullRegEvent {
  
}

class UpdateField extends FullRegEvent {
  final String key;
  final dynamic value;

  UpdateField(this.key, this.value);
}

class PickFile extends FullRegEvent {
  final String type;
  final File file;

  PickFile(this.type, this.file);
}

class SubmitForm extends FullRegEvent {}
