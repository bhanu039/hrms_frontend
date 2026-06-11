import 'package:flutter/material.dart';
import 'package:goexperts/core/services/api_service.dart';
import '../models/company_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
      isLoading = true;
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
                              openDocument(doc["fileUrl"]);
                            },
                            icon: const Icon(Icons.open_in_new),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> openDocument(fileUrl) async {
    final Uri url = Uri.parse("$fileUrl");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Could not open document";
    }
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
}
