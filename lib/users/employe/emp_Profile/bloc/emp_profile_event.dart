import 'dart:io';

abstract class EmpProfileEvent {
  const EmpProfileEvent();
}

class LoadEmpProfile extends EmpProfileEvent {
  const LoadEmpProfile({this.employeeId});

  final String? employeeId;
}

class RefreshEmpProfile extends EmpProfileEvent {
  const RefreshEmpProfile({this.employeeId});

  final String? employeeId;
}

class UpdateEmpProfileSection extends EmpProfileEvent {
  const UpdateEmpProfileSection({required this.section, required this.values});

  final String section;
  final Map<String, dynamic> values;
}

class UploadEmpProfileDocument extends EmpProfileEvent {
  const UploadEmpProfileDocument({
    required this.documentType,
    required this.file,
  });

  final String documentType;
  final File file;
}

