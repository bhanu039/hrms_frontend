abstract class IndustryTypeEvent {}
class FetchIndustryTypesEvent extends IndustryTypeEvent {}

class CreateIndustryTypeEvent extends IndustryTypeEvent {
  final String name;
  CreateIndustryTypeEvent({required this.name,});
}

class UpdateIndustryTypeEvent extends IndustryTypeEvent {
  final String id;
  final String name;
  UpdateIndustryTypeEvent({required this.id, required this.name});
}

class DeleteIndustryTypeEvent extends IndustryTypeEvent {
  final String id;
  DeleteIndustryTypeEvent({required this.id});
}
