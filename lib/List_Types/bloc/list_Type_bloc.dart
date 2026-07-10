import 'package:flutter_bloc/flutter_bloc.dart';
import '../list_repo.dart';
import '../data/list_type_modal.dart';
import 'list_type_event.dart';
import 'list_Type_state.dart';

class ListTypeBloc extends Bloc<ListTypeEvent, ListTypeState> {
  final ListRepository repository;

  ListTypeBloc({required this.repository}) : super(ListTypeState.initial()) {
    on<FetchListTypesEvent>(_onFetchListTypes);
    on<CreateListTypeEvent>(_onCreateListType);
    on<UpdateListTypeEvent>(_onUpdateListType);
    on<DeleteListTypeEvent>(_onDeleteListType);
  }

  Future<void> _onFetchListTypes(
    FetchListTypesEvent event,
    Emitter<ListTypeState> emit,
  ) async {
    emit(state.copyWith(status: ListTypeStatus.loading));
    try {
      final refreshedList = await repository.getAllListTypes(
        event.listType,
        event.listTypeid,
      );
      print("Fetched list types: $refreshedList");

      final list = refreshedList["data"]
          .map<ListTypeModel>((item) => ListTypeModel.fromJson(item))
          .toList();

      emit(state.copyWith(status: ListTypeStatus.success, listTypes: list));
    } catch (e) {
      emit(
        state.copyWith(
          status: ListTypeStatus.failure,
          alertMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateListType(
    CreateListTypeEvent event,
    Emitter<ListTypeState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await repository.createListType(
        event.name,
        event.listType,
        event.listTypeid,
      );
      final refreshedList = await repository.getAllListTypes(
        event.listType,
        event.listTypeid,
      );
      final list = refreshedList["data"]
          .map<ListTypeModel>((item) => ListTypeModel.fromJson(item))
          .toList();

      emit(
        state.copyWith(
          isActionLoading: false,
          listTypes: list,
          isActionSuccess: true,
          alertMessage: "List type saved cleanly!",
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

  Future<void> _onUpdateListType(
    UpdateListTypeEvent event,
    Emitter<ListTypeState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await repository.updateListType(event.listType, event.id, event.name);
      final refreshedList = await repository.getAllListTypes(
        event.listType,
        event.listTypeid,
      );
      final list = refreshedList["data"]
          .map<ListTypeModel>((item) => ListTypeModel.fromJson(item))
          .toList();
      emit(
        state.copyWith(
          isActionLoading: false,
          listTypes: list,
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

  Future<void> _onDeleteListType(
    DeleteListTypeEvent event,
    Emitter<ListTypeState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      final response = await repository.deleteListType(
        event.id,
        event.listType,
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        final refreshedList = await repository.getAllListTypes(
          event.listType,
          event.listTypeid,
        );
         final list = refreshedList["data"]
          .map<ListTypeModel>((item) => ListTypeModel.fromJson(item))
          .toList();


        emit(
          state.copyWith(
            isActionLoading: false,
            listTypes: list,
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
