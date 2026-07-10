




import '../data/list_type_modal.dart';

enum ListTypeStatus { initial, loading, success, failure }

class ListTypeState {
  final ListTypeStatus status;
  final List<ListTypeModel>? listTypes;
  final bool isActionLoading;
  final String? alertMessage;
  final bool isActionSuccess;

  ListTypeState({
    required this.status, 
    required this.listTypes, 
    required this.isActionLoading, 
    this.alertMessage, 
    required this.isActionSuccess
  });

  factory ListTypeState.initial() => ListTypeState(
        status: ListTypeStatus.initial, 
        listTypes: [], 
        isActionLoading: false, 
        alertMessage: null, 
        isActionSuccess: false
      );

  ListTypeState copyWith({
    ListTypeStatus? status, 
    List<ListTypeModel>? listTypes, 
    bool? isActionLoading, 
    String? alertMessage, 
    bool? isActionSuccess
  }) {
    return ListTypeState(
      status: status ?? this.status,
      listTypes: listTypes ?? this.listTypes,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      alertMessage: alertMessage,
      isActionSuccess: isActionSuccess ?? this.isActionSuccess,
    );
  }
}