class CompanyModel {

  String id;
  String name;
  String email;
  String ownerName;
  String phone;
  String website;
  String industry;
  String location;
  String status;

  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String country;
  String pincode;

  List documents;
  List subscriptions;

  CompanyModel({
    required this.id,
    required this.name,
    required this.email,
    required this.ownerName,
    required this.phone,
    required this.website,
    required this.industry,
    required this.location,
    required this.status,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.documents,
    required this.subscriptions,
  });

  factory CompanyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CompanyModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      ownerName: json["ownerName"] ?? "",
      phone: json["phone"] ?? "",
      website: json["website"] ?? "",
      industry: json["industry"] ?? "",
      location: json["location"] ?? "",
      status: json["status"] ?? "",
      addressLine1: json["addressLine1"] ?? "",
      addressLine2: json["addressLine2"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
      pincode: json["pincode"] ?? "",

      documents: json["documents"] ?? [],
      subscriptions: json["subscriptions"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "ownerName": ownerName,
      "phone": phone,
      "website": website,
      "industry": industry,
      "location": location,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "city": city,
      "state": state,
      "country": country,
      "pincode": pincode,
    };
  }
}