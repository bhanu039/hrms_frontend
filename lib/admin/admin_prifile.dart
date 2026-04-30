import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../state/bloc/auth/auth_bloc.dart';
import '../state/bloc/auth/profile_cubit.dart';
import '../widgets/Change_Password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> saveProfile() async {
    await context.read<ProfileCubit>().updateProfile(
          name: nameController.text,
          email: emailController.text,
          image: imageFile,
        );

    final state = context.read<ProfileCubit>().state;
    if (!mounted) return;

    if (state.status == ProfileStatus.success) {
      setState(() => isEditing = false);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message ?? 'Profile update failed')),
    );
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
      backgroundColor: const Color(0xfff4f6fb),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Icon(isEditing ? Icons.check : Icons.edit),
        label: Text(isEditing ? 'Save' : 'Edit'),
        onPressed: isLoading
            ? null
            : () {
                if (isEditing) {
                  saveProfile();
                } else {
                  setState(() => isEditing = true);
                }
              },
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xff4facfe), Color(0xff00f2fe)]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: isEditing ? pickImage : null,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              (imageFile != null && imageFile!.existsSync()) ? FileImage(imageFile!) : null,
                          child: (imageFile == null)
                              ? const Icon(Icons.person, size: 50, color: Colors.blue)
                              : null,
                        ),
                      ),
                      if (isEditing)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  isEditing
                      ? _editField(nameController)
                      : Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(height: 5),
                  isEditing
                      ? _editField(emailController)
                      : Text(email, style: const TextStyle(color: Colors.white70)),
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
                _action(Icons.settings, 'Settings', () {}),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _editField(TextEditingController controller) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  Widget _action(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        child: Icon(icon, color: Colors.blue),
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
    return const ListTile(
      leading: Icon(Icons.verified, color: Colors.blue),
      title: Text('Status'),
      subtitle: Text('Active Admin'),
    );
  }
}
