import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/company/company_fullReg/bloc/full_Reg_event.dart';
import 'package:goexperts/company/company_fullReg/bloc/full_Reg_state.dart';

import '../data/modal/full_Reg_modal.dart';




class FullRegBloc extends Bloc<FullRegEvent, FullRegState> {
  FullRegBloc()
      : super(
          FullRegState(model: FullRegModel()),
        ) {
    on<UpdateField>(_onUpdate);
    on<NextStep>(_onNext);
    on<PrevStep>(_onPrev);
    on<SubmitForm>(_onSubmit);
  }

  void _onUpdate(UpdateField event, Emitter<FullRegState> emit) {
    final updated = state.model.copyWith(
      name: event.key == "name" ? event.value : state.model.name,
      legalName: event.key == "legalName" ? event.value : state.model.legalName,
      domain: event.key == "domain" ? event.value : state.model.domain,
      website: event.key == "website" ? event.value : state.model.website,
      phone: event.key == "phone" ? event.value : state.model.phone,
      companyLogo: event.key == "companyLogo" ? event.value : state.model.companyLogo,
      signature: event.key == "signature" ? event.value : state.model.signature,

      companySize: event.key == "companySize" ? event.value : state.model.companySize,
      foundedYear: event.key == "foundedYear" ? event.value : state.model.foundedYear,
      workModel: event.key == "workModel" ? event.value : state.model.workModel,
      shiftType: event.key == "shiftType" ? event.value : state.model.shiftType,

      currency: event.key == "currency" ? event.value : state.model.currency,
      salaryCycle: event.key == "salaryCycle" ? event.value : state.model.salaryCycle,
      pfPercentage: event.key == "pfPercentage" ? event.value : state.model.pfPercentage,
      pfEnabled: event.key == "pfEnabled" ? event.value : state.model.pfEnabled,

      timezone: event.key == "timezone" ? event.value : state.model.timezone,
      dateFormat: event.key == "dateFormat" ? event.value : state.model.dateFormat,
      language: event.key == "language" ? event.value : state.model.language,

      address1: event.key == "address1" ? event.value : state.model.address1,
      city: event.key == "city" ? event.value : state.model.city,
      state: event.key == "state" ? event.value : state.model.state,
      country: event.key == "country" ? event.value : state.model.country,
      pincode: event.key == "pincode" ? event.value : state.model.pincode,

      gstNumber: event.key == "gstNumber" ? event.value : state.model.gstNumber,
      panNumber: event.key == "panNumber" ? event.value : state.model.panNumber,
      tanNumber: event.key == "tanNumber" ? event.value : state.model.tanNumber,
      cinNumber: event.key == "cinNumber" ? event.value : state.model.cinNumber,


      declared:event.key=="declared"?event.value:state.model.declared,
    );

    emit(state.copyWith(model: updated));
  }

  void _onNext(NextStep event, Emitter<FullRegState> emit) {
    emit(state.copyWith(currentStep: state.currentStep + 1));
  }

  void _onPrev(PrevStep event, Emitter<FullRegState> emit) {
    emit(state.copyWith(currentStep: state.currentStep - 1));
  }

  void _onSubmit(SubmitForm event, Emitter<FullRegState> emit) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 2)); // API call

    emit(state.copyWith(isLoading: false));
  }
}