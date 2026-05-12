enum ProfileStatus { initial, loading, success, failure }

class ProfileState {
  final ProfileStatus status;
  final String? message;

  const ProfileState({this.status = ProfileStatus.initial, this.message});

  ProfileState copyWith({ProfileStatus? status, String? message}) {
    return ProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
