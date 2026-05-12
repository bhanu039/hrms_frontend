abstract class DeepLinkState {}

class DeepLinkInitial extends DeepLinkState {}

class NavigateToLogin extends DeepLinkState {}

class NavigateToReset extends DeepLinkState {
  final String token;

  NavigateToReset(this.token);
}