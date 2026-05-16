import 'package:flutter/material.dart';
import 'package:goexperts/services/api_service.dart';
import '../models/company_model.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  CompanyModel? company;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCompany();
  }

  Future<void> fetchCompany() async {
    try {
      final data = await ApiService.getCompanyProfile();

      setState(() {
        company = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint("FETCH COMPANY ERROR => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(title: const Text("Company Profile"), centerTitle: true),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : company == null
          ? const Center(child: Text("No Data Found"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// TOP CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            company!.name[0],
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          company!.name ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          company!.industryTypeId ?? "",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),

                        const SizedBox(height: 15),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: company!.status == "ACTIVE"
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            company!.status,
                            style: TextStyle(
                              color: company!.status == "ACTIVE"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// COMPANY DETAILS
                  buildSectionTitle("Company Details"),

                  buildInfoCard([
                    infoTile(Icons.person, "Owner Name", company!.ownerName),
                    infoTile(Icons.email, "Email", company!.email),
                    infoTile(Icons.phone, "Phone", company!.phone),
                    infoTile(Icons.language, "Website", company!.website),
                    // infoTile(
                    //   Icons.location_city,
                    //   "Location",
                    //   company!.location,
                    // ),
                  ]),

                  const SizedBox(height: 20),

                  /// ADDRESS
                  // buildSectionTitle("Address"),

                  // buildInfoCard([
                  //   infoTile(
                  //     Icons.home,
                  //     "Address",
                  //     "${company!.addressLine1}, "
                  //         "${company!.addressLine2}",
                  //   ),
                  //   infoTile(Icons.location_on, "City", company!.city),
                  //   infoTile(Icons.map, "State", company!.state),
                  //   infoTile(Icons.public, "Country", company!.country),
                  //   // infoTile(Icons.pin_drop, "Pincode", company!.pincode.toString()??""),
                  // ]),

                  // const SizedBox(height: 20),

                  /// DOCUMENTS
                  buildSectionTitle("Documents"),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: company!.documents.length,
                    itemBuilder: (context, index) {
                      final doc = company!.documents[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(doc["name"]),
                          subtitle: Text(doc["status"]),
                          trailing: IconButton(
                            onPressed: () {
                              // open document
                            },
                            icon: const Icon(Icons.open_in_new),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// SUBSCRIPTION
                  buildSectionTitle("Subscription"),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          infoRow(
                            "Plan",
                            company!.subscriptions[0]["plan"]["name"]
                                    ?.toString() ??
                                "N/A",
                          ),

                          infoRow(
                            "Employees",
                            company!
                                .subscriptions[0]["plan"]["features"]["employees"]
                                .toString(),
                          ),

                          infoRow(
                            "Support",
                            company!.subscriptions[0]["plan"]["features"]["support"]
                                    ?.toString() ??
                                "N/A",
                          ),

                          infoRow(
                            "Price",
                            "₹${company!.subscriptions[0]["plan"]["price"]}",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  Widget infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
