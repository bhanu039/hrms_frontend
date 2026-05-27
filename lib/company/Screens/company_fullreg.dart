import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:goexperts/services/sessionservice.dart';
import 'package:goexperts/widgets/top_message.dart';

import '../../services/api_service.dart';
import '../../state/models/user_session.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/location_get.dart';

class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  int currentStep = 0;
  bool isLoading = false;
  final email = SessionService.getEmail();

  /// ================= FILES =================

  File? companyLogo;
  File? gstFile;
  double? latitude;
  double? longitude;

  /// ================= CONTROLLERS =================

  // Basic
  final nameController = TextEditingController();
  final legalNameController = TextEditingController();
  final domainController = TextEditingController();
  final websiteController = TextEditingController();
  final phoneController = TextEditingController();

  // Company
  final industryTypeController = TextEditingController();
  final companySizeController = TextEditingController();
  final foundedYearController = TextEditingController();

  // Policy
  final workingHoursController = TextEditingController();
  final workingDaysController = TextEditingController();
  final probationController = TextEditingController();
  final noticeController = TextEditingController();
  final companyPolicyController = TextEditingController();

  // Payroll
  final currencyController = TextEditingController();
  final salaryCycleController = TextEditingController();
  final payrollStartController = TextEditingController();
  final payrollEndController = TextEditingController();

  bool pfEnabled = true;
  bool esiEnabled = true;

  final pfPercentageController = TextEditingController();

  // Localization
  final timezoneController = TextEditingController();
  final dateFormatController = TextEditingController();
  final languageController = TextEditingController();

  // Address
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();

  // Tax
  final gstController = TextEditingController();
  final panController = TextEditingController();
  final tanController = TextEditingController();

  /// ================= PICK FILE =================

  Future<void> pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);

      setState(() {
        if (type == "logo") {
          companyLogo = file;
        }

        if (type == "gst") {
          gstFile = file;
        }
      });
    }
  }

  /// ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Company Registration",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          /// ================= STEP INDICATOR =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: Row(
              children: List.generate(
                5,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 6,

                    decoration: BoxDecoration(
                      color: currentStep >= index
                          ? Colors.indigo
                          : Colors.grey.shade300,

                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: buildStepContent(),
              ),
            ),
          ),

          /// ================= BOTTOM BUTTONS =================
          Container(
            padding: const EdgeInsets.all(20),

            decoration: const BoxDecoration(
              color: Colors.white,

              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),

            child: Row(
              children: [
                if (currentStep != 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          currentStep--;
                        });
                      },

                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      child: const Text("Back"),
                    ),
                  ),

                if (currentStep != 0) const SizedBox(width: 15),

                Expanded(
                  child: AppGradientButton(
                    text: currentStep == 4 ? "Submit" : "Next",

                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (currentStep < 4) {
                              setState(() {
                                currentStep++;
                              });
                            } else {
                              submitForm();
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= STEP CONTENT =================

  Widget buildStepContent() {
    switch (currentStep) {
      /// STEP 1
      case 0:
        return buildCard("Basic Information", Icons.business, [
          buildField(nameController, "Company Name"),
          buildField(legalNameController, "Legal Name"),
          buildField(domainController, "Domain"),
          buildField(websiteController, "Website"),
          buildField(phoneController, "Phone Number"),

          buildUploadTile(
            "Company Logo",
            Icons.image,
            () => pickFile("logo"),
            companyLogo,
          ),
        ]);

      /// STEP 2
      case 1:
        return buildCard("Company Details", Icons.work_outline, [
          buildField(industryTypeController, "Industry Type ID"),
          buildField(companySizeController, "Company Size"),
          buildField(foundedYearController, "Founded Year"),

          buildField(workingHoursController, "Working Hours"),
          buildField(workingDaysController, "Working Days"),
          buildField(probationController, "Probation Period"),
          buildField(noticeController, "Notice Period"),

          buildMultiField(companyPolicyController, "Company Policy"),
        ]);

      /// STEP 3
      case 2:
        return buildCard("Payroll Settings", Icons.payments_outlined, [
          buildField(currencyController, "Currency"),
          buildField(salaryCycleController, "Salary Cycle"),
          buildField(payrollStartController, "Payroll Start Day"),
          buildField(payrollEndController, "Payroll End Day"),
          buildField(pfPercentageController, "PF Percentage"),

          SwitchListTile(
            value: pfEnabled,
            title: const Text("PF Enabled"),

            onChanged: (value) {
              setState(() {
                pfEnabled = value;
              });
            },
          ),

          SwitchListTile(
            value: esiEnabled,
            title: const Text("ESI Enabled"),

            onChanged: (value) {
              setState(() {
                esiEnabled = value;
              });
            },
          ),
        ]);

      /// STEP 4
      case 3:
        return buildCard("Localization & Address", Icons.location_on_outlined, [
          /// TIMEZONE
          buildField(timezoneController, "Timezone"),

          buildField(dateFormatController, "Date Format"),

          buildField(languageController, "Language"),

          const SizedBox(height: 10),

          /// MAP PICKER CARD
          GestureDetector(
            onTap: () async {
              final location = await LocationHelper.getCurrentLocation();

              if (location != null) {
                setState(() {
                  address1Controller.text = location["address1"] ?? "";

                  cityController.text = location["city"] ?? "";

                  stateController.text = location["state"] ?? "";

                  countryController.text = location["country"] ?? "";

                  pincodeController.text = location["pincode"] ?? "";

                  latitude = location["latitude"];
                  longitude = location["longitude"];
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

          /// AUTO FILLED FIELDS
          AbsorbPointer(
            child: buildField(address1Controller, "Address Line 1"),
          ),

          AbsorbPointer(child: buildField(cityController, "City")),

          AbsorbPointer(child: buildField(stateController, "State")),

          AbsorbPointer(child: buildField(countryController, "Country")),

          AbsorbPointer(child: buildField(pincodeController, "Pincode")),

          /// LOCATION INFO CARD
          if (latitude != null && longitude != null)
            Container(
              width: double.infinity,

              margin: const EdgeInsets.only(top: 10),

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),

                border: Border.all(color: Colors.green.shade200),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),

                      SizedBox(width: 10),

                      Text(
                        "Location Selected",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Latitude : $latitude",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Longitude : $longitude",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ]);

      /// STEP 5
      default:
        return buildCard("Tax & Documents", Icons.description_outlined, [
          buildField(gstController, "GST Number"),
          buildField(panController, "PAN Number"),
          buildField(tanController, "TAN Number"),

          const SizedBox(height: 15),

          buildUploadTile(
            "GST Certificate",
            Icons.picture_as_pdf,
            () => pickFile("gst"),
            gstFile,
          ),
          buildUploadTile(
            "GST Certificate",
            Icons.picture_as_pdf,
            () => pickFile("gst"),
            gstFile,
          ),
          buildUploadTile(
            "GST Certificate",
            Icons.picture_as_pdf,
            () => pickFile("gst"),
            gstFile,
          ),
          buildUploadTile(
            "GST Certificate",
            Icons.picture_as_pdf,
            () => pickFile("gst"),
            gstFile,
          ),
          buildUploadTile(
            "GST Certificate",
            Icons.picture_as_pdf,
            () => pickFile("gst"),
            gstFile,
          ),
        ]);
    }
  }

  /// ================= CARD =================

  Widget buildCard(String title, IconData icon, List<Widget> children) {
    return Container(
      key: ValueKey(currentStep),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Icon(icon, color: Colors.indigo),
              ),

              const SizedBox(width: 15),

              Text(
                title,

                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          ...children,
        ],
      ),
    );
  }

  /// ================= TEXT FIELD =================

  Widget buildField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextField(
        controller: controller,

        decoration: InputDecoration(
          hintText: hint,

          filled: true,
          fillColor: Colors.grey.shade100,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// ================= MULTI FIELD =================

  Widget buildMultiField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextField(
        controller: controller,
        maxLines: 5,

        decoration: InputDecoration(
          hintText: hint,

          filled: true,
          fillColor: Colors.grey.shade100,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// ================= UPLOAD TILE =================

  Widget buildUploadTile(
    String title,
    IconData icon,
    VoidCallback onTap,
    File? file,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.withValues(alpha: 0.1),

          child: Icon(icon, color: Colors.indigo),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        subtitle: file != null
            ? Text(file.path.split('/').last)
            : const Text("No file selected"),

        trailing: ElevatedButton(
          onPressed: onTap,

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          child: Text(
            file != null ? "Change" : "Upload",

            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// ================= SUBMIT =================

  Future<void> submitForm() async {
    final ApiService apiService = ApiService();

    try {
      setState(() {
        isLoading = true;
      });

      final body = {
        "name": nameController.text,
        "legalName": legalNameController.text,
        "domain": domainController.text,
        "website": websiteController.text,
        "phone": phoneController.text,

        "industryTypeId": industryTypeController.text,
        "companySize": companySizeController.text,
        "foundedYear": foundedYearController.text,

        "workingHours": workingHoursController.text,
        "workingDays": workingDaysController.text,
        "defaultProbationPeriod": probationController.text,
        "defaultNoticePeriod": noticeController.text,
        "companyPolicy": companyPolicyController.text,

        "currency": currencyController.text,
        "salaryCycle": salaryCycleController.text,
        "payrollStartDay": payrollStartController.text,
        "payrollEndDay": payrollEndController.text,
        "pfEnabled": pfEnabled,
        "pfPercentage": pfPercentageController.text,
        "esiEnabled": esiEnabled,

        "timezone": timezoneController.text,
        "dateFormat": dateFormatController.text,
        "language": languageController.text,

        "addressLine1": address1Controller.text,
        "addressLine2": address2Controller.text,
        "city": cityController.text,
        "state": stateController.text,
        "country": countryController.text,
        "pincode": pincodeController.text,
        "latitude": latitude?.toString(),
        "longitude": longitude?.toString(),

        "gstNumber": gstController.text,
        "panNumber": panController.text,
        "tanNumber": tanController.text,

        "companyLogo": companyLogo?.path,
        "gstFile": gstFile?.path,
      };

      print(body);

      final response = await apiService.updateCompany(
        data: body,
        companyLogoPath: companyLogo?.path,
        gstFilePath: gstFile?.path,
      );

      if (response.statusCode == 200) {
        clearForm();
        await SessionService.updateProfileStatus(true);

        TopMessage.show(
          context,
          "Company profile updated successfully",
          color: Colors.green,
        );

        setState(() {
          currentStep = 0;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// ================= CLEAR ALL FIELDS =================

  void clearForm() {
    /// BASIC
    nameController.clear();
    legalNameController.clear();
    domainController.clear();
    websiteController.clear();
    phoneController.clear();

    /// COMPANY
    industryTypeController.clear();
    companySizeController.clear();
    foundedYearController.clear();

    /// POLICY
    workingHoursController.clear();
    workingDaysController.clear();
    probationController.clear();
    noticeController.clear();
    companyPolicyController.clear();

    /// PAYROLL
    currencyController.clear();
    salaryCycleController.clear();
    payrollStartController.clear();
    payrollEndController.clear();
    pfPercentageController.clear();

    /// LOCALIZATION
    timezoneController.clear();
    dateFormatController.clear();
    languageController.clear();

    /// ADDRESS
    address1Controller.clear();
    address2Controller.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pincodeController.clear();

    /// TAX
    gstController.clear();
    panController.clear();
    tanController.clear();

    /// FILES
    companyLogo = null;
    gstFile = null;

    /// LOCATION
    latitude = null;
    longitude = null;

    /// SWITCHES
    pfEnabled = true;
    esiEnabled = true;

    /// STEP RESET
    currentStep = 0;

    setState(() {});
  }
}
