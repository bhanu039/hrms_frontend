class IndustryTypeModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final IndustryCount count;

  IndustryTypeModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.count,
  });

  factory IndustryTypeModel.fromJson(Map<String, dynamic> json) {
    return IndustryTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      count: IndustryCount.fromJson(json['_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '_count': count.toJson(),
    };
  }
}

class IndustryCount {
  final int departments;
  final int designations;

  IndustryCount({
    required this.departments,
    required this.designations,
  });

  factory IndustryCount.fromJson(Map<String, dynamic> json) {
    return IndustryCount(
      departments: json['departments'] ?? 0,
      designations: json['designations'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departments': departments,
      'designations': designations,
    };
  }
}