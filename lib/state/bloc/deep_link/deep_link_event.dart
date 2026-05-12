abstract class DeepLinkEvent {}

class CheckDeepLink extends DeepLinkEvent {}
class HandleDeepLink extends DeepLinkEvent {
  final Uri uri;

  HandleDeepLink(this.uri);
}