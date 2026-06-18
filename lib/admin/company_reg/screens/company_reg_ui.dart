import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/admin/company_reg/bloc/company_reg_event.dart';
import 'package:goexperts/core/services/sessionservice.dart';
import 'package:goexperts/core/widgets/custom_text_field.dart';
import 'package:goexperts/core/widgets/top_message.dart';

import '../bloc/company_reg_bloc.dart';
import '../bloc/company_reg_state.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerEmailController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ownerNameController.dispose();
    ownerEmailController.dispose();
    locationController.dispose();
     _formKey.currentState?.reset();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(title: const Text("Add Company"), centerTitle: true),
      body: BlocConsumer<AddCompanyBloc, AddCompanyState>(
        listener: (context, state) {
          if (state.success == true) {
            TopMessage.show(
              context,
              "Company registered successfully!",
              color: Colors.green,
            );
           _formKey.currentState?.reset();
            nameController.clear();
            emailController.clear();
            ownerNameController.clear();
            ownerEmailController.clear();
            locationController.clear();
            

            context.read<AddCompanyBloc>().add(ResetCompanyForm());
         
            
          }else if(state.error != null && state.error!.isNotEmpty) {
            TopMessage.show(context, state.error!, color: Colors.red);
          }
        },
        builder: (context, state) {
          final bloc = context.read<AddCompanyBloc>();

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AddCompanyBloc>().add(LoadIndustries());
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Company Name
                    CustomTextField(
                      controller: nameController,
                      label: "Company Name",
                      prefixIcon: const Icon(Icons.business),
                      onChanged: (v) => bloc.add(NameChanged(v)),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Company name required";
                        }
                        return null;
                      },
                    ),

                    // Company Email
                    CustomTextField(
                      controller: emailController,
                      label: "Company Email",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email),
                      onChanged: (v) => bloc.add(EmailChanged(v)),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Email required";
                        }
                        if (!RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),

                    // Owner Name
                    CustomTextField(
                      controller: ownerNameController,
                      label: "Owner Name",
                      prefixIcon: const Icon(Icons.person),
                      onChanged: (v) => bloc.add(OwnerNameChanged(v)),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Owner name required";
                        }
                        return null;
                      },
                    ),

                    // Owner Email
                    CustomTextField(
                      controller: ownerEmailController,
                      label: "Owner Email",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.alternate_email),
                      onChanged: (v) => bloc.add(OwnerEmailChanged(v)),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Owner email required";
                        }
                        if (!RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),

                    // Location
                    CustomTextField(
                      controller: locationController,
                      label: "Location",
                      prefixIcon: const Icon(Icons.location_on),
                      onChanged: (v) => bloc.add(LocationChanged(v)),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Location required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Industry Dropdown
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
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Select industry";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.submitting
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  bloc.add(SubmitCompany());
                                } else {
                                  TopMessage.show(
                                    context,
                                    "Please fill all required fields",
                                    color: Colors.red,
                                  );
                                }
                              },
                        child: state.submitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Register Company"),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (state.error != null)
                      Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
