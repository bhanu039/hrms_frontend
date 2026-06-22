import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/sessionservice.dart';
import '../data/modal/full_Reg_modal.dart';
import '../data/repository/repository_empFullreg.dart';
import 'full_Reg_event.dart';
import 'full_Reg_state.dart';

class FullRegBloc extends Bloc<FullRegEvent, FullRegState> {
  final FullRegRepository repository;

  FullRegBloc(this.repository)
    : super(FullRegState(model: const FullRegModel())) {
    on<UpdateField>(_onUpdateField);
    on<SubmitCompanyRegistration>(_onSubmit);
  }

  void _onUpdateField(UpdateField event, Emitter<FullRegState> emit) {
  final m = state.model;

  FullRegModel updated = m;

  switch (event.key) {
    // BASIC
    case "legalName":
      updated = m.copyWith(legalName: event.value);
      break;

    case "phone":
      updated = m.copyWith(phone: event.value);
      break;

    case "website":
      updated = m.copyWith(website: event.value);
      break;

    case "linkedinUrl":
      updated = m.copyWith(linkedinUrl: event.value);
      break;

    case "companySize":
      updated = m.copyWith(companySize: event.value);
      break;

    case "foundedYear":
      updated = m.copyWith(foundedYear: event.value);
      break;

    case "cinNumber":
      updated = m.copyWith(cinNumber: event.value);
      break;


    // ADDRESS
    case "address1":
      updated = m.copyWith(address1: event.value);
      break;

    case "city":
      updated = m.copyWith(city: event.value);
      break;

    case "state":
      updated = m.copyWith(state: event.value);
      break;

    case "country":
      updated = m.copyWith(country: event.value);
      break;

    case "pincode":
      updated = m.copyWith(pincode: event.value);
      break;

    case "landmark":
      updated = m.copyWith(landmark: event.value);
      break;

    case "latitude":
      updated = m.copyWith(latitude: event.value);
      break;

    case "longitude":
      updated = m.copyWith(longitude: event.value);
      break;
      case "geofenceRadius":
      updated = m.copyWith(longitude: event.value);
      break;


    // HR
    case "companyPolicy":
      updated = m.copyWith(companyPolicy: event.value);
      break;

    case "employeeTerms":
      updated = m.copyWith(employeeTerms: event.value);
      break;

    case "workingHours":
      updated = m.copyWith(workingHours: event.value);
      break;

    case "workingDays":
      updated = m.copyWith(workingDays: event.value);
      break;

    case "workModel":
      updated = m.copyWith(workModel: event.value);
      break;

    case "shiftType":
      updated = m.copyWith(shiftType: event.value);
      break;


    // TAX
    case "gstNumber":
      updated = m.copyWith(gstNumber: event.value);
      break;

    case "panNumber":
      updated = m.copyWith(panNumber: event.value);
      break;

    case "tanNumber":
      updated = m.copyWith(tanNumber: event.value);
      break;

    case "pfEnabled":
      updated = m.copyWith(pfEnabled: event.value);
      break;

    case "pfPercentage":
      updated = m.copyWith(pfPercentage: event.value);
      break;

    case "pfRegistrationNumber":
      updated = m.copyWith(
        pfRegistrationNumber: event.value,
      );
      break;

    case "esiEnabled":
      updated = m.copyWith(esiEnabled: event.value);
      break;

    case "esiRegistrationNumber":
      updated = m.copyWith(
        esiRegistrationNumber: event.value,
      );
      break;

    case "ptRegistrationNumber":
      updated = m.copyWith(
        ptRegistrationNumber: event.value,
      );
      break;


    // PAYROLL
    case "currency":
      updated = m.copyWith(currency: event.value);
      break;

    case "salaryCycle":
      updated = m.copyWith(salaryCycle: event.value);
      break;

    case "payrollStartDay":
      updated = m.copyWith(
        payrollStartDay: event.value,
      );
      break;

    case "payrollEndDay":
      updated = m.copyWith(
        payrollEndDay: event.value,
      );
      break;

    case "termsAndConditions":
      updated = m.copyWith(
        termsAndConditions: event.value,
      );
      break;


    // FILES
    case "companyLogo":
      updated = m.copyWith(companyLogo: event.value);
      break;

    case "signature":
      updated = m.copyWith(signature: event.value);
      break;

    case "regCertificate":
      updated = m.copyWith(
        regCertificate: event.value,
      );
      break;

    case "gstProof":
      updated = m.copyWith(gstProof: event.value);
      break;

    case "panProof":
      updated = m.copyWith(panProof: event.value);
      break;

    case "tanProof":
      updated = m.copyWith(tanProof: event.value);
      break;


    // EXTRA
    case "declared":
      updated = m.copyWith(declared: event.value);
      break;
  }

  emit(
    state.copyWith(model: updated),
  );
}

  Future<void> _onSubmit(
    SubmitCompanyRegistration event,
    Emitter<FullRegState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null, success: false));

      final result = await repository.submit(state.model);
        
         await SessionService.isFullRegisteredupdate(true);

      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      print(e);
      emit(state.copyWith(loading: false, success: false, error: e.toString()));
    }
  }
}
