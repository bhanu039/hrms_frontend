import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../state/auth/auth_bloc.dart';
import '../../state/profile/profile_cubit.dart';
import '../../state/profile/profile_state.dart';
import '../../widgets/Change_Password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      image: imageFile,
    );

    if (!mounted) return;

    final state = context.read<ProfileCubit>().state;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(state.message ?? 'Profile updated')));
  }

  Uint8List? decodeBase64(String? data) {
    if (data == null || data.isEmpty) return null;
    try {
      return base64Decode(data);
    } catch (_) {
      return null;
    }
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

    final base64Image = decodeBase64(session?.profileLogo);

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.edit),
        label: const Text("Edit"),
        onPressed: () => showEditProfileDialog(),
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
                gradient: LinearGradient(
                  colors: [Color(0xff4facfe), Color(0xff00f2fe)],
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
                      backgroundColor: Colors.white,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : (base64Image != null
                                ? MemoryImage(base64Image)
                                : (session?.profileLogo != null &&
                                      session!.profileLogo!.startsWith('http'))
                                ? NetworkImage(session.profileLogo!)
                                : null),
                      child: (imageFile == null && base64Image == null)
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.blue,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(email, style: const TextStyle(color: Colors.white70)),
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

  // ✅ EDIT DIALOG (FIXED)
  void showEditProfileDialog() {
    showDialog(
      
      context: context,
     

      builder: (dialogContext) {
         final session = context.watch<AuthBloc>().state.session;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
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
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile!)
                            : (session?.profileLogo != null &&
                                  session!.profileLogo!.startsWith('http'))
                            ? NetworkImage(session.profileLogo!)
                            : null,
                        child:
                            imageFile == null &&
                                (session?.profileLogo == null ||
                                    session!.profileLogo!.isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.blue,
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
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
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
        backgroundColor: Colors.blue.withOpacity(0.1),
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
