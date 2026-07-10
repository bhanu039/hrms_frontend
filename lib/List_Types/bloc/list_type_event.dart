abstract class ListTypeEvent {}
class FetchListTypesEvent extends ListTypeEvent {
  final String listType;
  final String? listTypeid;
  FetchListTypesEvent({required this.listType, this.listTypeid});
}

class CreateListTypeEvent extends ListTypeEvent {
  final String listType;
  final String? listTypeid;
  final String name;
  CreateListTypeEvent({required this.listType, this.listTypeid, required this.name});
}

class UpdateListTypeEvent extends ListTypeEvent {
  final String id;
  final String name;
  final String listType;
  final String? listTypeid;
  UpdateListTypeEvent({required this.id, required this.name, required this.listType, this.listTypeid});
}

class DeleteListTypeEvent extends ListTypeEvent {
  final String listType;
  final String? listTypeid;
  final String id;
  DeleteListTypeEvent({required this.listType, this.listTypeid, required this.id});
}
