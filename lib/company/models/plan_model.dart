class Plan {
  String id;
  String name;
  double price;
  int duration;
  Features features;

  Plan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
  });

  factory Plan.fromJson(
    Map<String, dynamic> json,
  ) {
    return Plan(
      id: json['id'] ?? "",

      name: json['name'] ?? "",

      /// FIXED
      price:
          (json['price'] as num)
              .toDouble(),

      duration:
          json['duration'] ?? 0,

      features: Features.fromJson(
        json['features'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'features': features.toJson(),
    };
  }

  Plan copyWith({
    String? id,
    String? name,
    double? price,
    int? duration,
    Features? features,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      features: features ?? this.features,
    );
  }
}

class Features {

  String support;
  String employees;

  Map<String, String> extraFeatures;

  Features({
    required this.support,
    required this.employees,
    Map<String, String>? extraFeatures,
  }) : extraFeatures =
          extraFeatures ?? {};

  factory Features.fromJson(
    Map<String, dynamic> json,
  ) {

    Map<String, String> extra = {};

    json.forEach((key, value) {

      if (key != 'support' &&
          key != 'employees') {

        extra[key] =
            value.toString();
      }
    });

    return Features(
      support:
          json['support'] ?? "",

      /// FIXED
      employees:
          json['employees']
              .toString(),

      extraFeatures: extra,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'support': support,
      'employees': employees,
      ...extraFeatures,
    };
  }

  Features copyWith({
    String? support,
    String? employees,
    Map<String, String>? extraFeatures,
  }) {
    return Features(
      support: support ?? this.support,
      employees:
          employees ?? this.employees,
      extraFeatures:
          extraFeatures ??
          this.extraFeatures,
    );
  }
}