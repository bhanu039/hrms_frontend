import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/core/widgets/custom_text_field.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/File_picker_widget.dart';
import '../../../core/widgets/dropdown_list.dart';
import '../../../core/widgets/location_get.dart';
import '../../../core/widgets/switch_bool.dart';
import '../bloc/emp_full_bloc.dart';
import '../bloc/emp_full_event.dart';
import '../bloc/emp_full_state.dart';

class EmployeeOnboardingScreen extends StatefulWidget {
  const EmployeeOnboardingScreen({super.key});

  @override
  State<EmployeeOnboardingScreen> createState() =>
      _EmployeeOnboardingScreenState();
}

class _EmployeeOnboardingScreenState extends State<EmployeeOnboardingScreen> {
  bool isexpirences = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmpFullRegBloc, EmpFullRegState>(
      builder: (context, state) {
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// STEP INDICATOR
                  _stepIndicator(state.currentStep),

                  const SizedBox(height: 10),

                  /// CONTENT
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildStep(context, state),
                  ),

                  /// BOTTOM BUTTONS
                  _bottomButtons(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ================= STEP INDICATOR =================
  Widget _stepIndicator(int step) {
    const totalSteps = 8;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(totalSteps, (i) {
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
  Widget _buildStep(BuildContext context, EmpFullRegState state) {
    switch (state.currentStep) {
      case 0:
        return KeyedSubtree(key: ValueKey(0), child: _step1(context, state));
      case 1:
        return KeyedSubtree(key: ValueKey(1), child: _step2(context, state));
      case 2:
        return KeyedSubtree(key: ValueKey(2), child: _step3(context, state));
      case 3:
        return KeyedSubtree(key: ValueKey(3), child: _step4(context, state));
      case 4:
        return KeyedSubtree(key: ValueKey(4), child: _step5(context, state));
      case 5:
        return KeyedSubtree(key: ValueKey(5), child: _step6(context, state));
      case 6:
        return KeyedSubtree(key: ValueKey(6), child: _step7(context, state));
      case 7:
        return KeyedSubtree(key: ValueKey(7), child: _preview(context, state));
      default:
        return const SizedBox();
    }
  }

  /// ================= STEP 1 =================
  Widget _step1(BuildContext context, EmpFullRegState state) {
    return _card("Basic Information", [
      /// 👤 First Name
      CustomTextField(
        label: "First Name",
        prefixIcon: const Icon(Icons.person),
        initialValue: state.model.firstName,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("firstName", value));
        },
        validator: (value) =>
            value == null || value.isEmpty ? "First name is required" : null,
      ),

      /// 👤 Middle Name
      CustomTextField(
        label: "Middle Name",
        prefixIcon: const Icon(Icons.person_outline),
        initialValue: state.model.middleName,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("middleName", value));
        },
      ),

      /// 👤 Last Name
      CustomTextField(
        label: "Last Name",
        prefixIcon: const Icon(Icons.person_2),
        initialValue: state.model.lastName,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("lastName", value));
        },
        validator: (value) =>
            value == null || value.isEmpty ? "Last name is required" : null,
      ),

      /// ⚧ Gender
      AppDropdown(
        label: "Gender",
        prefixIcon: const Icon(Icons.wc),
        value: state.model.gender,
        items: const ["Male", "Female", "Other"],
        onChanged: (val) {
          context.read<EmpFullRegBloc>().add(UpdateField("gender", val));
        },
      ),

      /// 📅 DOB
      CustomTextField(
        label: "Date of Birth",
        prefixIcon: const Icon(Icons.cake),
        initialValue: state.model.dob,
        readOnly: false,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            final formatted =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

            context.read<EmpFullRegBloc>().add(UpdateField("dob", formatted));
          }
        },
        validator: (value) =>
            value == null || value.isEmpty ? "DOB is required" : null,
      ),

      /// 💍 Marital Status
      AppDropdown(
        label: "Marital Status",
        prefixIcon: const Icon(Icons.favorite),
        value: state.model.maritalStatus,
        items: const ["Single", "Married", "Separated"],
        onChanged: (val) {
          context.read<EmpFullRegBloc>().add(UpdateField("maritalStatus", val));
        },
      ),

      const SizedBox(height: 15),

      /// 📸 PROFILE + SIGNATURE (better layout)
      Row(
        children: [
          /// Profile Photo
          Expanded(
            child: GestureDetector(
              onTap: () => pickImage(1),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: state.model.profilePhoto == null
                    ? const Center(child: Text("Upload Profile"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          state.model.profilePhoto!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Signature
          Expanded(
            child: GestureDetector(
              onTap: () => pickImage(2),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: state.model.signature == null
                    ? const Center(child: Text("Upload Signature"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          state.model.signature!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 15),

      /// 📄 Documents
      FileUploadWidget(
        label: "Aadhaar",
        initialFile: state.model.aadhaar,
        onFilePicked: (file) {
          context.read<EmpFullRegBloc>().add(UpdateField("aadhaar", file));
        },
      ),

      const SizedBox(height: 10),

      FileUploadWidget(
        label: "PAN",
        initialFile: state.model.pan,
        onFilePicked: (file) {
          context.read<EmpFullRegBloc>().add(UpdateField("pan", file));
        },
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
      final file = File(image.path);
      if (index == 1) {
        context.read<EmpFullRegBloc>().add(UpdateField("profilePhoto", file));
      } else {
        context.read<EmpFullRegBloc>().add(UpdateField("signature", file));
      }
    }
  }

  /// ================= STEP 2 =================
  Widget _step2(BuildContext context, EmpFullRegState state) {
    return _card("Contact Details", [
      /// 📧 Personal Email
      CustomTextField(
        label: "Personal Email",
        prefixIcon: const Icon(Icons.email),
        initialValue: state.model.personalEmail,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("personalEmail", value),
          );
        },
      ),

      /// 📞 Phone Number
      CustomTextField(
        label: "Phone Number",
        prefixIcon: const Icon(Icons.phone),
        keyboardType: TextInputType.phone,
        initialValue: state.model.phone,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("phone", value));
        },
      ),

      /// 📱 Alternate Phone
      CustomTextField(
        label: "Alternate Phone",
        prefixIcon: const Icon(Icons.phone_android),
        initialValue: state.model.alternatePhone,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("alternatePhone", value),
          );
        },
      ),

      const SizedBox(height: 10),

      /// 📍 LOCATION PICKER (FIXED + CLEAN)
      GestureDetector(
        onTap: () async {
          final location = await LocationHelper.getCurrentLocation();
          if (location == null) return;

          context.read<EmpFullRegBloc>().add(
            UpdateField("address", location["address1"]),
          );
          context.read<EmpFullRegBloc>().add(
            UpdateField("city", location["city"]),
          );
          context.read<EmpFullRegBloc>().add(
            UpdateField("state", location["state"]),
          );
          context.read<EmpFullRegBloc>().add(
            UpdateField("country", location["country"]),
          );
          context.read<EmpFullRegBloc>().add(
            UpdateField("pincode", location["pincode"]),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  state.model.address.isNotEmpty
                      ? state.model.address
                      : "Tap to get current location",
                  style: TextStyle(
                    color: state.model.address.isEmpty
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),

      const SizedBox(height: 15),

      /// 👨‍⚕️ EMERGENCY CONTACT HEADER
      Text(
        "Emergency Contact",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),

      const SizedBox(height: 10),

      /// 👤 Contact Person
      CustomTextField(
        label: "Contact Person Name",
        prefixIcon: const Icon(Icons.person),
        initialValue: state.model.emergencyContactName,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("emergencyContactName", value),
          );
        },
      ),

      /// 🤝 Relationship
      CustomTextField(
        label: "Relationship",
        prefixIcon: const Icon(Icons.family_restroom),
        initialValue: state.model.emergencyRelation,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("emergencyRelation", value),
          );
        },
      ),

      /// 📞 Emergency Number
      CustomTextField(
        label: "Emergency Contact Number",
        prefixIcon: const Icon(Icons.call),
        keyboardType: TextInputType.phone,
        initialValue: state.model.emergencyNumber,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("emergencyNumber", value),
          );
        },
      ),
    ]);
  }

  /// ================= STEP 3 =================
  Widget _step3(BuildContext context, EmpFullRegState state) {
    return _card("Education", [
      /// Degree
      CustomTextField(
        label: "Degree",
        prefixIcon: const Icon(Icons.school),
        initialValue: state.model.degree,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("degree", value));
        },
      ),

      /// Specialization
      CustomTextField(
        label: "Specialization",
        prefixIcon: const Icon(Icons.menu_book),
        initialValue: state.model.specialization,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("specialization", value),
          );
        },
      ),

      /// College
      CustomTextField(
        label: "College",
        prefixIcon: const Icon(Icons.account_balance),
        initialValue: state.model.college,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("college", value));
        },
      ),

      /// University
      CustomTextField(
        label: "University",
        prefixIcon: const Icon(Icons.apartment),
        initialValue: state.model.university,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("university", value));
        },
      ),

      /// Percentage
      CustomTextField(
        label: "Percentage",
        prefixIcon: const Icon(Icons.percent),
        keyboardType: TextInputType.number,
        initialValue: state.model.percentage,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("percentage", value));
        },
      ),

      const SizedBox(height: 10),

      /// 📅 Year Row (Cleaner UI)
      Row(
        children: [
          Expanded(
            child: CustomTextField(
              label: "Start Year",
              prefixIcon: const Icon(Icons.calendar_month),
              keyboardType: TextInputType.number,
              initialValue: state.model.startYear,
              onChanged: (value) {
                context.read<EmpFullRegBloc>().add(
                  UpdateField("startYear", value),
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: CustomTextField(
              label: "End Year",
              prefixIcon: const Icon(Icons.event),
              keyboardType: TextInputType.number,
              initialValue: state.model.endYear,
              onChanged: (value) {
                context.read<EmpFullRegBloc>().add(
                  UpdateField("endYear", value),
                );
              },
            ),
          ),
        ],
      ),

      const SizedBox(height: 15),

      /// Certificate Upload
      FileUploadWidget(
        label: "Provisional Certificate",
        initialFile: state.model.educationProof,
        onFilePicked: (file) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("educationProof", file),
          );
        },
      ),
    ]);
  }

  /// ================= STEP 4 =================
  Widget _step4(BuildContext context, EmpFullRegState state) {
    return _card("Experience", [
      SwitchListTile(
        title: const Text("Do you have prior work experience?"),
        value: isexpirences,
        onChanged: (v) => setState(() => isexpirences = v),
      ),

      isexpirences
          ? Column(
              children: [
                /// Company / Experience Dates Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Start Date",
                        prefixIcon: const Icon(Icons.calendar_today),
                        initialValue: state.model.experienceStartDate,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            final formatted =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                            context.read<EmpFullRegBloc>().add(
                              UpdateField("experienceStartDate", formatted),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: "End Date",
                        prefixIcon: const Icon(Icons.event_available),
                        initialValue: state.model.experienceEndDate,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            final formatted =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                            context.read<EmpFullRegBloc>().add(
                              UpdateField("experienceEndDate", formatted),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Technologies
                CustomTextField(
                  label: "Technologies",
                  prefixIcon: const Icon(Icons.code),
                  initialValue: state.model.technologies.join(", "),
                  onChanged: (value) {
                    context.read<EmpFullRegBloc>().add(
                      UpdateField(
                        "technologies",
                        value.split(",").map((e) => e.trim()).toList(),
                      ),
                    );
                  },
                ),

                /// Responsibilities
                CustomTextField(
                  label: "Responsibilities",
                  prefixIcon: const Icon(Icons.work_outline),
                  initialValue: state.model.responsibilities,
                  onChanged: (value) {
                    context.read<EmpFullRegBloc>().add(
                      UpdateField("responsibilities", value),
                    );
                  },
                ),

                /// UAN Number
                CustomTextField(
                  label: "UAN Number",
                  prefixIcon: const Icon(Icons.badge),
                  keyboardType: TextInputType.number,
                  initialValue: state.model.uanNumber,
                  onChanged: (value) {
                    context.read<EmpFullRegBloc>().add(
                      UpdateField("uanNumber", value),
                    );
                  },
                ),

                /// PF Number
                CustomTextField(
                  label: "PF Number",
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                  initialValue: state.model.pfNumber,
                  onChanged: (value) {
                    context.read<EmpFullRegBloc>().add(
                      UpdateField("pfNumber", value),
                    );
                  },
                ),

                /// ESI Number
                CustomTextField(
                  label: "ESI Number",
                  prefixIcon: const Icon(Icons.health_and_safety),
                  keyboardType: TextInputType.number,
                  initialValue: state.model.esiNumber,
                  onChanged: (value) {
                    context.read<EmpFullRegBloc>().add(
                      UpdateField("esiNumber", value),
                    );
                  },
                ),

                const SizedBox(height: 15),

                /// Relieving Letter
                FileUploadWidget(
                  label: "Relieving Letter",
                  initialFile: state.model.relievingLetter,
                  onFilePicked: (file) {
                    context.read<EmpFullRegBloc>().add(
                      UpdateField("relievingLetter", file),
                    );
                  },
                ),

                const SizedBox(height: 15),

                /// Payslips
                FileUploadWidget(
                  label: "Payslips / Experience Proof",
                  initialFile: state.model.payslips,
                  onFilePicked: (file) {
                    context.read<EmpFullRegBloc>().add(
                      UpdateField("payslips", file),
                    );
                  },
                ),
              ],
            )
          : const Text("Enable switch to add experience details"),
    ]);
  }

  Widget _step5(BuildContext context, EmpFullRegState state) {
    return _card("Skills", [
      CustomTextField(
        label: "Primary Skills",
        prefixIcon: const Icon(Icons.code),
        initialValue: state.model.primarySkills.join(", "),
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField(
              "primarySkills",
              value.split(",").map((e) => e.trim()).toList(),
            ),
          );
        },
      ),

      CustomTextField(
        label: "Secondary Skills",
        prefixIcon: const Icon(Icons.code_off),
        initialValue: state.model.secondarySkills.join(", "),
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField(
              "secondarySkills",
              value.split(",").map((e) => e.trim()).toList(),
            ),
          );
        },
      ),

      CustomTextField(
        label: "Certifications",
        prefixIcon: const Icon(Icons.verified),
        initialValue: state.model.certifications.join(", "),
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField(
              "certifications",
              value.split(",").map((e) => e.trim()).toList(),
            ),
          );
        },
      ),

      CustomTextField(
        label: "Languages Known",
        prefixIcon: const Icon(Icons.language),
        initialValue: state.model.languagesKnown.join(", "),
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField(
              "languagesKnown",
              value.split(",").map((e) => e.trim()).toList(),
            ),
          );
        },
      ),

      CustomTextField(
        label: "LinkedIn URL",
        prefixIcon: const Icon(Icons.link),
        initialValue: state.model.linkedinUrl,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("linkedinUrl", value));
        },
      ),

      CustomTextField(
        label: "GitHub URL",
        prefixIcon: const Icon(Icons.code),
        initialValue: state.model.githubUrl,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("githubUrl", value));
        },
      ),

      CustomTextField(
        label: "Portfolio URL",
        prefixIcon: const Icon(Icons.web),
        initialValue: state.model.portfolioUrl,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("portfolioUrl", value),
          );
        },
      ),
    ]);
  }

  Widget _step6(BuildContext context, EmpFullRegState state) {
    return _card("Bank Details", [
      CustomTextField(
        label: "Bank Name",
        prefixIcon: const Icon(Icons.account_balance),
        initialValue: state.model.bankName,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("bankName", value));
        },
      ),

      CustomTextField(
        label: "Account Holder Name",
        prefixIcon: const Icon(Icons.person),
        initialValue: state.model.accountHolderName,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("accountHolderName", value),
          );
        },
      ),

      CustomTextField(
        label: "Account Number",
        prefixIcon: const Icon(Icons.credit_card),
        keyboardType: TextInputType.number,
        initialValue: state.model.accountNumber,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("accountNumber", value),
          );
        },
      ),

      CustomTextField(
        label: "IFSC Code",
        prefixIcon: const Icon(Icons.code),
        initialValue: state.model.ifscCode,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("ifscCode", value));
        },
      ),

      CustomTextField(
        label: "Branch Name",
        prefixIcon: const Icon(Icons.location_city),
        initialValue: state.model.branchName,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("branchName", value));
        },
      ),

      CustomTextField(
        label: "UPI ID",
        prefixIcon: const Icon(Icons.qr_code),
        initialValue: state.model.upiId,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("upiId", value));
        },
      ),
    ]);
  }

  Widget _step7(BuildContext context, EmpFullRegState state) {
    return _card("Experience", [
      CustomTextField(
        label: "Nominee Name",
        prefixIcon: const Icon(Icons.person),
        initialValue: state.model.nomineeName,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("nomineeName", value));
        },
      ),

      CustomTextField(
        label: "Relationship",
        prefixIcon: const Icon(Icons.family_restroom),
        initialValue: state.model.nomineeRelation,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("nomineeRelation", value),
          );
        },
      ),

      CustomTextField(
        label: "Date of Birth",
        prefixIcon: const Icon(Icons.calendar_month),
        initialValue: state.model.nomineeDob,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("nomineeDob", value));
        },
      ),

      AppDropdown(
        label: "Gender",
        prefixIcon: const Icon(Icons.verified_user),
        value: state.model.nomineeGender,
        items: const ["Male", "Female", "Other"],
        onChanged: (val) {
          context.read<EmpFullRegBloc>().add(UpdateField("nomineeGender", val));
        },
      ),

      CustomTextField(
        label: "Phone Number",
        prefixIcon: const Icon(Icons.phone),
        keyboardType: TextInputType.phone,
        initialValue: state.model.nomineePhone,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("nomineePhone", value),
          );
        },
      ),

      CustomTextField(
        label: "Email",
        prefixIcon: const Icon(Icons.email),
        keyboardType: TextInputType.emailAddress,
        initialValue: state.model.nomineeEmail,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("nomineeEmail", value),
          );
        },
      ),

      CustomTextField(
        label: "Aadhaar Number",
        prefixIcon: const Icon(Icons.badge),
        keyboardType: TextInputType.number,
        initialValue: state.model.nomineeAadhaar,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("nomineeAadhaar", value),
          );
        },
      ),

      CustomTextField(
        label: "PAN Number",
        prefixIcon: const Icon(Icons.credit_card),
        initialValue: state.model.nomineePan,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(UpdateField("nomineePan", value));
        },
      ),

      CustomTextField(
        label: "Nominee Percentage",
        prefixIcon: const Icon(Icons.percent),
        keyboardType: TextInputType.number,
        initialValue: state.model.nomineePercentage.toString(),
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("nomineePercentage", int.tryParse(value) ?? 0),
          );
        },
      ),

      CustomTextField(
        label: "Nominee Address",
        prefixIcon: const Icon(Icons.location_on),
        initialValue: state.model.nomineeAddress,
        onChanged: (value) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("nomineeAddress", value),
          );
        },
      ),
    ]);
  }

  /// ================= PREVIEW =================
  Widget _preview(BuildContext context, EmpFullRegState state) {
    final m = state.model;

    return _card("Preview", [
      FileUploadWidget(
        label: "passport",
        initialFile: state.model.passport,
        onFilePicked: (file) {
          context.read<EmpFullRegBloc>().add(UpdateField("passport", file));
        },
      ),
      const SizedBox(height: 15),
      FileUploadWidget(
        label: "certificates",
        initialFile: state.model.certificates,
        onFilePicked: (file) {
          context.read<EmpFullRegBloc>().add(UpdateField("certificates", file));
        },
      ),
      const SizedBox(height: 15),
      FileUploadWidget(
        label: "other documents",
        initialFile: state.model.other,
        onFilePicked: (file) {
          context.read<EmpFullRegBloc>().add(UpdateField("other", file));
        },
      ),
      const SizedBox(height: 15),

      /// BASIC INFORMATION
      _previewHeading("Basic Information"),
      _previewText("First Name", m.firstName),
      _previewText("Middle Name", m.middleName),
      _previewText("Last Name", m.lastName),
      _previewText("Gender", m.gender),
      _previewText("Date of Birth", m.dob),
      _previewText("Marital Status", m.maritalStatus),

      const SizedBox(height: 20),

      /// CONTACT DETAILS
      _previewHeading("Contact Details"),
      _previewText("Personal Email", m.personalEmail),
      _previewText("Phone Number", m.phone),
      _previewText("Alternate Phone", m.alternatePhone),
      _previewText("Address", m.address),
      _previewText("City", m.city),
      _previewText("State", m.state),
      _previewText("Country", m.country),
      _previewText("Pincode", m.pincode),

      const SizedBox(height: 20),

      /// EMERGENCY CONTACT
      _previewHeading("Emergency Contact"),
      _previewText("Contact Person", m.emergencyContactName),
      _previewText("Relationship", m.emergencyRelation),
      _previewText("Contact Number", m.emergencyNumber),

      const SizedBox(height: 20),

      /// EDUCATION
      _previewHeading("Education"),
      _previewText("Degree", m.degree),
      _previewText("Specialization", m.specialization),
      _previewText("College", m.college),
      _previewText("University", m.university),
      _previewText("Percentage", m.percentage),
      _previewText("Start Year", m.startYear),
      _previewText("End Year", m.endYear),

      const SizedBox(height: 20),

      /// EXPERIENCE
      _previewHeading("Experience"),
      _previewText("Company Name", m.companyName),
      _previewText("Designation", m.role),
      _previewText("Start Date", m.experienceStartDate),
      _previewText("End Date", m.experienceEndDate),
      _previewText("Responsibilities", m.responsibilities),
      _previewText("Technologies", m.technologies.join(", ")),
      _previewText("UAN Number", m.uanNumber),
      _previewText("PF Number", m.pfNumber),
      _previewText("ESI Number", m.esiNumber),

      const SizedBox(height: 20),

      /// SKILLS
      _previewHeading("Skills"),
      _previewText("Primary Skills", m.primarySkills.join(", ")),
      _previewText("Secondary Skills", m.secondarySkills.join(", ")),
      _previewText("Certifications", m.certifications.join(", ")),
      _previewText("Languages Known", m.languagesKnown.join(", ")),
      _previewText("LinkedIn URL", m.linkedinUrl),
      _previewText("GitHub URL", m.githubUrl),
      _previewText("Portfolio URL", m.portfolioUrl),

      const SizedBox(height: 20),

      /// BANK DETAILS
      _previewHeading("Bank Details"),
      _previewText("Bank Name", m.bankName),
      _previewText("Account Holder Name", m.accountHolderName),
      _previewText("Account Number", m.accountNumber),
      _previewText("IFSC Code", m.ifscCode),
      _previewText("Branch Name", m.branchName),
      _previewText("UPI ID", m.upiId),

      const SizedBox(height: 20),

      /// NOMINEE DETAILS
      _previewHeading("Nominee Details"),
      _previewText("Nominee Name", m.nomineeName),
      _previewText("Relationship", m.nomineeRelation),
      _previewText("Date of Birth", m.nomineeDob),
      _previewText("Gender", m.nomineeGender),
      _previewText("Phone Number", m.nomineePhone),
      _previewText("Email", m.nomineeEmail),
      _previewText("Aadhaar Number", m.nomineeAadhaar),
      _previewText("PAN Number", m.nomineePan),
      _previewText("Nominee Percentage", m.nomineePercentage.toString()),
      _previewText("Address", m.nomineeAddress),

      AppSwitchTile(
        title: "Declaration Status",
        subtitle: "Enable if employe declaration is ok",
        value: state.model.isDeclaredTrue,
        onChanged: (val) {
          context.read<EmpFullRegBloc>().add(
            UpdateField("isDeclaredTrue", val),
          );
        },
      ),
    ]);
  }

  /// ================= INPUT FIELD =================

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
  Widget _bottomButtons(BuildContext context, EmpFullRegState state) {
    final bloc = context.read<EmpFullRegBloc>();
    const lastStep = 7;
    final isLastStep = state.currentStep == lastStep;

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
                if (isLastStep) {
                  if (state.model.isDeclaredTrue) {
                    bloc.add(SubmitForm());
                  } else {
                    TopMessage.show(
                      context,
                      "Please confirm your details before submitting",
                      color: Colors.red,
                    );
                  }
                } else {
                  bloc.add(NextStep());
                }
              },
              child: Text(
                isLastStep ? "Submit" : "Next",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}
