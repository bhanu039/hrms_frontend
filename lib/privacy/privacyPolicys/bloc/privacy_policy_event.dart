abstract class PrivacyPolicyEvent {}

class FetchPrivacyPolicy extends PrivacyPolicyEvent {
  final String? data;

  FetchPrivacyPolicy({this.data});
}
