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

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      features: Features.fromJson(json['features'] ?? {}),
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
}

class Features {
  final Map<String, String> data;

  Features({required this.data});

  factory Features.fromJson(Map<String, dynamic> json) {
    Map<String, String> map = {};

    json.forEach((key, value) {
      map[key] = value.toString();
    });

    return Features(data: map);
  }

  Map<String, dynamic> toJson() {
    return data;
  }
}