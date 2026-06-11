import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/company/company_fullReg/bloc/full_Reg_state.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/dropdown_list.dart';
import '../../../core/widgets/location_get.dart';
import '../../../core/widgets/switch_bool.dart';
import '../bloc/full_Reg_bloc.dart';
import '../bloc/full_Reg_event.dart';

class CompanyFullRegScreen extends StatefulWidget {
  const CompanyFullRegScreen({super.key});

  @override
  State<CompanyFullRegScreen> createState() => _CompanyFullRegScreenState();
}

class _CompanyFullRegScreenState extends State<CompanyFullRegScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FullRegBloc, FullRegState>(
      builder: (context, state) {
        final bloc = context.read<FullRegBloc>();

        return Scaffold(
          backgroundColor: const Color(0xffF4F7FC),

          /// ================= APP BAR =================
          appBar: AppBar(
            title: const Text("Company Full Registration"),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),

          /// ================= BODY =================
          body: Column(
            children: [
              const SizedBox(height: 10),

              /// STEP INDICATOR
              _stepIndicator(state.currentStep),

              const SizedBox(height: 10),

              /// CONTENT
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStep(context, state),
                ),
              ),

              /// BOTTOM BUTTONS
              _bottomButtons(context, state),
            ],
          ),
        );
      },
    );
  }

  /// ================= STEP INDICATOR =================
  Widget _stepIndicator(int step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(5, (i) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              decoration: BoxDecoration(
                color: i <= step ? Colors.indigo : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// ================= STEP ROUTER =================
  Widget _buildStep(BuildContext context, FullRegState state) {
    switch (state.currentStep) {
      case 0:
        return _step1(context, state);
      case 1:
        return _step2(context, state);
      case 2:
        return _step3(context, state);
      case 3:
        return _step4(context, state);
      case 4:
        return _preview(context, state);
      default:
        return const SizedBox();
    }
  }

  /// ================= STEP 1 =================
  Widget _step1(BuildContext context, FullRegState state) {
    return _card("Basic Information", [
      _input(context, "name", "Company Name", state.model.name ?? ""),
      _input(context, "legalName", "Legal Name", state.model.legalName ?? ""),
      _input(context, "domain", "Domain", state.model.domain ?? ""),
      _input(context, "website", "Website", state.model.website ?? ""),
      _input(context, "phone", "Phone", state.model.phone ?? ""),

      GestureDetector(
        onTap: () => pickImage(1),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: state.model.companyLogo == null
              ? const Center(child: Text("Upload Company Logo"))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    state.model.companyLogo!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
        ),
      ),

      const SizedBox(height: 15),

      // IMAGE 2
      GestureDetector(
        onTap: () => pickImage(2),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),

          child: state.model.signature == null
              ? const Center(child: Text("Upload signature 2"))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    state.model.signature!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
        ),
      ),
    ]);
  }

  Future<void> pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        if (index == 1) {
          context.read<FullRegBloc>().add(
            UpdateField("companyLogo", image.path),
          );
        } else {
          context.read<FullRegBloc>().add(UpdateField("signature", image.path));
        }
      });
    }
  }

  /// ================= STEP 2 =================
  Widget _step2(BuildContext context, FullRegState state) {
    return _card("Company Details", [
      _input(
        context,
        "companySize",
        "Company Size",
        state.model.companySize ?? "",
      ),
      _input(
        context,
        "foundedYear",
        "Founded Year",
        state.model.foundedYear ?? "",
      ),
      AppDropdown(
        label: "Work Model",
        value: state.model.workModel,
        items: const ["Remote", "Hybrid", "Onsite"],
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("workModel", val));
        },
      ),
      AppDropdown(
        label: "Shift Type",
        value: state.model.shiftType,
        items: const ["Day", "Night", "Rotational"],
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("shiftType", val));
        },
      ),
    ]);
  }

  /// ================= STEP 3 =================
  Widget _step3(BuildContext context, FullRegState state) {
    return _card("Payroll", [
      _input(context, "currency", "Currency", state.model.currency ?? ""),
      _input(
        context,
        "salaryCycle",
        "Salary Cycle",
        state.model.salaryCycle ?? "",
      ),
      _input(
        context,
        "pfPercentage",
        "PF Percentage",
        state.model.pfPercentage ?? "",
      ),
    ]);
  }

  /// ================= STEP 4 =================
  Widget _step4(BuildContext context, FullRegState state) {
    return _card("Location", [
      GestureDetector(
        onTap: () async {
          final location = await LocationHelper.getCurrentLocation();

          if (location != null) {
            setState(() {
              context.read<FullRegBloc>().add(
                UpdateField("address1", location["address1"] ?? ""),
              );

              context.read<FullRegBloc>().add(
                UpdateField("state", location["state"] ?? ""),
              );
              context.read<FullRegBloc>().add(
                UpdateField("country", location["country"] ?? ""),
              );

              context.read<FullRegBloc>().add(
                UpdateField("pincode", location["pincode"] ?? ""),
              );

              context.read<FullRegBloc>().add(
                UpdateField("latitude", location["latitude"] ?? ""),
              );
              context.read<FullRegBloc>().add(
                UpdateField("longitude", location["longitude"] ?? ""),
              );
            });
          }
        },

        child: Container(
          margin: const EdgeInsets.only(bottom: 20),

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade500, Colors.indigo.shade300],
            ),

            borderRadius: BorderRadius.circular(22),

            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: const Icon(Icons.map, color: Colors.white, size: 30),
              ),

              const SizedBox(width: 15),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Select Location From Map",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Auto fill address with coordinates",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
      ),

      _input(context, "address1", "Address", state.model.address1 ?? ""),
      _input(context, "city", "City", state.model.city ?? ""),
      _input(context, "state", "State", state.model.state ?? ""),
      _input(context, "pincode", "Pincode", state.model.pincode ?? ""),
      AppDropdown(
        label: "Country",
        value: state.model.country,
        items: const ["India", "USA", "UK"],
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("Country", val));
        },
      ),

      _input(context, "state", "State", state.model.latitude.toString() ?? ""),
      _input(
        context,
        "pincode",
        "Pincode",
        state.model.longitude.toString() ?? "",
      ),
    ]);
  }

  /// ================= PREVIEW =================
  Widget _preview(BuildContext context, FullRegState state) {
    final m = state.model;

    return _card("Preview", [
      // ================= BASIC INFO =================
      _previewText("Company Name", m.name ?? "-"),
      _previewText("Legal Name", m.legalName ?? "-"),
      _previewText("Domain", m.domain ?? "-"),
      _previewText("Website", m.website ?? "-"),
      _previewText("Phone", m.phone ?? "-"),

      // ================= COMPANY IMAGE =================
      _previewText("Company Logo", m.companyLogo != null ? "Uploaded" : "-"),
      _previewText("Signature", m.signature != null ? "Uploaded" : "-"),

      // ================= COMPANY DETAILS =================
      _previewText("Company Size", m.companySize ?? "-"),
      _previewText("Founded Year", m.foundedYear ?? "-"),
      _previewText("Work Model", m.workModel ?? "-"),
      _previewText("Shift Type", m.shiftType ?? "-"),

      // ================= PAYROLL =================
      _previewText("Currency", m.currency ?? "-"),
      _previewText("Salary Cycle", m.salaryCycle ?? "-"),
      _previewText("PF Percentage", m.pfPercentage ?? "-"),

      // ================= LOCATION =================
      _previewText("Address", m.address1 ?? "-"),
      _previewText("City", m.city ?? "-"),
      _previewText("State", m.state ?? "-"),
      _previewText("Country", m.country ?? "-"),
      _previewText("Pincode", m.pincode ?? "-"),

      // ================= SYSTEM =================
      _previewText("Declaration Status", (m.declared ?? false) ? "Yes" : "No"),

      AppSwitchTile(
        title: "Declaration Status",
        subtitle: "Enable if company declaration is completed",
        value: state.model.declared,
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("declared", val));
        },
      ),
    ]);
  }

  /// ================= INPUT FIELD =================
  Widget _input(BuildContext context, String key, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        initialValue: value,
        onChanged: (v) => context.read<FullRegBloc>().add(UpdateField(key, v)),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  /// ================= PREVIEW TEXT =================
  Widget _previewText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// ================= CARD =================
  Widget _card(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  /// ================= BOTTOM BUTTONS =================
  Widget _bottomButtons(BuildContext context, FullRegState state) {
    final bloc = context.read<FullRegBloc>();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          /// PREVIOUS
          if (state.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => bloc.add(PrevStep()),
                child: const Text("Previous"),
              ),
            ),

          if (state.currentStep > 0) const SizedBox(width: 10),

          /// NEXT / SUBMIT
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.all(14),
              ),
              onPressed: () {
                if (state.currentStep == 4) {
                  bloc.add(SubmitForm());
                } else {
                  bloc.add(NextStep());
                }
              },
              child: Text(
                state.currentStep == 4 ? "Submit" : "Next",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
