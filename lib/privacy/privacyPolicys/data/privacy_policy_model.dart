class PrivacyPolicyModel {
  final String title;
  final String content;

  PrivacyPolicyModel({
    required this.title,
    required this.content,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      title: json["type"] ?? "",
      content: json["content"] ?? "",
    );
  }
}