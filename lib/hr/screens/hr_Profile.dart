import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/api_service.dart';
import '../../core/services/sessionservice.dart';
import '../../core/widgets/top_message.dart';

class HrProfileScreen extends StatefulWidget {
  const HrProfileScreen({super.key});

  @override
  State<HrProfileScreen> createState() => _HrProfileScreenState();
}

class _HrProfileScreenState extends State<HrProfileScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;

  late TabController tabController;

  Map<String, dynamic> profile = {};
  Map<String, dynamic> originalProfile = {};

  File? imageFile;
  final picker = ImagePicker();

  // ---------------- EDIT FLAGS (NO UI CHANGE) ----------------
  Map<String, bool> editMode = {
    "personal": false,
    "education": false,
    "experience": false,
    "bank": false,
    "nominee": false,
  };

  // ---------------- CONTROLLERS ----------------
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final altPhoneCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final addressLine1ctrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final pinCtrl = TextEditingController();

  final degreeCtrl = TextEditingController();
  final specCtrl = TextEditingController();
  final collegeCtrl = TextEditingController();
  final cgpaCtrl = TextEditingController();

  final companyCtrl = TextEditingController();
  final roleCtrl = TextEditingController();
  final techCtrl = TextEditingController();

  final primarySkillCtrl = TextEditingController();
  final secondarySkillCtrl = TextEditingController();
  final certificateCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();

  final bankNameCtrl = TextEditingController();
  final accCtrl = TextEditingController();
  final ifscCtrl = TextEditingController();

  final nomineeNameCtrl = TextEditingController();
  final nomineeRelCtrl = TextEditingController();
  final nomineeAadhaarCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    fetchProfile();
  }

  // ---------------- FETCH API ----------------
  Future<void> fetchProfile() async {
    String? id = (await SessionService.getID())!;
    print("Session ID: $id");
    setState(() => loading = true);
    try {
      final res = await ApiService.getEmpProfile(id: id);
      print("API Response: $res");
   

  
    if (res["success"] == true) {
      if (res["data"] == null) {
        setState(() => loading = false);
        TopMessage.show(context, "Profile data is null", color: Colors.red);
        return;
      }
      profile = res["data"];

      // backup for cancel

      emailCtrl.text = profile["user"]?["email"] ?? "";

      final p = profile["personal"] ?? {};
      phoneCtrl.text = p["phone"] ?? "";
      altPhoneCtrl.text = p["alternatePhone"] ?? "";
      addressLine1ctrl.text = p["addressLine1"] ?? "";
      cityCtrl.text = p["city"] ?? "";
      stateCtrl.text = p["state"] ?? "";
      countryCtrl.text = p["country"] ?? "";
      pinCtrl.text = p["pincode"] ?? "";
      final s = profile["skills"] ?? {};

      primarySkillCtrl.text = parseList(s["primarySkills"]).join(", ");
      secondarySkillCtrl.text = parseList(s["secondarySkills"]).join(", ");
      certificateCtrl.text = parseList(s["certifications"]).join(", ");

      linkedinCtrl.text = s["linkedinUrl"] ?? "";

      if ((profile["educations"] ?? []).isNotEmpty) {
        final e = profile["educations"][0];
        degreeCtrl.text = e["degree"] ?? "";
        specCtrl.text = e["specialization"] ?? "";
        collegeCtrl.text = e["college"] ?? "";
        cgpaCtrl.text = e["cgpa"] ?? "";
      }

      if ((profile["experiences"] ?? []).isNotEmpty) {
        final ex = profile["experiences"][0];
        companyCtrl.text = ex["companyName"] ?? "";
        roleCtrl.text = ex["role"] ?? "";
        techCtrl.text = ex["technologies"] ?? "";
      }

      final b = profile["bankDetails"] ?? {};
      bankNameCtrl.text = b["bankName"] ?? "";
      accCtrl.text = b["accountNumber"] ?? "";
      ifscCtrl.text = b["ifscCode"] ?? "";

      final n = profile["nominee"] ?? {};
      nomineeNameCtrl.text = n["nomineeName"] ?? "";
      nomineeRelCtrl.text = n["relationship"] ?? "";
      nomineeAadhaarCtrl.text = n["aadhaarNumber"] ?? "";

      setState(() => loading = false);
    } else {
      setState(() => loading = false);
      TopMessage.show(context, "Failed to load", color: Colors.red);
    }
     } catch (e) {
      print("Error fetching profile: $e");
      setState(() => loading = false);
      TopMessage.show(context, "Error: $e", color: Colors.red);
    }
  }

  // ---------------- IMAGE PICK (NO UI CHANGE) ----------------
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  List<String> parseList(dynamic data) {
  if (data == null) return [];

  if (data is List) {
    return data.map((e) => e.toString()).toList();
  }

  return data.toString().split(",").map((e) => e.trim()).toList();
}

  // ---------------- SAVE PERSONAL ONLY ----------------
  Future<void> savePersonal() async {
    FormData formData = FormData.fromMap({
      if (imageFile != null)
        "profilePhoto": await MultipartFile.fromFile(
          imageFile!.path,
          filename: imageFile!.path.split('/').last,
        ),

      "personal[addressLine1]": addressLine1ctrl.text,
      "personal[city]": cityCtrl.text,
      "personal[state]": stateCtrl.text,

      "personal[pincode]": pinCtrl.text,

      "skills[primarySkills]": primarySkillCtrl.text
          .split(",")
          .map((e) => e.trim())
          .toList(),

      "skills[secondarySkills]": secondarySkillCtrl.text
          .split(",")
          .map((e) => e.trim())
          .toList(),

      "skills[certifications]": certificateCtrl.text
          .split(",")
          .map((e) => e.trim())
          .toList(),

      "skills[linkedinUrl]": linkedinCtrl.text,
    });

    final res = await ApiService.updateEmpProfile(
      id: profile["id"] ?? "",
      body: formData,
    );

    if (res["success"] == true) {
      editMode["personal"] = false;
      TopMessage.show(context, "Personal Updated", color: Colors.green);
      fetchProfile();
    } else {
      editMode["personal"] = false;
      fetchProfile();
     
    TopMessage.show(
      context,
      "Failed: ${res["message"] ?? res}",
      color: Colors.red,
    );
    }
  }

  // ---------------- CANCEL (RESTORE ORIGINAL) ----------------
  void cancelEdit(String section) {
    setState(() {
      profile = jsonDecode(jsonEncode(originalProfile));
      editMode[section] = false;
      imageFile = null;
      fetchProfile();
    });
  }

  // ---------------- FIELD (NO UI CHANGE) ----------------
  Widget field(
    String label,
    TextEditingController c,
    String section,
    IconData icon, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        enabled: editMode[section] ?? false,
        readOnly: readOnly,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ---------------- ACTION BAR (NO UI CHANGE) ----------------
  Widget action(String section, VoidCallback onSave) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (editMode[section] == true)
          TextButton(
            onPressed: () => cancelEdit(section),
            child: const Text("Cancel"),
          ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            if (editMode[section] == true) {
              onSave();
            } else {
              setState(() => editMode[section] = true);
            }
          },
          child: Text(editMode[section] == true ? "Save" : "Edit"),
        ),
      ],
    );
  }

  // ---------------- UI (YOUR SAME UI - NO CHANGE) ----------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profileImg = profile["profileLogo"] ?? profile["profilePhoto"] ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 25,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF9013FE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // ---------------- PROFILE IMAGE ----------------
                Stack(
                  children: [
                    GestureDetector(
                      onTap: editMode["personal"] == true ? pickImage : null,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white,

                          backgroundImage: imageFile != null
                              ? FileImage(imageFile!)
                              : (profileImg != null
                                        ? NetworkImage(profileImg)
                                        : null)
                                    as ImageProvider?,

                          child: imageFile == null && profileImg == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.blue,
                                )
                              : null,
                        ),
                      ),
                    ),

                    // ---------------- CAMERA BUTTON ----------------
                    if (editMode["personal"] == true)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 15),

                // ---------------- NAME ----------------
                Text(
                  profile["user"]?["name"] ?? "No Name",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 6),

                // ---------------- EMAIL ----------------
                Text(
                  emailCtrl.text,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 14),

                // ---------------- EMPLOYEE CODE BADGE ----------------
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.badge, color: Colors.white, size: 18),

                      const SizedBox(width: 8),

                      Text(
                        profile["employeeCode"] ?? "EMP-ID",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---------------- TABS (UNCHANGED) ----------------
          TabBar(
            controller: tabController,
            isScrollable: true,

            // ⭐ IMPORTANT: makes indicator match text width
            indicatorSize: TabBarIndicatorSize.tab,

            labelPadding: const EdgeInsets.symmetric(horizontal: 14),

            labelColor: Colors.white,
            unselectedLabelColor: Colors.black87,

            indicator: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 149, 176, 207), Color(0xFF9013FE)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),

            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),

            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),

            tabs: const [
              Tab(text: "Personal"),
              Tab(text: "Education"),
              Tab(text: "Experience"),

              Tab(text: "Bank"),
              Tab(text: "Nominee"),
            ],
          ),

          // ---------------- TAB VIEW ----------------
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // PERSONAL
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // ===== Personal Information =====
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(107, 26, 26, 31),
                              Color(0xFF7C3AED),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.person, color: Colors.white, size: 24),
                            SizedBox(width: 10),
                            Text(
                              "Personal Information",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      field(
                        "Email",
                        emailCtrl,
                        "personal",
                        Icons.email,
                        readOnly: true,
                      ),

                      field(
                        "Phone",
                        phoneCtrl,
                        "personal",
                        Icons.phone,
                        readOnly: true,
                      ),
                      field(
                        "Alt Phone",
                        altPhoneCtrl,
                        "personal",
                        Icons.phone_android,
                      ),
                      field(
                        "Address Line 1",
                        addressLine1ctrl,
                        "personal",
                        Icons.home,
                      ),
                      field("City", cityCtrl, "personal", Icons.location_city),
                      field("State", stateCtrl, "personal", Icons.map),
                      field("Country", countryCtrl, "personal", Icons.public),
                      field(
                        "Pincode",
                        pinCtrl,
                        "personal",
                        Icons.local_post_office,
                      ),

                      const SizedBox(height: 20),

                      // ===== Skills Information =====
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(85, 46, 46, 52),
                              Color(0xFF7C3AED),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.white, size: 24),
                            SizedBox(width: 10),
                            Text(
                              "Skills Information",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      field(
                        "Primary Skills",
                        primarySkillCtrl,
                        "personal",
                        Icons.star,
                      ),
                      field(
                        "Secondary Skills",
                        secondarySkillCtrl,
                        "personal",
                        Icons.star,
                      ),
                      field(
                        "Certifications",
                        certificateCtrl,
                        "personal",
                        Icons.star,
                      ),
                      field("LinkedIn", linkedinCtrl, "personal", Icons.link),

                      action("personal", savePersonal),
                    ],
                  ),
                ),

                // EDUCATION
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      action("education", () {}),
                      field("Degree", degreeCtrl, "education", Icons.school),
                      field("Spec", specCtrl, "education", Icons.subject),
                      field(
                        "College",
                        collegeCtrl,
                        "education",
                        Icons.account_balance,
                      ),
                      field("CGPA", cgpaCtrl, "education", Icons.grade),
                    ],
                  ),
                ),

                // EXPERIENCE
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      action("experience", () {}),
                      field(
                        "Company",
                        companyCtrl,
                        "experience",
                        Icons.business,
                      ),
                      field("Role", roleCtrl, "experience", Icons.work),
                      field("Tech", techCtrl, "experience", Icons.code),
                    ],
                  ),
                ),

                // // SKILLS
                // SingleChildScrollView(
                //   padding: const EdgeInsets.all(16),
                //   child: Column(
                //     children: [
                //       action("skills", () {}),
                //       field(
                //         "Primary Skills",
                //         primarySkillCtrl,
                //         "skills",
                //         Icons.star,
                //       ),
                //       field("LinkedIn", linkedinCtrl, "skills", Icons.link),
                //     ],
                //   ),
                // ),

                // BANK
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      action("bank", () {}),
                      field(
                        "Bank",
                        bankNameCtrl,
                        "bank",
                        Icons.account_balance,
                      ),
                      field("Account", accCtrl, "bank", Icons.credit_card),
                      field("IFSC", ifscCtrl, "bank", Icons.code),
                    ],
                  ),
                ),

                // NOMINEE
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      action("nominee", () {}),
                      field(
                        "Nominee",
                        nomineeNameCtrl,
                        "nominee",
                        Icons.person,
                      ),
                      field(
                        "Relation",
                        nomineeRelCtrl,
                        "nominee",
                        Icons.family_restroom,
                      ),
                      field(
                        "Aadhaar",
                        nomineeAadhaarCtrl,
                        "nominee",
                        Icons.badge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
