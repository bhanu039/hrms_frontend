import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/state/auth/auth_bloc.dart';
import '../../../core/state/auth/auth_event.dart';
import '../../../core/widgets/Change_Password.dart';
import '../admin_profile/profile_cubit.dart';
import '../admin_profile/profile_state.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool initialized = false;

  late final TextEditingController nameController;
  late final TextEditingController emailController;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> pickImage(StateSetter setStateDialog) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setStateDialog(() {
        imageFile = File(pickedFile.path);
      });
      setState(() {});
    }
  }

  Future<void> saveProfile() async {
    await context.read<ProfileCubit>().updateProfile(
      name: nameController.text,
      email: emailController.text,
      image: imageFile!,
    );

    if (!mounted) return;

    final state = context.read<ProfileCubit>().state;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(state.message ?? 'Profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthBloc>().state.session;
    final profileState = context.watch<ProfileCubit>().state;

    final isLoading = profileState.status == ProfileStatus.loading;

    final name = session?.name ?? 'Admin';
    final email = session?.email ?? 'admin@email.com';

    if (!initialized) {
      nameController.text = name;
      emailController.text = email;
      initialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.edit),
        label: const Text("Edit"),
        onPressed: () => showEditProfileDialog(),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        title: const Text('Profile', style: TextStyle(color: AppColors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.errorColor),
            onPressed: () async {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              await Future.delayed(const Duration(milliseconds: 100));

              context.go("/login");
            },
          ),
          SizedBox(width: 12),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: showEditProfileDialog,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.white38,
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile!)
                            : null,
                        child: imageFile == null
                            ? const Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.white,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      email,
                      style: TextStyle(
                        color: AppColors.textSecondaryColor.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _card(
                children: [
                  _tile(Icons.person, 'Name', name),
                  _tile(Icons.email, 'Email', email),
                  const _StatusTile(),
                ],
              ),

              const SizedBox(height: 15),

              _card(
                children: [
                  _action(Icons.lock, 'Change Password', () {
                    showChangePasswordDialog(context);
                  }),
                  _action(Icons.settings, 'Settings', () {
                    TopMessage.show(
                      context,
                      "Settings Coming Soon",
                      color: AppColors.info,
                    );
                  }),
                ],
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // ? EDIT DIALOG (FIXED)
  void showEditProfileDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            var profileImage;
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => pickImage(setStateDialog),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.blue.shade100,
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile!)
                            : (profileImage != null &&
                                  profileImage!.startsWith('http'))
                            ? NetworkImage(profileImage!)
                            : null,
                        child:
                            imageFile == null &&
                                (profileImage == null || profileImage!.isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.blue,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.grey,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.successColor,
                              foregroundColor: AppColors.white,
                            ),

                            onPressed: () async {
                              await saveProfile();
                              Navigator.pop(context);
                            },
                            child: const Text("Save"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _card({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.blue),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  Widget _action(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.blue.withOpacity(0.1),
        child: Icon(icon, color: AppColors.blue),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.verified, color: AppColors.blue),
      title: Text('Status'),
      subtitle: Text('Active Admin'),
    );
  }
}
