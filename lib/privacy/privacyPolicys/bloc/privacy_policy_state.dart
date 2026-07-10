

import '../data/privacy_policy_model.dart';

abstract class PrivacyPolicyState {}

class PrivacyPolicyInitial extends PrivacyPolicyState {}

class PrivacyPolicyLoading extends PrivacyPolicyState {}

class PrivacyPolicyLoaded extends PrivacyPolicyState {
  final PrivacyPolicyModel policy;

  PrivacyPolicyLoaded(this.policy);
}

class PrivacyPolicyError extends PrivacyPolicyState {
  final String message;

  PrivacyPolicyError(this.message);
}