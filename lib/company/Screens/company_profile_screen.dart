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
  String? error;

  @override
  void initState() {
    super.initState();
    fetchCompany();
  }

  Future<void> fetchCompany() async {
    try {
      final data = await ApiService.getCompanyProfile();

      if (!mounted) return;

      setState(() {
        company = data;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Company Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? _buildError()
          : company == null
          ? const Center(child: Text("No Company Data Found"))
          : RefreshIndicator(
              onRefresh: fetchCompany,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildInfoCard(),
                  ],
                ),
              ),
            ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    final name = company?.name ?? "Company";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF145DA0)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            company?.industryTypeId ?? "N/A",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: (company?.status == "ACTIVE") ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              company?.status ?? "UNKNOWN",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO CARD =================
  Widget _buildInfoCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: _subscriptionInfo(),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _sectionTitle("Company Details"),

              _infoTile(Icons.person, "Owner", company?.ownerName),
              _infoTile(Icons.email, "Email", company?.email),
              _infoTile(Icons.phone, "Phone", company?.phone),
              _infoTile(Icons.language, "Website", company?.website),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }

  // ================= SUBSCRIPTION =================
  Widget _subscriptionInfo() {
    final subs = company?.subscriptions;

    if (subs == null || subs.isEmpty) {
      return const Text("No Subscription Found");
    }

    final sub = subs[0];
    final plan = sub["plan"] ?? {};

    return Column(
      children: [
        _sectionTitle("Subscription"),
        _infoRow("Plan", plan["name"]?.toString() ?? "N/A"),
        _infoRow(
          "Employees",
          plan["features"]?["employees"]?.toString() ?? "N/A",
        ),
        _infoRow("Support", plan["features"]?["support"]?.toString() ?? "N/A"),
        _infoRow("Price", "₹${plan["price"] ?? "N/A"}"),
      ],
    );
    
  }

  // ================= WIDGET HELPERS =================
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 3),
                Text(
                  value ?? "N/A",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ================= ERROR UI =================
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 60, color: Colors.red),
          const SizedBox(height: 10),
          Text(error ?? "Something went wrong"),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: fetchCompany, child: const Text("Retry")),
        ],
      ),
    );
  }
}
