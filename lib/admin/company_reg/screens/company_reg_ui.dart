import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/admin/company_reg/bloc/company_reg_event.dart';

import '../bloc/company_reg_bloc.dart';
import '../bloc/company_reg_state.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Add Company"),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<AddCompanyBloc, AddCompanyState>(
        builder: (context, state) {
          final bloc = context.read<AddCompanyBloc>();

          InputDecoration decoration(String label, IconData icon) {
            return InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // ================= COMPANY NAME =================
                TextFormField(
                  onChanged: (v) => bloc.add(NameChanged(v)),
                  validator: (v) =>
                      v == null || v.trim().isEmpty
                          ? "Company name required"
                          : null,
                  decoration: decoration("Company Name", Icons.business),
                ),

                const SizedBox(height: 12),

                // ================= COMPANY EMAIL =================
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => bloc.add(EmailChanged(v)),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Email required";
                    }
                    if (!v.contains("@")) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                  decoration: decoration("Company Email", Icons.email),
                ),

                const SizedBox(height: 12),

                // ================= OWNER NAME =================
                TextFormField(
                  onChanged: (v) => bloc.add(OwnerNameChanged(v)),
                  validator: (v) =>
                      v == null || v.trim().isEmpty
                          ? "Owner name required"
                          : null,
                  decoration: decoration("Owner Name", Icons.person),
                ),

                const SizedBox(height: 12),

                // ================= OWNER EMAIL =================
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => bloc.add(OwnerEmailChanged(v)),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Owner email required";
                    }
                    if (!v.contains("@")) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                  decoration: decoration("Owner Email", Icons.alternate_email),
                ),

                const SizedBox(height: 12),

                // ================= LOCATION =================
                TextFormField(
                  onChanged: (v) => bloc.add(LocationChanged(v)),
                  validator: (v) =>
                      v == null || v.trim().isEmpty
                          ? "Location required"
                          : null,
                  decoration: decoration("Location", Icons.location_on),
                ),

                const SizedBox(height: 12),

                // ================= INDUSTRY DROPDOWN =================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: state.industryId,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Industry",
                    ),
                    items: state.industries
                        .map(
                          (e) => DropdownMenuItem(
                            value: e["id"].toString(),
                            child: Text(e["name"].toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        bloc.add(IndustryChanged(v));
                      }
                    },
                    validator: (v) =>
                        v == null || v.isEmpty ? "Select industry" : null,
                  ),
                ),

                const SizedBox(height: 25),

                // ================= SUBMIT BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: state.submitting
                        ? null
                        : () => bloc.add(SubmitCompany()),
                    child: state.submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Register Company",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                // ================= ERROR =================
                if (state.error != null)
                  Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}