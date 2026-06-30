
import 'dart:io';

abstract class FullRegEvent  {
  const FullRegEvent();

  @override
  List<Object?> get props => [];
}

/// Update any field dynamically
class UpdateField extends FullRegEvent {
  final String key;
  final dynamic value;

  const UpdateField(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}

/// Submit form
class SubmitCompanyRegistration extends FullRegEvent {}