import 'package:flutter_bloc/flutter_bloc.dart';
import '../Industry_repo.dart';
import '../data/industry_type_modal.dart';
import 'industry_type_event.dart';
import 'industry_Type_state.dart';

class IndustryTypeBloc extends Bloc<IndustryTypeEvent, IndustryTypeState> {
  final IndustryRepository repository;

  IndustryTypeBloc({required this.repository})
    : super(IndustryTypeState.initial()) {
    on<FetchIndustryTypesEvent>(_onFetchIndustryTypes);
    on<CreateIndustryTypeEvent>(_onCreateIndustryType);
    on<UpdateIndustryTypeEvent>(_onUpdateIndustryType);
    on<DeleteIndustryTypeEvent>(_onDeleteIndustryType);
  }

  Future<void> _onFetchIndustryTypes(
    FetchIndustryTypesEvent event,
    Emitter<IndustryTypeState> emit,
  ) async {
    emit(state.copyWith(status: IndustryTypeStatus.loading));
    try {
      final refreshedList = await repository.getAllIndustryTypes();
      print("Fetched industry types: $refreshedList");

       final list = refreshedList["data"].map<IndustryTypeModel>((item) => IndustryTypeModel.fromJson(item)).toList();

      emit(
        state.copyWith(status: IndustryTypeStatus.success, industryTypes: list),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: IndustryTypeStatus.failure,
          alertMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateIndustryType(
    CreateIndustryTypeEvent event,
    Emitter<IndustryTypeState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await repository.createIndustryType(event.name);
      final refreshedList = await repository.getAllIndustryTypes();
             final list = refreshedList["data"].map<IndustryTypeModel>((item) => IndustryTypeModel.fromJson(item)).toList();

      emit(
        state.copyWith(
          isActionLoading: false,
          industryTypes: list,
          isActionSuccess: true,
          alertMessage: "Industry type saved cleanly!",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isActionLoading: false,
          isActionSuccess: false,
          alertMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateIndustryType(
    UpdateIndustryTypeEvent event,
    Emitter<IndustryTypeState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await repository.updateIndustryType(event.id, event.name);
      final  refreshedList = await repository
          .getAllIndustryTypes();
      final list = refreshedList["data"].map<IndustryTypeModel>((item) => IndustryTypeModel.fromJson(item)).toList();
      emit(
        state.copyWith(
          isActionLoading: false,
          industryTypes: list,
          isActionSuccess: true,
          alertMessage: "Configuration updated successfully!",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isActionLoading: false,
          isActionSuccess: false,
          alertMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteIndustryType(
    DeleteIndustryTypeEvent event,
    Emitter<IndustryTypeState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      final response = await repository.deleteIndustryType(event.id);
      if (response.statusCode == 200 || response.statusCode == 204) {

        final refreshedList = await repository.getAllIndustryTypes();
        final list = refreshedList
      .where((industryType) => industryType.id != event.id)
      .toList();

        emit(
          state.copyWith(
            isActionLoading: false,
            industryTypes: list,
            isActionSuccess: true,
            alertMessage: "Record dropped from server registry.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isActionLoading: false,
          isActionSuccess: false,
          alertMessage: e.toString(),
        ),
      );
    }
  }
}
