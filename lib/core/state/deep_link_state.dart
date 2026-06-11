abstract class DeepLinkState {}

class DeepLinkInitial extends DeepLinkState {}

class NavigateToSetPassword extends DeepLinkState {
  final String token;

  NavigateToSetPassword(this.token);
}

class DeepLinkError extends DeepLinkState {
  final String message;

  DeepLinkError(this.message);
}