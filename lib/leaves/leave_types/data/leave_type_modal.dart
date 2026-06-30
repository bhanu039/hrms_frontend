class LeaveTypeModel {
  final String id;
  final String name;
  final int maxDays;
  final String? companyId;
  final DateTime? createdAt;

  LeaveTypeModel({
    required this.id,
    required this.name,
    required this.maxDays,
    this.companyId,
    this.createdAt,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unnamed Leave',
      maxDays: int.tryParse(json['maxDays']?.toString() ?? '0') ?? 0,
      companyId: json['companyId'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "maxDays": maxDays,
    };
  }
}
