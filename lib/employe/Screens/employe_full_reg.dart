// // import 'dart:io';

// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:dio/dio.dart';
// // import 'package:goexperts/services/api_service.dart';
// // import 'package:goexperts/services/sessionservice.dart';
// // import 'package:image_picker/image_picker.dart';

// // class EmployeeOnboardingScreen extends StatefulWidget {
// //   const EmployeeOnboardingScreen({super.key});

// //   @override
// //   State<EmployeeOnboardingScreen> createState() =>
// //       _EmployeeOnboardingScreenState();
// // }

// // class _EmployeeOnboardingScreenState extends State<EmployeeOnboardingScreen> {
// //   static const int _lastStepIndex = 9;

// //   int currentStep = 0;
// //   bool isLoading = false;

// //   File? otherProof;

// //   // Controllers
// //   final firstNameController = TextEditingController();
// //   final middleNameController = TextEditingController();
// //   final lastNameController = TextEditingController();
// //   final dobController = TextEditingController();
// //   String? selectedGender;
// //   File? profilePicture;
// //   File? signature;
// //   File? aadhaarProof;
// //   File? panProof;

// //   final emailController = TextEditingController();
// //   final phoneController = TextEditingController();
// //   final alternatePhoneController = TextEditingController();
// //   final addressController = TextEditingController();
// //   final cityController = TextEditingController();
// //   final stateController = TextEditingController();
// //   final pincodeController = TextEditingController();

// //   // Emergency
// //   final emergencyNameController = TextEditingController();
// //   final emergencyRelationshipController = TextEditingController();
// //   final emergencyContactController = TextEditingController();

// //   // Education (simple single-entry fields)
// //   final degreeController = TextEditingController();
// //   final specializationController = TextEditingController();
// //   final collegeController = TextEditingController();
// //   final universityController = TextEditingController();
// //   final startYearController = TextEditingController();
// //   final endYearController = TextEditingController();
// //   final percentageController = TextEditingController();

// //   File? educationProof;

// //   // Experience
// //   bool hasExperience = false;
// //   final companyController = TextEditingController();
// //   final roleController = TextEditingController();
// //   final technologiesController = TextEditingController();
// //   final startDateController = TextEditingController();
// //   final endDateController = TextEditingController();
// //   final responsibilitiesController = TextEditingController();

// //   File? relievingLetter;

// //   // Bank
// //   final bankNameController = TextEditingController();
// //   final accountNumberController = TextEditingController();
// //   final ifscController = TextEditingController();
// //   final accountHolderNameController2 = TextEditingController();
// //   final branchController = TextEditingController();
// //   final upiIdController = TextEditingController();
// //   File? bankProof;

// //   final nomineeRelationshipController = TextEditingController();
// //   final nomineeNameController = TextEditingController();
// //   final nomineeContactController = TextEditingController();
// //   final nomineeDobController = TextEditingController();
// //   final nomineeEmailController = TextEditingController();
// //   String? selectedNomineeGender;
// //   final nomineeAdhaarController = TextEditingController();
// //   final nomineePanController = TextEditingController();
// //   final nomineeAddressController = TextEditingController();
// //   final nomineePercentageController = TextEditingController();

// //   // Skills
// //   final primarySkillsController = TextEditingController();
// //   final secondarySkillsController = TextEditingController();
// //   final certificationsController = TextEditingController();
// //   final languagesKnownController = TextEditingController();
// //   final linkedinUrlController = TextEditingController();
// //   final githubUrlController = TextEditingController();
// //   final portfolioUrlController = TextEditingController();
// //   File? certificates;

// //   bool haspf = false;
// //   final uanNumberController = TextEditingController();
// //   final pfNumberController = TextEditingController();
// //   final esiNumberController = TextEditingController();
// //   File? payslips;
// //   bool isDeclared = false;
// //   File? passport;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Employee Onboarding"),
// //         centerTitle: true,
// //       ),
// //       body: Stepper(
// //         type: StepperType.horizontal,
// //         currentStep: currentStep,
// //         onStepContinue: () {
// //           if (currentStep < _lastStepIndex) {
// //             setState(() => currentStep++);
// //           } else {
// //             _submitData();
// //           }
// //         },
// //         onStepCancel: () {
// //           if (currentStep > 0) {
// //             setState(() => currentStep--);
// //           }
// //         },
// //         controlsBuilder: (context, details) {
// //           return Padding(
// //             padding: const EdgeInsets.only(top: 20),
// //             child: Row(
// //               children: [
// //                 ElevatedButton(
// //                   onPressed: isLoading ? null : details.onStepContinue,
// //                   child: isLoading
// //                       ? const SizedBox(
// //                           width: 18,
// //                           height: 18,
// //                           child: CircularProgressIndicator(strokeWidth: 2),
// //                         )
// //                       : Text(currentStep == _lastStepIndex ? "Submit" : "Next"),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 if (currentStep > 0)
// //                   OutlinedButton(
// //                     onPressed: details.onStepCancel,
// //                     child: const Text("Back"),
// //                   ),
// //               ],
// //             ),
// //           );
// //         },
// //         steps: [
// //           Step(
// //             title: const Text("Personal"),
// //             isActive: currentStep >= 0,
// //             content: _personalSection(),
// //           ),
// //           Step(
// //             title: const Text("Contact"),
// //             isActive: currentStep >= 1,
// //             content: _contactSection(),
// //           ),
// //           Step(
// //             title: const Text("Emergency"),
// //             isActive: currentStep >= 2,
// //             content: _emergencySection(),
// //           ),
// //           Step(
// //             title: const Text("Education"),
// //             isActive: currentStep >= 3,
// //             content: _educationSection(),
// //           ),
// //           Step(
// //             title: const Text("Experience"),
// //             isActive: currentStep >= 4,
// //             content: _experienceSection(),
// //           ),
// //           Step(
// //             title: const Text("Skills"),
// //             isActive: currentStep >= 5,
// //             content: _skillsSection(),
// //           ),
// //           Step(
// //             title: const Text("Bank"),
// //             isActive: currentStep >= 6,
// //             content: _bankSection(),
// //           ),
// //           Step(
// //             title: const Text("Nominee"),
// //             isActive: currentStep >= 7,
// //             content: _nomineeSection(),
// //           ),
// //           Step(
// //             title: const Text("Compliance"),
// //             isActive: currentStep >= 8,
// //             content: _complianceSection(),
// //           ),
// //           Step(
// //             title: const Text("Other Docs"),
// //             isActive: currentStep >= 9,
// //             content: _documentSection(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     firstNameController.dispose();
// //     middleNameController.dispose();
// //     lastNameController.dispose();
// //     dobController.dispose();
// //     emailController.dispose();
// //     phoneController.dispose();
// //     alternatePhoneController.dispose();
// //     addressController.dispose();
// //     cityController.dispose();
// //     stateController.dispose();
// //     pincodeController.dispose();
// //     emergencyNameController.dispose();
// //     emergencyRelationshipController.dispose();
// //     emergencyContactController.dispose();
// //     degreeController.dispose();
// //     specializationController.dispose();
// //     collegeController.dispose();
// //     universityController.dispose();
// //     startYearController.dispose();
// //     endYearController.dispose();
// //     percentageController.dispose();
// //     companyController.dispose();
// //     roleController.dispose();
// //     technologiesController.dispose();
// //     startDateController.dispose();
// //     endDateController.dispose();
// //     responsibilitiesController.dispose();
// //     bankNameController.dispose();
// //     accountNumberController.dispose();
// //     ifscController.dispose();
// //     accountHolderNameController2.dispose();
// //     branchController.dispose();
// //     upiIdController.dispose();
// //     nomineeRelationshipController.dispose();
// //     nomineeNameController.dispose();
// //     nomineeContactController.dispose();
// //     nomineeDobController.dispose();
// //     nomineeEmailController.dispose();
// //     nomineeAdhaarController.dispose();
// //     nomineePanController.dispose();
// //     nomineeAddressController.dispose();
// //     nomineePercentageController.dispose();
// //     primarySkillsController.dispose();
// //     secondarySkillsController.dispose();
// //     certificationsController.dispose();
// //     languagesKnownController.dispose();
// //     linkedinUrlController.dispose();
// //     githubUrlController.dispose();
// //     portfolioUrlController.dispose();
// //     uanNumberController.dispose();
// //     pfNumberController.dispose();
// //     esiNumberController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _submitData() async {
// //     final empid = await SessionService.getID();
// //     if (empid == null || empid.isEmpty) {
// //       if (!mounted) return;
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Employee id not found. Please login again.'),
// //         ),
// //       );
// //       return;
// //     }

// //     setState(() => isLoading = true);

// //     final documents = <String, dynamic>{
// //       if (profilePicture != null)
// //         "profilePicture": await _multipartFile(profilePicture!),
// //       if (signature != null) "signature": await _multipartFile(signature!),
// //       if (aadhaarProof != null) "aadhaar": await _multipartFile(aadhaarProof!),
// //       if (panProof != null) "pan": await _multipartFile(panProof!),
// //       if (bankProof != null) "bankPassbook": await _multipartFile(bankProof!),
// //       if (educationProof != null)
// //         "education_Proof": await _multipartFile(educationProof!),
// //       if (relievingLetter != null)
// //         "relieving_Letter": await _multipartFile(relievingLetter!),
// //       if (payslips != null) "payslips": await _multipartFile(payslips!),
// //       if (passport != null) "passport": await _multipartFile(passport!),
// //       if (certificates != null)
// //         "certificates": await _multipartFile(certificates!),
// //       if (otherProof != null) "other": await _multipartFile(otherProof!),
// //     };

// //     final formData = FormData.fromMap({
// //       'personal': {
// //         'firstName': firstNameController.text,
// //         'middleName': middleNameController.text,
// //         'lastName': lastNameController.text,
// //         'gender': selectedGender,
// //         'dob': dobController.text,
// //       },
// //       'contact': {
// //         'personalEmail': emailController.text,
// //         'phone': phoneController.text,
// //         'alternatePhone': alternatePhoneController.text,
// //         'address': addressController.text,
// //         'city': cityController.text,
// //         'state': stateController.text,
// //         'pincode': pincodeController.text,
// //       },
// //       'emergency': [
// //         {
// //           'contactPersonName': emergencyNameController.text,
// //           'relationship': emergencyRelationshipController.text,
// //           'contactNumber': emergencyContactController.text,
// //         },
// //       ],
// //       'education': [
// //         {
// //           'degree': degreeController.text,
// //           'specialization': specializationController.text,
// //           'college': collegeController.text,
// //           'university': universityController.text,
// //           'startYear': startYearController.text,
// //           'endYear': endYearController.text,
// //           'percentage': percentageController.text,
// //         },
// //       ],
// //       'experience': [
// //         {
// //           'companyName': companyController.text,
// //           'role': roleController.text,
// //           'technologies': technologiesController.text,
// //           'startDate': startDateController.text,
// //           'endDate': endDateController.text,
// //           'responsibilities': responsibilitiesController.text
            
// //         },
// //       ],
// //       'bank': {
// //         'bankName': bankNameController.text,
// //         'accountNumber': accountNumberController.text,
// //         'ifscCode': ifscController.text,
// //         "upiId": upiIdController.text,
// //         'accountHolderName': accountHolderNameController2.text,
// //         'branch': branchController.text,
// //       },
// //       'skills': {
// //         'primarySkills': primarySkillsController.text
// //             .split(',')
// //             .map((e) => e.trim())
// //             .toList(),
// //         'secondarySkills': secondarySkillsController.text
// //             .split(',')
// //             .map((e) => e.trim())
// //             .toList(),
// //         'certifications': certificationsController.text
// //             .split(',')
// //             .map((e) => e.trim())
// //             .toList(),
// //         'languagesKnown': languagesKnownController.text
// //             .split(',')
// //             .map((e) => e.trim())
// //             .toList(),
// //         'linkedinUrl': linkedinUrlController.text,
// //         'githubUrl': githubUrlController.text,
// //         'portfolioUrl': portfolioUrlController.text,
// //       },
// //       'nominee': {
// //         'nomineeName': nomineeNameController.text,
// //         'relationship': nomineeRelationshipController.text,
// //         'phone': nomineeContactController.text,
// //         'dob': nomineeDobController.text,
// //         'email': nomineeEmailController.text,
// //         'gender': selectedNomineeGender,
// //         'aadhaarNumber': nomineeAdhaarController.text,
// //         'panNumber': nomineePanController.text,
// //         'address': nomineeAddressController.text,
// //         'nomineePercentage': nomineePercentageController.text,
// //       },
// //       "compliance": {
// //         "hasPf": haspf,
// //         "uanNumber": uanNumberController.text,
// //         "pfNumber": pfNumberController.text,
// //         "esiNumber": esiNumberController.text,
// //       },
// //       "documents": documents,
// //     });

// //     try {
// //       final ApiService apiService = ApiService();
// //       final response = await apiService.fullRegisterEmployee(
// //         id: empid,
// //         body: formData,
// //       );
// //       if (response["statusCode"] == 200 || response["success"] == true) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('Submitted successfully')),
// //           );
// //         }
// //       } else {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text('Submission failed: ${response["statusCode"]}'),
// //             ),
// //           );
// //         }
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(
// //           context,
// //         ).showSnackBar(SnackBar(content: Text('Error: $e')));
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() => isLoading = false);
// //       }
// //     }
// //   }

// //   Future<MultipartFile> _multipartFile(File file) {
// //     return MultipartFile.fromFile(file.path, filename: _fileName(file));
// //   }

// //   String _fileName(File file) => file.path.split(Platform.pathSeparator).last;

// //   final ImagePicker picker = ImagePicker();
// //   Future<void> pickImage(int index) async {
// //     final XFile? image = await picker.pickImage(
// //       source: ImageSource.gallery,
// //       imageQuality: 80,
// //     );

// //     if (image != null) {
// //       setState(() {
// //         if (index == 1) {
// //           profilePicture = File(image.path);
// //         } else {
// //           signature = File(image.path);
// //         }
// //       });
// //     }
// //   }

// //   Widget _sectionCard({
// //     required String title,
// //     required IconData icon,
// //     required Widget child,
// //   }) {
// //     return Card(
// //       elevation: 3,
// //       margin: const EdgeInsets.symmetric(vertical: 10),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(icon),
// //                 const SizedBox(width: 10),
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const Divider(height: 25),
// //             child,
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _personalSection() {return _sectionCard(
// //   title: "Personal Information",
// //   icon: Icons.person,
// //   child: Form(
// //     child: Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [

// //         // ================= PROFILE IMAGE =================
// //         Center(
// //           child: Column(
// //             children: [
// //               GestureDetector(
// //                 onTap: () => pickImage(1),
// //                 child: CircleAvatar(
// //                   radius: 50,
// //                   backgroundImage:
// //                       profilePicture != null ? FileImage(profilePicture!) : null,
// //                   child: profilePicture == null
// //                       ? const Icon(Icons.person, size: 50)
// //                       : null,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               const Text("Upload Profile Picture *"),
// //             ],
// //           ),
// //         ),

// //         const SizedBox(height: 20),

// //         // ================= NAME ROW =================
// //         TextFormField(
// //           controller: firstNameController,
// //           decoration: const InputDecoration(
// //             labelText: "First Name *",
// //             prefixIcon: Icon(Icons.person_outline),
// //           ),
// //           validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
// //         ),

// //         const SizedBox(height: 12),

// //         TextFormField(
// //           controller: middleNameController,
// //           decoration: const InputDecoration(
// //             labelText: "Middle Name",
// //             prefixIcon: Icon(Icons.person),
// //           ),
// //         ),

// //         const SizedBox(height: 12),

// //         TextFormField(
// //           controller: lastNameController,
// //           decoration: const InputDecoration(
// //             labelText: "Last Name *",
// //             prefixIcon: Icon(Icons.person),
// //           ),
// //           validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
// //         ),

// //         const SizedBox(height: 12),

// //         // ================= GENDER =================
// //         DropdownButtonFormField<String>(
// //           value: selectedGender,
// //           items: const [
// //             DropdownMenuItem(value: "MALE", child: Text("Male")),
// //             DropdownMenuItem(value: "FEMALE", child: Text("Female")),
// //             DropdownMenuItem(value: "OTHER", child: Text("Other")),
// //           ],
// //           onChanged: (v) => setState(() => selectedGender = v),
// //           decoration: const InputDecoration(
// //             labelText: "Gender *",
// //             prefixIcon: Icon(Icons.wc),
// //           ),
// //         ),

// //         const SizedBox(height: 12),

// //         // ================= DOB =================
// //         TextFormField(
// //           controller: dobController,
// //           readOnly: true,
// //           decoration: const InputDecoration(
// //             labelText: "Date of Birth *",
// //             prefixIcon: Icon(Icons.cake),
// //           ),
// //           onTap: () async {
// //             final now = DateTime.now();
// //             final initial =
// //                 DateTime.tryParse(dobController.text) ?? DateTime(now.year - 25);

// //             final picked = await showDatePicker(
// //               context: context,
// //               initialDate: initial,
// //               firstDate: DateTime(1900),
// //               lastDate: now,
// //             );

// //             if (picked != null) {
// //               dobController.text = picked.toIso8601String().split('T').first;
// //             }
// //           },
// //         ),

// //         const SizedBox(height: 20),

// //         // ================= SIGNATURE IMAGE =================
// //         GestureDetector(
// //           onTap: () => pickImage(2),
// //           child: Container(
// //             height: 140,
// //             width: double.infinity,
// //             decoration: BoxDecoration(
// //               border: Border.all(color: Colors.grey.shade400),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: signature == null
// //                 ? const Center(child: Text("Upload Signature *"))
// //                 : Image.file(signature!, fit: BoxFit.cover),
// //           ),
// //         ),

// //         const SizedBox(height: 20),

// //         // ================= DOCUMENT UPLOADS =================
// //         buildUploadTile(
// //           "Aadhaar Card *",
// //           Icons.credit_card,
// //           () => pickFile("aadhaar"),
// //           aadhaarProof,
// //         ),

// //         const SizedBox(height: 12),

// //         buildUploadTile(
// //           "PAN Card *",
// //           Icons.badge,
// //           () => pickFile("pan"),
// //           panProof,
// //         ),

// //         const SizedBox(height: 12),

      

// //         const SizedBox(height: 12),

// //         buildUploadTile(
// //           "Bank Passbook",
// //           Icons.account_balance,
// //           () => pickFile("bank"),
// //           bankProof,
// //         ),

// //         const SizedBox(height: 20),

// //         // ================= CONTACT EXTRA (OPTIONAL GOOD HR FIELDS) =================
// //         TextFormField(
// //           controller: emailController,
// //           decoration: const InputDecoration(
// //             labelText: "Email *",
// //             prefixIcon: Icon(Icons.email),
// //           ),
// //         ),

// //         const SizedBox(height: 12),

// //         TextFormField(
// //           controller: phoneController,
// //           keyboardType: TextInputType.phone,
// //           decoration: const InputDecoration(
// //             labelText: "Phone Number *",
// //             prefixIcon: Icon(Icons.phone),
// //           ),
// //         ),

// //         const SizedBox(height: 12),

// //         TextFormField(
// //           controller: addressController,
// //           maxLines: 2,
// //           decoration: const InputDecoration(
// //             labelText: "Address *",
// //             prefixIcon: Icon(Icons.location_on),
// //           ),
// //         ),

// //         const SizedBox(height: 20),
// //       ],
// //     ),
// //   ),
// // );}

// //   Widget _contactSection() {
// //     return _sectionCard(
// //       title: "Contact Information",
// //       icon: Icons.phone,
// //       child: Form(
// //         child: Column(
// //           children: [
// //             TextFormField(
// //               controller: emailController,
// //               decoration: const InputDecoration(
// //                 labelText: "Email",
// //                 prefixIcon: Icon(Icons.email),
// //                 hintText: 'name@example.com',
// //               ),
// //               validator: (v) {
// //                 if (v == null || v.isEmpty) return 'Required';
// //                 if (!v.contains('@')) return 'Invalid email';
// //                 return null;
// //               },
// //             ),
// //             const SizedBox(height: 12),
// //             TextFormField(
// //               controller: phoneController,
// //               decoration: const InputDecoration(
// //                 labelText: "Phone Number",
// //                 prefixIcon: Icon(Icons.phone),
// //                 hintText: '10-digit number',
// //               ),
// //               keyboardType: TextInputType.phone,
// //             ),
// //             const SizedBox(height: 12),
// //             TextFormField(
// //               controller: alternatePhoneController,
// //               decoration: const InputDecoration(
// //                 labelText: "Alternate Phone",
// //                 prefixIcon: Icon(Icons.phone_android),
// //               ),
// //               keyboardType: TextInputType.phone,
// //             ),
// //             const SizedBox(height: 12),
// //             TextFormField(
// //               controller: addressController,
// //               maxLines: 3,
// //               decoration: const InputDecoration(
// //                 labelText: "Address",
// //                 prefixIcon: Icon(Icons.home),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             TextFormField(
// //               controller: cityController,
// //               decoration: const InputDecoration(
// //                 labelText: "City",
// //                 prefixIcon: Icon(Icons.location_city),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             TextFormField(
// //               controller: stateController,
// //               decoration: const InputDecoration(
// //                 labelText: "State",
// //                 prefixIcon: Icon(Icons.map),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             TextFormField(
// //               controller: pincodeController,
// //               decoration: const InputDecoration(
// //                 labelText: "Pincode",
// //                 prefixIcon: Icon(Icons.pin_drop),
// //               ),
// //               keyboardType: TextInputType.number,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _emergencySection() {
// //     return _sectionCard(
// //       title: "Emergency Contact",
// //       icon: Icons.emergency,
// //       child: Column(
// //         children: [
// //           TextFormField(
// //             controller: emergencyNameController,
// //             decoration: const InputDecoration(labelText: "Contact Person Name"),
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: emergencyRelationshipController,
// //             decoration: const InputDecoration(labelText: "Relationship"),
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: emergencyContactController,
// //             decoration: const InputDecoration(labelText: "Contact Number"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _educationSection() {
// //     return _sectionCard(
// //       title: "Education",
// //       icon: Icons.school,
// //       child: Column(
// //         children: [
// //           TextFormField(
// //             controller: degreeController,
// //             decoration: const InputDecoration(labelText: "Degree"),
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: specializationController,
// //             decoration: const InputDecoration(labelText: "Specialization"),
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: collegeController,
// //             decoration: const InputDecoration(labelText: "College"),
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: universityController,
// //             decoration: const InputDecoration(labelText: "University"),
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: startYearController,
// //             decoration: const InputDecoration(labelText: "Start Year"),
// //             keyboardType: TextInputType.number,
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: endYearController,
// //             decoration: const InputDecoration(labelText: "End Year"),
// //             keyboardType: TextInputType.number,
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: percentageController,
// //             decoration: const InputDecoration(labelText: "Percentage / CGPA"),
//             keyboardType: TextInputType.number,
//           ),
//           const SizedBox(height: 15),
//           buildUploadTile(
//             "Education Proof",
//             Icons.account_circle,
//             () => pickFile("education"),
//             educationProof,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _experienceSection() {
//     return _sectionCard(
//       title: "Experience",
//       icon: Icons.work,
//       child: Column(
//         children: [
//           SwitchListTile(
//             title: const Text("Do you have prior work experience?"),
//             value: hasExperience,
//             onChanged: (v) => setState(() => hasExperience = v),
//           ),
//           hasExperience
//               ? Column(
//                   children: [
//                     TextFormField(
//                       controller: companyController,
//                       decoration: const InputDecoration(
//                         labelText: "Company Name",
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: roleController,
//                       decoration: const InputDecoration(labelText: "Role"),
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: technologiesController,
//                       decoration: const InputDecoration(
//                         labelText: "Technologies",
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: startDateController,
//                       readOnly: true,
//                       decoration: const InputDecoration(
//                         labelText: "Start Date",
//                         prefixIcon: Icon(Icons.date_range),
//                       ),
//                       onTap: () async {
//                         final now = DateTime.now();
//                         final initial =
//                             DateTime.tryParse(startDateController.text) ??
//                             DateTime(now.year - 4);
//                         final picked = await showDatePicker(
//                           context: context,
//                           initialDate: initial,
//                           firstDate: DateTime(1900),
//                           lastDate: now,
//                         );
//                         if (picked != null) {
//                           startDateController.text = picked
//                               .toIso8601String()
//                               .split('T')
//                               .first;
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: endDateController,
//                       readOnly: true,
//                       decoration: const InputDecoration(
//                         labelText: "End Date",
//                         prefixIcon: Icon(Icons.date_range),
//                       ),
//                       onTap: () async {
//                         final now = DateTime.now();
//                         final initial =
//                             DateTime.tryParse(endDateController.text) ??
//                             DateTime(now.year - 1);
//                         final picked = await showDatePicker(
//                           context: context,
//                           initialDate: initial,
//                           firstDate: DateTime(1900),
//                           lastDate: now,
//                         );
//                         if (picked != null) {
//                           endDateController.text = picked
//                               .toIso8601String()
//                               .split('T')
//                               .first;
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: responsibilitiesController,
//                       maxLines: 1,
//                       decoration: const InputDecoration(
//                         labelText: "Responsibilities",
//                         prefixIcon: Icon(Icons.list),
//                         hintText:
//                             'Enter your responsibilities (comma-separated)',
//                       ),
//                     ),
//                     buildUploadTile(
//                       "Relieving Letter",
//                       Icons.account_circle,
//                       () => pickFile("relieving"),
//                       relievingLetter,
//                     ),
//                   ],
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }

//   Widget _skillsSection() {
//     return _sectionCard(
//       title: "Skills & Certifications",
//       icon: Icons.psychology,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextFormField(
//               controller: primarySkillsController,
//               maxLines: 2,
//               decoration: const InputDecoration(
//                 labelText: "Primary Skills",
//                 prefixIcon: Icon(Icons.star),
//                 hintText: 'Enter comma-separated skills (e.g., Flutter, Dart)',
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: secondarySkillsController,
//               maxLines: 2,
//               decoration: const InputDecoration(
//                 labelText: "Secondary Skills",
//                 prefixIcon: Icon(Icons.grade),
//                 hintText: 'Enter comma-separated skills (e.g., Git, Node.js)',
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: certificationsController,
//               maxLines: 2,
//               decoration: const InputDecoration(
//                 labelText: "Certifications",
//                 prefixIcon: Icon(Icons.card_membership),
//                 hintText:
//                     'Enter comma-separated certifications (e.g., Google Cloud, AWS)',
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: languagesKnownController,
//               maxLines: 2,
//               decoration: const InputDecoration(
//                 labelText: "Languages Known",
//                 prefixIcon: Icon(Icons.language),
//                 hintText:
//                     'Enter comma-separated languages (e.g., English, Telugu)',
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: linkedinUrlController,
//               decoration: const InputDecoration(
//                 labelText: "LinkedIn URL",
//                 prefixIcon: Icon(Icons.link),
//                 hintText: 'https://linkedin.com/in/username',
//               ),
//               keyboardType: TextInputType.url,
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: githubUrlController,
//               decoration: const InputDecoration(
//                 labelText: "GitHub URL",
//                 prefixIcon: Icon(Icons.code),
//                 hintText: 'https://github.com/username',
//               ),
//               keyboardType: TextInputType.url,
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: portfolioUrlController,
//               decoration: const InputDecoration(
//                 labelText: "Portfolio URL",
//                 prefixIcon: Icon(Icons.web),
//                 hintText: 'https://portfolio.com',
//               ),
//               keyboardType: TextInputType.url,
//             ),
//             const SizedBox(height: 15),
//             buildUploadTile(
//               "Certificates",
//               Icons.card_membership,
//               () => pickFile("certificates"),
//               certificates,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _bankSection() {
//     return _sectionCard(
//       title: "Bank Details",
//       icon: Icons.account_balance,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: accountHolderNameController2,
//             decoration: const InputDecoration(labelText: "Account Holder Name"),
//           ),
//           TextFormField(
//             controller: bankNameController,
//             decoration: const InputDecoration(labelText: "Bank Name"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: accountNumberController,
//             decoration: const InputDecoration(labelText: "Account Number"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: ifscController,
//             decoration: const InputDecoration(labelText: "IFSC Code"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: branchController,
//             decoration: const InputDecoration(labelText: "Branch"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: upiIdController,
//             decoration: const InputDecoration(labelText: "UPI ID"),
//           ),

//           const SizedBox(height: 15),
//           buildUploadTile(
//             "Bank Passbook",
//             Icons.account_circle,
//             () => pickFile("bank"),
//             bankProof,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _nomineeSection() {
//     return _sectionCard(
//       title: "Nominee",
//       icon: Icons.family_restroom,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: nomineeNameController,
//             decoration: const InputDecoration(labelText: "Nominee Name"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: nomineeRelationshipController,
//             decoration: const InputDecoration(labelText: "Relationship"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: nomineeContactController,
//             decoration: const InputDecoration(labelText: "Contact Number"),
//             keyboardType: TextInputType.phone,
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: nomineeEmailController,
//             decoration: const InputDecoration(labelText: "Email"),
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: nomineeDobController,
//             readOnly: true,
//             decoration: const InputDecoration(labelText: "Date of Birth"),
//             onTap: () async {
//               final now = DateTime.now();
//               final initial =
//                   DateTime.tryParse(nomineeDobController.text) ??
//                   DateTime(now.year - 25);
//               final picked = await showDatePicker(
//                 context: context,
//                 initialDate: initial,
//                 firstDate: DateTime(1900),
//                 lastDate: now,
//               );
//               if (picked != null) {
//                 nomineeDobController.text = picked
//                     .toIso8601String()
//                     .split('T')
//                     .first;
//               }
//             },
//           ),
//           const SizedBox(height: 12),
//           DropdownButtonFormField<String>(
//             items: const [
//               DropdownMenuItem(value: "MALE", child: Text("Male")),
//               DropdownMenuItem(value: "FEMALE", child: Text("Female")),
//             ],
//             initialValue: selectedNomineeGender,
//             onChanged: (v) => setState(() => selectedNomineeGender = v),
//             decoration: const InputDecoration(
//               labelText: "Gender",
//               prefixIcon: Icon(Icons.wc),
//             ),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: nomineeAdhaarController,
//             decoration: const InputDecoration(labelText: "Aadhaar Number"),
//             keyboardType: TextInputType.number,
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: nomineePanController,
//             decoration: const InputDecoration(labelText: "PAN Number"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: nomineeAddressController,
//             maxLines: 3,
//             decoration: const InputDecoration(labelText: "Address"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: nomineePercentageController,
//             decoration: const InputDecoration(labelText: "Nominee Percentage"),
//             keyboardType: TextInputType.number,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _complianceSection() {
//     return _sectionCard(
//       title: "Compliance",

//       icon: Icons.verified_user,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: uanNumberController,
//             decoration: const InputDecoration(labelText: "UAN Number"),
//           ),
//           const SizedBox(height: 12),
//           SwitchListTile(
//             title: const Text("Do you have PF?"),
//             value: haspf,
//             onChanged: (v) => setState(() => haspf = v),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: pfNumberController,
//             decoration: const InputDecoration(labelText: "PF Number"),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: esiNumberController,
//             decoration: const InputDecoration(labelText: "ESI Number"),
//           ),
//           const SizedBox(height: 12),
//           buildUploadTile(
//             "Payslips",
//             Icons.account_circle,
//             () => pickFile("payslips"),
//             payslips,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _documentSection() {
//     return _sectionCard(
//       title: "Documents Upload",
//       icon: Icons.upload_file,
//       child: Column(
//         children: [
//           buildUploadTile(
//             "Passport",
//             Icons.badge,
//             () => pickFile("passport"),
//             passport,
//           ),
//           buildUploadTile(
//             "other Documents",
//             Icons.account_circle,
//             () => pickFile("other"),
//             otherProof,
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> pickFile(String type) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//     );

//     if (result != null) {
//       final file = File(result.files.single.path!);

//       setState(() {
//         if (type == "aadhaar") {
//           aadhaarProof = file;
//         }

//         if (type == "pan") {
//           panProof = file;
//         }

//         if (type == "bank") {
//           bankProof = file;
//         }

//         if (type == "education") {
//           educationProof = file;
//         }
//         if (type == "relieving") {
//           relievingLetter = file;
//         }
//         if (type == "payslips") {
//           payslips = file;
//         }
//         if (type == "other") {
//           otherProof = file;
//         }
//         if (type == "certificates") {
//           certificates = file;
//         }
//         if (type == "passport") {
//           passport = file;
//         }
//       });
//     }
//   }

//   Widget buildUploadTile(
//     String title,
//     IconData icon,
//     VoidCallback onTap,
//     File? file,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),

//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(18),
//       ),

//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.indigo.withValues(alpha: 0.1),

//           child: Icon(icon, color: Colors.indigo),
//         ),

//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

//         subtitle: file != null
//             ? Text(_fileName(file))
//             : const Text("No file selected"),

//         trailing: ElevatedButton(
//           onPressed: onTap,

//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.indigo,

//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),

//           child: Text(
//             file != null ? "Change" : "Upload",

//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
