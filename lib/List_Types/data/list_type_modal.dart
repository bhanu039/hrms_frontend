class ListTypeModel {
  final String id;
  final String name;

  final DateTime? createdAt;
  final ListCount? count;
  final int? designationCount;

  ListTypeModel({
    required this.id,
    required this.name,
    this.createdAt,
    this.count,
    this.designationCount,
  });

  factory ListTypeModel.fromJson(Map<String, dynamic> json) {
    return ListTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      count: json['_count'] != null ? ListCount.fromJson(json['_count']) : null,
      designationCount: json["designationCount"]??0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt?.toIso8601String() ?? '',
      '_count': count?.toJson(),
    };
  }
}

class ListCount {
  final int? departments;
  final int? designations;

  ListCount({this.departments, this.designations});

  factory ListCount.fromJson(Map<String, dynamic> json) {
    return ListCount(
      departments: json['departments'] ?? 0,
      designations: json['designations'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'departments': departments, 'designations': designations};
  }
}
