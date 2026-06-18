abstract class AddCompanyEvent {}

class LoadIndustries extends AddCompanyEvent {}

class NameChanged extends AddCompanyEvent {
  final String value;
  NameChanged(this.value);
}

class EmailChanged extends AddCompanyEvent {
  final String value;
  EmailChanged(this.value);
}

class OwnerNameChanged extends AddCompanyEvent {
  final String value;
  OwnerNameChanged(this.value);
}

class OwnerEmailChanged extends AddCompanyEvent {
  final String value;
  OwnerEmailChanged(this.value);
}

class LocationChanged extends AddCompanyEvent {
  final String value;
  LocationChanged(this.value);
}

class IndustryChanged extends AddCompanyEvent {
  final String value;
  IndustryChanged(this.value);
}

class SubmitCompany extends AddCompanyEvent {}

class ResetCompanyForm extends AddCompanyEvent {}
