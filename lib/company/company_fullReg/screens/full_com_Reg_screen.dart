import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/company/company_fullReg/bloc/full_Reg_state.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/File_picker_widget.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/dropdown_list.dart';
import '../../../core/widgets/location_get.dart';
import '../../../core/widgets/switch_bool.dart';
import '../bloc/full_Reg_bloc.dart';
import '../bloc/full_Reg_event.dart';

class CompanyRegistrationPage extends StatefulWidget {
  const CompanyRegistrationPage({super.key});

  @override
  State<CompanyRegistrationPage> createState() =>
      _CompanyRegistrationPageState();
}

class _CompanyRegistrationPageState extends State<CompanyRegistrationPage> {
  int currentStep = 0;

  // Form keys for each step
  late final List<GlobalKey<FormState>> formKeys = List.generate(
    6,
    (_) => GlobalKey<FormState>(),
  );

  void nextStep() {
    // Validate current form before proceeding
    if (formKeys[currentStep].currentState!.validate()) {
      setState(() {
        if (currentStep < 5) currentStep++;
      });
    } else {
      TopMessage.show(
        context,
        "Please fill all required fields correctly",
        color: Colors.orange,
      );
    }
  }

  void prevStep() {
    setState(() {
      if (currentStep > 0) currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FullRegBloc, FullRegState>(
      listener: (context, state) {
        if (state.success) {
          TopMessage.show(
            context,
            "Company onboarding completed successfully!",
            color: Colors.green,
          );
          context.go('/');
        }else if (state.error != null) {
          TopMessage.show(context, state.error!, color: Colors.red);
        }
        

        if (state.error != null) {
          TopMessage.show(context, state.error!, color: Colors.red);
        }
      },

      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Company Onboarding"),
              centerTitle: true,
            ),

            body: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: currentStep,
                    children: [
                      _step1(context, state),
                      _step2(context, state),
                      _step3(context, state),
                      _step4(context, state),
                      _step5(context, state),
                      _preview(context, state),
                    ],
                  ),
                ),

                // NAVIGATION BUTTONS
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      if (currentStep > 0)
                        ElevatedButton(
                          onPressed: prevStep,
                          child: const Text("Back"),
                        ),

                      const Spacer(),

                      if (currentStep < 5)
                        ElevatedButton(
                          onPressed: nextStep,
                          child: const Text("Next"),
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            if (!state.model.declared) {
                              TopMessage.show(
                                context,
                                "Declaration must be accepted before submitting.",
                                color: Colors.orange,
                              );
                              return;
                            }

                            context.read<FullRegBloc>().add(
                              SubmitCompanyRegistration(),
                            );
                          },
                          child: state.loading
                              ? const CircularProgressIndicator()
                              : const Text("Submit"),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= STEP 1 =================
  Widget _step1(BuildContext context, FullRegState state) {
    return _card("Basic Information", [
      CustomTextField(
        label: "Legal Name",
        initialValue: state.model.legalName,
        prefixIcon: const Icon(Icons.business),
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("legalName", value));
        },
        validator: (value) =>
            value == null || value.isEmpty ? "Legal name is required" : null,
      ),

      CustomTextField(
        label: "Phone",
        initialValue: state.model.phone,
        keyboardType: TextInputType.phone,
        hintText: "Enter phone number",
        maxLength: 10,
        prefixIcon: const Icon(Icons.phone),
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("phone", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "Phone number is required";
          if (value.length != 10) return "Phone number must be 10 digits";
          return null;
        },
      ),
      CustomTextField(
        label: "Website",
        initialValue: state.model.website,
        prefixIcon: const Icon(Icons.language),
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("website", value));
        },
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            if (!value.contains('.') || !value.contains('http')) {
              return null;
            } else {
              return "Enter a valid website URL";
            }
          }
          return null;
        },
      ),

      CustomTextField(
        label: "LinkedIn URL",
        initialValue: state.model.linkedinUrl,
        prefixIcon: const Icon(Icons.link),
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("linkedinUrl", value));
        },
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            if (!value.contains('.com')) {
              return "Enter a valid LinkedIn URL";
            }
          }
          return null;
        },
      ),

      CustomTextField(
        label: "Company Size",
        initialValue: state.model.companySize,
        prefixIcon: const Icon(Icons.groups),
        keyboardType: TextInputType.number,
        hintText: "Maximum number of employees",
        maxLength: 5,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("companySize", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "Company size is required";
          if (int.tryParse(value) == null) return "Enter a valid number";
          return null;
        },
      ),

      CustomTextField(
        label: "Founded Year",
        initialValue: state.model.foundedYear,
        prefixIcon: const Icon(Icons.calendar_today),
        keyboardType: TextInputType.number,
        hintText: "Enter the year the company was founded",
        maxLength: 4,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("foundedYear", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "Founded year is required";
          final year = int.tryParse(value);
          if (year == null || year < 1900 || year > DateTime.now().year) {
            return "Enter a valid year";
          }
          return null;
        },
      ),

      CustomTextField(
        label: "CIN Number",
        initialValue: state.model.cinNumber,
        prefixIcon: const Icon(Icons.badge),
        keyboardType: TextInputType.number,
        hintText: "Enter the CIN number",
        maxLength: 21,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("cinNumber", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "CIN number is required";
          if (value.length < 21) return "CIN number must be 21 characters";
          return null;
        },
      ),

      GestureDetector(
        onTap: () => pickImage(1),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: state.model.companyLogo == null ? Colors.red : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: state.model.companyLogo == null
              ? const Center(child: Text("Upload Company Logo (Required)"))
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
            border: Border.all(
              color: state.model.signature == null ? Colors.red : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12),
          ),

          child: state.model.signature == null
              ? const Center(child: Text("Upload signature (Required)"))
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
    ], formKeys[0]);
  }

  Future<void> pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    final file = File(image.path);

    if (!mounted) return;

    context.read<FullRegBloc>().add(
      UpdateField(index == 1 ? "companyLogo" : "signature", file),
    );
  }

  /// ================= STEP 2 =================
  Widget _step2(BuildContext context, FullRegState state) {
    return _card("HR Settings", [
      CustomTextField(
        label: "Company Policy",
        initialValue: state.model.companyPolicy,
        maxLines: 40,
        minLines: 4,
        hintText: "Enter the company policies and guidelines",

        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("companyPolicy", value));
        },
        validator: (value) => value == null || value.isEmpty
            ? "Company policy is required"
            : null,
      ),

      CustomTextField(
        label: "Employee Terms",
        initialValue: state.model.employeeTerms,
        minLines: 4,
        maxLines: 40,
        hintText: "Enter the employee terms and conditions",
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("employeeTerms", value));
        },
        validator: (value) => value == null || value.isEmpty
            ? "Employee terms are required"
            : null,
      ),

      CustomTextField(
        label: "Working Hours",
        initialValue: state.model.workingHours,
        maxLength: 5,
        keyboardType: TextInputType.number,
        hintText: "Enter the working hours per day",
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("workingHours", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty)
            return "Working hours is required";
          if (double.tryParse(value) == null) return "Enter a valid number";
          return null;
        },
      ),
      CustomTextField(
        label: "Working days per week",
        initialValue: state.model.workingDays,
        maxLength: 5,
        keyboardType: TextInputType.number,
        hintText: "Enter the number of working days per week",
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("workingDays", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "Working days is required";
          if (double.tryParse(value) == null) return "Enter a valid number";
          return null;
        },
      ),
      AppDropdown(
        label: "Shift Type",
        value: state.model.shiftType,
        items: const ["General", "Night", "Rotational"],
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("shiftType", val));
        },
      ),

      AppDropdown(
        label: "Work Model",
        value: state.model.workModel,
        items: const ["On-site", "Hybrid", "Remote"],
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("workModel", val));
        },
      ),
    ], formKeys[1]);
  }

  /// ================= STEP 3 =================
  Widget _step3(BuildContext context, FullRegState state) {
    return _card("Compliance & Tax", [
      CustomTextField(
        label: "GST Number",
        initialValue: state.model.gstNumber,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("gstNumber", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "GST number is required";
          if (value.length <= 15) return "GST number must be 15 characters";
          return null;
        },
      ),

      CustomTextField(
        label: "PAN Number",
        initialValue: state.model.panNumber,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("panNumber", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "PAN number is required";
          if (value.length <= 10) return "PAN number must be 10 characters";
          return null;
        },
      ),

      CustomTextField(
        label: "TAN Number",
        initialValue: state.model.tanNumber,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("tanNumber", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "TAN number is required";
          if (value.length <= 10) return "TAN number must be 10 characters";
          return null;
        },
      ),

      AppSwitchTile(
        title: "PF Enabled",
        value: state.model.pfEnabled,
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("pfEnabled", val));
        },
      ),

      if (state.model.pfEnabled) ...[
        CustomTextField(
          label: "PF Percentage",
          initialValue: state.model.pfPercentage,
          keyboardType: TextInputType.number,
          hintText: "Enter PF percentage",
          onChanged: (value) {
            context.read<FullRegBloc>().add(UpdateField("pfPercentage", value));
          },
          validator: (value) {
            if (!state.model.pfEnabled) return null;
            if (value == null || value.isEmpty)
              return "PF percentage is required";
            final percentage = double.tryParse(value);
            if (percentage == null || percentage < 0 || percentage > 100) {
              return "Enter a valid PF percentage";
            }
            return null;
          },
        ),

        CustomTextField(
          label: "PF Registration Number",
          initialValue: state.model.pfRegistrationNumber,
          hintText: "Enter PF registration number",
          onChanged: (value) {
            context.read<FullRegBloc>().add(
              UpdateField("pfRegistrationNumber", value),
            );
          },
          validator: (value) {
            if (!state.model.pfEnabled) return null;
            if (value == null || value.isEmpty)
              return "PF registration number is required";
            return null;
          },
        ),
      ],

      AppSwitchTile(
        title: "ESI Enabled",
        value: state.model.esiEnabled,
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("esiEnabled", val));
        },
      ),

      if (state.model.esiEnabled) ...[
        CustomTextField(
          label: "ESI Registration Number",
          initialValue: state.model.esiRegistrationNumber,
          hintText: "Enter ESI registration number",
          onChanged: (value) {
            context.read<FullRegBloc>().add(
              UpdateField("esiRegistrationNumber", value),
            );
          },
          validator: (value) {
            if (!state.model.esiEnabled) return null;
            if (value == null || value.isEmpty)
              return "ESI registration number is required";
            return null;
          },
        ),
      ],

      CustomTextField(
        label: "PT Registration Number",
        initialValue: state.model.ptRegistrationNumber,
        hintText: "Enter PT registration number",
        onChanged: (value) {
          context.read<FullRegBloc>().add(
            UpdateField("ptRegistrationNumber", value),
          );
        },
        validator: (value) {
          if (value == null || value.isEmpty)
            return "PT registration number is required";
          return null;
        },
      ),
    ], formKeys[2]);
  }

  /// ================= STEP 4 =================
  Widget _step4(BuildContext context, FullRegState state) {
    return _card("Office Address", [
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
                UpdateField("city", location["city"] ?? ""),
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
              context.read<FullRegBloc>().add(
                UpdateField("landmark", location["landmark"] ?? ""),
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

      CustomTextField(
        label: "Address",
        initialValue: state.model.address1,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("address1", value));
        },
        validator: (value) =>
            value == null || value.isEmpty ? "Address is required" : null,
      ),

      CustomTextField(
        label: "City",
        initialValue: state.model.city,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("city", value));
        },
        validator: (value) =>
            value == null || value.isEmpty ? "City is required" : null,
      ),

      CustomTextField(
        label: "State",
        initialValue: state.model.state,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("state", value));
        },
        validator: (value) =>
            value == null || value.isEmpty ? "State is required" : null,
      ),

      AppDropdown(
        label: "Country",
        value: state.model.country,
        items: const ["India", "USA", "UK"],
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("country", val));
        },
      ),

      CustomTextField(
        label: "Pincode",
        initialValue: state.model.pincode,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("pincode", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "Pincode is required";
          if (value.length < 5) return "Pincode must be at least 5 digits";
          return null;
        },
      ),

      CustomTextField(
        label: "Landmark",
        initialValue: state.model.landmark,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("landmark", value));
        },
        validator: (value) =>
            value == null || value.isEmpty ? "Landmark is required" : null,
      ),

      CustomTextField(
        label: "GeofencRadius",
        initialValue: state.model.pincode,
        hintText: "Enter GeofencRadius  in meters of your comapany",
        keyboardType: TextInputType.number,
        maxLength: 3,
        onChanged: (value) {
          context.read<FullRegBloc>().add(UpdateField("geofencRadius", value));
        },
        validator: (value) {
          if (value == null || value.isEmpty) return "GeofencRadius is required";
          if (value.length < 5) return "GeofencRadius must be at least 5 digits";
          return null;
        },
      ),
    ], formKeys[3]);
  }

  // ================= STEP 5 =================
  Widget _step5(BuildContext context, FullRegState state) {
    return _card("Payroll & Documents", [
      AppDropdown(
        label: "Currency",
        value: state.model.currency,
        items: const ["INR", "USD", "GBP"],
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("currency", val));
        },
      ),

      AppDropdown(
        label: "Salary Cycle",
        value: state.model.salaryCycle,
        items: const ["Monthly", "Weekly"],
        onChanged: (val) {
          context.read<FullRegBloc>().add(UpdateField("salaryCycle", val));
        },
      ),

      // Upload GST Proof
      FileUploadWidget(
        label: "GST Proof",
        initialFile: state.model.gstProof,
        onFilePicked: (file) {
          context.read<FullRegBloc>().add(UpdateField("gstProof", file));
        },
      ),

      // Upload PAN Proof
      FileUploadWidget(
        label: "PAN Proof",
        initialFile: state.model.panProof,
        onFilePicked: (file) {
          context.read<FullRegBloc>().add(UpdateField("panProof", file));
        },
      ),
      // Upload TAN Proof
      FileUploadWidget(
        label: "TAN Proof",
        initialFile: state.model.tanProof,
        onFilePicked: (file) {
          context.read<FullRegBloc>().add(UpdateField("tanProof", file));
        },
      ),
      // Upload Registration Certificate
      FileUploadWidget(
        label: "Registration Certificate",
        initialFile: state.model.regCertificate,
        onFilePicked: (file) {
          context.read<FullRegBloc>().add(UpdateField("regCertificate", file));
        },
      ),
    ], formKeys[4]);
  }

  /// ================= PREVIEW =================
  Widget _preview(BuildContext context, FullRegState state) {
    final m = state.model;

    return _card("Preview", [
      // ================= BASIC INFO =================
      _previewText("Legal Name", m.legalName ?? "-"),

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
    ], formKeys[5]);
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
  Widget _card(
    String title,
    List<Widget> children,
    GlobalKey<FormState> formKey,
  ) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  /// ================= BOTTOM BUTTONS =================
}
