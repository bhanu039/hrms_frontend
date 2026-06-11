import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/employe/emp_full_reg/bloc/emp_full_event.dart';
import 'package:goexperts/employe/emp_full_reg/bloc/emp_full_state.dart';
import 'package:goexperts/employe/emp_full_reg/data/models/emp_fullreg.dart';
import 'package:goexperts/employe/emp_full_reg/data/repository_empFullreg.dart';

class EmpFullRegBloc extends Bloc<EmpFullRegEvent, EmpFullRegState> {
  final EmpFullRegRepository _repository = EmpFullRegRepository();

  EmpFullRegBloc() : super(EmpFullRegState(model: EmpFullRegModel())) {
    on<UpdateField>(_onUpdate);
    on<NextStep>(_onNext);
    on<PrevStep>(_onPrev);
    on<SubmitForm>(_onSubmit);
    on<ToggleSwitch>((event, emit) {
      emit(state.copyWith(isActive: event.value));
    });
  }

  void _onUpdate(UpdateField event, Emitter<EmpFullRegState> emit) {
    final m = state.model;

    final updated = m.copyWith(
      // ================= PERSONAL =================
      firstName: event.key == "firstName" ? event.value : m.firstName,
      middleName: event.key == "middleName" ? event.value : m.middleName,
      lastName: event.key == "lastName" ? event.value : m.lastName,
      gender: event.key == "gender" ? event.value : m.gender,
      dob: event.key == "dob" ? event.value : m.dob,
      maritalStatus: event.key == "maritalStatus"
          ? event.value
          : m.maritalStatus,
      bloodGroup: event.key == "bloodGroup" ? event.value : m.bloodGroup,
      nationality: event.key == "nationality" ? event.value : m.nationality,

      // ================= CONTACT =================
      personalEmail: event.key == "personalEmail"
          ? event.value
          : m.personalEmail,
      phone: event.key == "phone" ? event.value : m.phone,
      alternatePhone: event.key == "alternatePhone"
          ? event.value
          : m.alternatePhone,
      address: event.key == "address" ? event.value : m.address,
      city: event.key == "city" ? event.value : m.city,
      state: event.key == "state" ? event.value : m.state,
      country: event.key == "country" ? event.value : m.country,
      pincode: event.key == "pincode" ? event.value : m.pincode,

      // ================= EMERGENCY =================
      emergencyContactName: event.key == "emergencyContactName"
          ? event.value
          : m.emergencyContactName,
      emergencyRelation: event.key == "emergencyRelation"
          ? event.value
          : m.emergencyRelation,
      emergencyNumber: event.key == "emergencyNumber"
          ? event.value
          : m.emergencyNumber,

      // ================= EDUCATION =================
      degree: event.key == "degree" ? event.value : m.degree,
      specialization: event.key == "specialization"
          ? event.value
          : m.specialization,
      college: event.key == "college" ? event.value : m.college,
      university: event.key == "university" ? event.value : m.university,
      percentage: event.key == "percentage" ? event.value : m.percentage,
      startYear: event.key == "startYear" ? event.value : m.startYear,
      endYear: event.key == "endYear" ? event.value : m.endYear,

      // ================= EXPERIENCE =================
      companyName: event.key == "companyName" ? event.value : m.companyName,
      role: event.key == "role" ? event.value : m.role,
      experienceStartDate: event.key == "experienceStartDate"
          ? event.value
          : m.experienceStartDate,
      experienceEndDate: event.key == "experienceEndDate"
          ? event.value
          : m.experienceEndDate,
      technologies: event.key == "technologies"
          ? List<String>.from(event.value)
          : m.technologies,
      responsibilities: event.key == "responsibilities"
          ? event.value
          : m.responsibilities,

      // ================= SKILLS =================
      primarySkills: event.key == "primarySkills"
          ? List<String>.from(event.value)
          : m.primarySkills,

      secondarySkills: event.key == "secondarySkills"
          ? List<String>.from(event.value)
          : m.secondarySkills,

      certifications: event.key == "certifications"
          ? List<String>.from(event.value)
          : m.certifications,

      languagesKnown: event.key == "languagesKnown"
          ? List<String>.from(event.value)
          : m.languagesKnown,

      linkedinUrl: event.key == "linkedinUrl" ? event.value : m.linkedinUrl,
      githubUrl: event.key == "githubUrl" ? event.value : m.githubUrl,
      portfolioUrl: event.key == "portfolioUrl" ? event.value : m.portfolioUrl,

      // ================= BANK =================
      bankName: event.key == "bankName" ? event.value : m.bankName,
      accountHolderName: event.key == "accountHolderName"
          ? event.value
          : m.accountHolderName,
      accountNumber: event.key == "accountNumber"
          ? event.value
          : m.accountNumber,
      ifscCode: event.key == "ifscCode" ? event.value : m.ifscCode,
      branchName: event.key == "branchName" ? event.value : m.branchName,
      upiId: event.key == "upiId" ? event.value : m.upiId,

      // ================= NOMINEE =================
      nomineeName: event.key == "nomineeName" ? event.value : m.nomineeName,
      nomineeRelation: event.key == "nomineeRelation"
          ? event.value
          : m.nomineeRelation,
      nomineeDob: event.key == "nomineeDob" ? event.value : m.nomineeDob,
      nomineeGender: event.key == "nomineeGender"
          ? event.value
          : m.nomineeGender,
      nomineePhone: event.key == "nomineePhone" ? event.value : m.nomineePhone,
      nomineeEmail: event.key == "nomineeEmail" ? event.value : m.nomineeEmail,
      nomineeAadhaar: event.key == "nomineeAadhaar"
          ? event.value
          : m.nomineeAadhaar,
      nomineePan: event.key == "nomineePan" ? event.value : m.nomineePan,
      nomineePercentage: event.key == "nomineePercentage"
          ? int.tryParse(event.value.toString()) ?? m.nomineePercentage
          : m.nomineePercentage,
      nomineeAddress: event.key == "nomineeAddress"
          ? event.value
          : m.nomineeAddress,

      // ================= COMPLIANCE =================
      uanNumber: event.key == "uanNumber" ? event.value : m.uanNumber,
      pfNumber: event.key == "pfNumber" ? event.value : m.pfNumber,
      esiNumber: event.key == "esiNumber" ? event.value : m.esiNumber,

      isDeclaredTrue: event.key == "isDeclaredTrue"
          ? event.value
          : m.isDeclaredTrue,

      // ================= DOCUMENT FILES =================
      aadhaar: event.key == "aadhaar" ? event.value : m.aadhaar,
      pan: event.key == "pan" ? event.value : m.pan,
      bankPassbook: event.key == "bankPassbook" ? event.value : m.bankPassbook,
      educationProof: event.key == "educationProof"
          ? event.value
          : m.educationProof,
      relievingLetter: event.key == "relievingLetter"
          ? event.value
          : m.relievingLetter,
      payslips: event.key == "payslips" ? event.value : m.payslips,
      profilePhoto: event.key == "profilePhoto" ? event.value : m.profilePhoto,
      signature: event.key == "signature" ? event.value : m.signature,
      passport: event.key == "passport" ? event.value : m.passport,
      certificates: event.key == "certificates" ? event.value : m.certificates,
      other: event.key == "other" ? event.value : m.other,
    );

    emit(state.copyWith(model: updated));
  }

  void _onNext(NextStep event, Emitter<EmpFullRegState> emit) {
    emit(state.copyWith(currentStep: state.currentStep + 1));
  }

  void _onPrev(PrevStep event, Emitter<EmpFullRegState> emit) {
    emit(state.copyWith(currentStep: state.currentStep - 1));
  }

  void _onSubmit(SubmitForm event, Emitter<EmpFullRegState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final model = state.model;

      // ================= SUBMIT TO API =================
      final response = await _repository.submitOnboarding(model);

      // ================= SUCCESS RESPONSE =================
      emit(state.copyWith(isLoading: false, error: null));

      // You can handle response here (e.g., show success message, navigate)
      print("Onboarding submitted successfully: ${response.statusCode}");
    } catch (e) {
      // ================= ERROR HANDLING =================
      emit(state.copyWith(isLoading: false, error: e.toString()));
      print("Error submitting onboarding: $e");
    }
  }
}
