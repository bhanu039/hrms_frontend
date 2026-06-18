import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/company_reg_repository.dart';
import 'company_reg_event.dart';
import 'company_reg_state.dart';

class AddCompanyBloc extends Bloc<AddCompanyEvent, AddCompanyState> {
  final AddCompanyRepository repository;

  AddCompanyBloc(this.repository) : super(AddCompanyState(industries: [])) {
    // ================= FIELD EVENTS =================
    on<NameChanged>((e, emit) => emit(state.copyWith(name: e.value)));
    on<EmailChanged>((e, emit) => emit(state.copyWith(email: e.value)));
    on<OwnerNameChanged>((e, emit) => emit(state.copyWith(ownerName: e.value)));
    on<OwnerEmailChanged>(
      (e, emit) => emit(state.copyWith(ownerEmail: e.value)),
    );
    on<LocationChanged>((e, emit) => emit(state.copyWith(location: e.value)));
    on<IndustryChanged>((e, emit) => emit(state.copyWith(industryId: e.value)));

    // ================= API EVENTS =================
    on<LoadIndustries>(_loadIndustries);
    on<SubmitCompany>(_submit);
    on<ResetCompanyForm>((event, emit) {
      emit(
        state.copyWith(
          name: "",
          email: "",
          ownerName: "",
          ownerEmail: "",
          location: "",
          industryId: null,
          success: false,
          error: null,
        ),
      );
    });
  }

  // ================= LOAD INDUSTRIES =================
  Future<void> _loadIndustries(
    LoadIndustries event,
    Emitter<AddCompanyState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      final industries = await repository.getIndustries();

      emit(state.copyWith(loading: false, industries: industries));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // ================= SUBMIT COMPANY =================
  Future<void> _submit(
    SubmitCompany event,
    Emitter<AddCompanyState> emit,
  ) async {
    emit(state.copyWith(submitting: true, error: null));

    
      final success = await repository.createCompany(
        name: state.name,
        email: state.email,
        location: state.location,
        ownerName: state.ownerName,
        ownerEmail: state.ownerEmail,
        industryId: state.industryId ?? "",
      );
      

      emit(
        state.copyWith(
          submitting: false,
          industryId: null,
          success: success["success"] ?? false,
          error: success["message"] ?? "Failed to create company",
        ),
      );
    
  }
}
