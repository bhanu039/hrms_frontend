import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/state/auth/auth_bloc.dart';
import '../bloc/emp_profile_bloc.dart';
import '../bloc/emp_profile_event.dart';
import '../bloc/emp_profile_state.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class EmpProfileScreen extends StatefulWidget {
  const EmpProfileScreen({super.key});

  @override
  State<EmpProfileScreen> createState() => _EmpProfileScreenState();
}

class _EmpProfileScreenState extends State<EmpProfileScreen> {
  String? empId;

  @override
  void initState() {
     empId=context.read<AuthBloc>().state.session?.id;

    context.read<EmpProfileBloc>().add(LoadEmpProfile(employeeId:empId));
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmpProfileBloc, EmpProfileState>(
      listenWhen: (previous, current) =>
          previous.message != current.message ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        final text = state.successMessage.isNotEmpty
            ? state.successMessage
            : state.message;
        if (text.isEmpty) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_cleanError(text)),
            backgroundColor: state.successMessage.isNotEmpty
                ? AppColors.emeraldLight  : AppColors.redAccent,
          ),
        );
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.screenBg,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: AppColors.screenBg,
                foregroundColor: AppColors.textDark,
                title: const Text(
                  'My Profile',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                actions: [
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed: state.status == EmpProfileStatus.loading
                        ? null
                        : () => context.read<EmpProfileBloc>().add(
                            RefreshEmpProfile(employeeId: state.employeeId),
                          ),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(54),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 44,
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: AppColors.textDark,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: AppColors.white,
                        unselectedLabelColor: AppColors.textMuted,
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        tabs: const [
                          Tab(text: 'Personal'),
                          Tab(text: 'Education'),
                          Tab(text: 'Documents'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: _ProfileBody(state: state),
            ),
          ),
        );
      },
    );
  }
}

class EmpProfilePage extends StatelessWidget {
  const EmpProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeId = context.read<AuthBloc>().state.session?.id;

    return BlocProvider(
      create: (_) =>
          EmpProfileBloc()..add(LoadEmpProfile(employeeId: employeeId)),
      child: const EmpProfileScreen(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.state});

  final EmpProfileState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == EmpProfileStatus.loading && !state.hasBasic) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == EmpProfileStatus.failure && !state.hasBasic) {
      return _FailureView(message: state.message);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<EmpProfileBloc>().add(
          RefreshEmpProfile(employeeId: state.employeeId),
        );
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
        children: [
          _ProfileHeader(state: state),
          if (state.isLoadingDetails) const LinearProgressIndicator(),
          if (state.message.isNotEmpty)
            _InlineNotice(message: _cleanError(state.message)),
          const SizedBox(height: 14),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.68,
            child: TabBarView(
              children: [
                _PersonalTab(state: state),
                _EducationTab(state: state),
                _DocumentsTab(state: state),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showBasicEditSheet(BuildContext context, Map<String, dynamic> basic) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text('Edit Profile')),
      );
    },
  );
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.state});

  final EmpProfileState state;

  @override
  Widget build(BuildContext context) {
    final basic = state.basic;
    final name = _firstText(basic, [
      'name',
      'fullName',
      'employeeName',
      'firstName',
    ], fallback: 'Employee');
    final lastName = _text(basic['lastName']);
    final displayName = lastName.isEmpty ? name : '$name $lastName';

    final role = _firstText(basic, [
      'designation',
      'designationName',
      'jobTitle',
      'role',
      'department',
    ], fallback: 'Employee');
    final code = _firstText(basic, [
      'employeeCode',
      'code',
      'empCode',
      'id',
    ], fallback: state.employeeId);
    final email = _firstText(basic, ['email', 'workEmail', 'officialEmail']);
    final phone = _firstText(basic, ['phone', 'mobile', 'phoneNumber']);
    final photo = _firstText(basic, [
      'profilePhoto',
      'profileLogo',
      'avatar',
      'image',
    ]);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.blueTint,
                    backgroundImage: _networkImage(photo),
                    child: photo.isEmpty
                        ? Text(
                            displayName.isEmpty
                                ? 'E'
                                : displayName[0].toUpperCase(),
                            style:  TextStyle(
                              color: AppColors.info,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: _RoundIconButton(
                      tooltip: 'Edit profile',
                      icon: Icons.edit_outlined,

                      onTap: () => _showBasicEditSheet(context, state.basic),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit basic details',
                onPressed: state.updatingSection == 'basic'
                    ? null
                    : () => _showBasicEditSheet(context, state.basic),
                icon: state.updatingSection == 'basic'
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.manage_accounts_outlined),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(icon: Icons.badge_outlined, text: code),
              if (email.isNotEmpty)
                _InfoChip(icon: Icons.mail_outline_rounded, text: email),
              if (phone.isNotEmpty)
                _InfoChip(icon: Icons.call_outlined, text: phone),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonalTab extends StatelessWidget {
  const _PersonalTab({required this.state});

  final EmpProfileState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 2),
      children: [
        _InfoSection(
          title: 'Basic Info',
          icon: Icons.person_outline_rounded,
          data: state.basic,
          isUpdating: state.updatingSection == 'basic',
          onEdit: () => _showBasicEditSheet(context, state.basic),
          preferredKeys: const [
            'employeeCode',
            'name',
            'firstName',
            'lastName',
            'email',
            'department',
            'designation',
            'joiningDate',
            'employmentType',
            'workModel',
            'probationPeriod',
            'noticePeriod',
            'status',
          ],
        ),
        _InfoSection(
          title: 'Address & Emergency',
          icon: Icons.home_work_outlined,
          data: state.personal,
          isUpdating: state.updatingSection == 'personal',
          onEdit: () => _showEditSheet(
            context: context,
            title: 'Update Personal Details',
            section: 'personal',
            data: state.personal,
            fields: const [
              'phone',
              'alternatePhone',
              'addressLine1',
              'addressLine2',
              'city',
              'state',
              'country',
              'pincode',
              'emergencyContactName',
              'emergencyContact',
              'relationship',
            ],
          ),
          preferredKeys: const [
            'phone',
            'alternatePhone',
            'addressLine1',
            'addressLine2',
            'city',
            'state',
            'country',
            'pincode',
            'emergencyContactName',
            'emergencyContact',
            'relationship',
          ],
        ),
        _InfoSection(
          title: 'Financial Info',
          icon: Icons.account_balance_outlined,
          data: state.financial,
          isUpdating: state.updatingSection == 'financial',
          onEdit: () => _showEditSheet(
            context: context,
            title: 'Update Financial Info',
            section: 'financial',
            data: state.financial,
            fields: const [
              'bankName',
              'accountHolderName',
              'accountNumber',
              'ifscCode',
              'branchName',
              'upiId',
              'pfNumber',
              'uanNumber',
              'esiNumber',
            ],
          ),
          preferredKeys: const [
            'bankName',
            'accountHolderName',
            'accountNumber',
            'ifscCode',
            'branchName',
            'upiId',
            'pfNumber',
            'uanNumber',
            'esiNumber',
          ],
        ),
      ],
    );
  }
}

class _EducationTab extends StatelessWidget {
  const _EducationTab({required this.state});

  final EmpProfileState state;

  @override
  Widget build(BuildContext context) {
    final professional = state.professional;
    final education = _listFromAny(
      professional['education'] ?? professional['educations'],
    );
    final experience = _listFromAny(
      professional['experience'] ?? professional['experiences'],
    );
    final skills = _asMap(professional['skills']).isNotEmpty
        ? _asMap(professional['skills'])
        : professional;

    return ListView(
      padding: const EdgeInsets.only(top: 2),
      children: [
        _ListSection(
          title: 'Education Details',
          icon: Icons.school_outlined,
          items: education,
          isUpdating: state.updatingSection == 'professional',
          onEdit: () => _showEditSheet(
            context: context,
            title: 'Update Education Details',
            section: 'professional',
            data: education.isNotEmpty ? education.first : state.professional,
            payloadWrapper: 'education',
            fields: const [
              'degree',
              'specialization',
              'college',
              'university',
              'cgpa',
              'percentage',
              'passingYear',
            ],
          ),
          emptyMessage: 'No education details found',
        ),
        _InfoSection(
          title: 'Skills',
          icon: Icons.auto_awesome_outlined,
          data: skills,
          isUpdating: state.updatingSection == 'professional',
          onEdit: () => _showEditSheet(
            context: context,
            title: 'Update Skills',
            section: 'professional',
            data: skills,
            payloadWrapper: 'skills',
            fields: const [
              'primarySkills',
              'secondarySkills',
              'certifications',
              'linkedinUrl',
              'portfolioUrl',
            ],
          ),
          preferredKeys: const [
            'primarySkills',
            'secondarySkills',
            'certifications',
            'linkedinUrl',
            'portfolioUrl',
          ],
        ),
        _ListSection(
          title: 'Experience',
          icon: Icons.work_outline_rounded,
          items: experience,
          isUpdating: state.updatingSection == 'professional',
          onEdit: () => _showEditSheet(
            context: context,
            title: 'Update Experience',
            section: 'professional',
            data: experience.isNotEmpty ? experience.first : state.professional,
            payloadWrapper: 'experience',
            fields: const [
              'companyName',
              'role',
              'designation',
              'startDate',
              'endDate',
              'technologies',
            ],
          ),
          emptyMessage: 'No experience details found',
        ),
      ],
    );
  }
}

class _DocumentsTab extends StatelessWidget {
  const _DocumentsTab({required this.state});

  final EmpProfileState state;

  @override
  Widget build(BuildContext context) {
    final documents = state.documents;
    final isUploading = state.updatingSection == 'documents';

    if (documents.isEmpty) {
      return _EmptySection(
        icon: Icons.description_outlined,
        message: 'No documents found',
        action: FilledButton.icon(
          onPressed: isUploading ? null : () => _pickAndUploadDocument(context),
          icon: isUploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload_file_rounded),
          label: const Text('Upload'),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isUploading
                  ? null
                  : () => _pickAndUploadDocument(context),
              icon: isUploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file_rounded),
              label: Text(isUploading ? 'Uploading...' : 'Upload Document'),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 2),
            itemCount: documents.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final document = documents[index];
              final title = _firstText(document, [
                'documentType',
                'type',
                'name',
                'fileName',
                'title',
              ], fallback: 'Document ${index + 1}');
              final url = _firstText(document, [
                'url',
                'fileUrl',
                'path',
                'document',
              ]);
              final status = _firstText(document, [
                'status',
                'verificationStatus',
              ]);

              return Container(
                padding:  EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.successTint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:  Icon(
                        Icons.description_outlined,
                        color: AppColors.emeraldLight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            status.isEmpty ? 'Uploaded document' : status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Open',
                      onPressed: url.isEmpty ? null : () => _openUrl(url),
                      icon: const Icon(Icons.open_in_new_rounded),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EditSheet extends StatefulWidget {
  const _EditSheet({
    required this.title,
    required this.section,
    required this.data,
    required this.fields,
    this.payloadWrapper,
  });

  final String title;
  final String section;
  final Map<String, dynamic> data;
  final List<String> fields;
  final String? payloadWrapper;

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final field in widget.fields)
        field: TextEditingController(text: _valueForKey(widget.data, field)),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmpProfileBloc, EmpProfileState>(
      builder: (context, state) {
        final isSaving = state.updatingSection == widget.section;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: isSaving
                            ? null
                            : () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...widget.fields.map(
                    (field) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: _controllers[field],
                        enabled: !isSaving,
                        minLines: field.toLowerCase().contains('address')
                            ? 2
                            : 1,
                        maxLines: field.toLowerCase().contains('address')
                            ? 3
                            : 1,
                        decoration: InputDecoration(
                          labelText: _prettyLabel(field),
                          filled: true,
                          fillColor: AppColors.lightBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:  BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:  BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isSaving ? null : _save,
                      icon: isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(isSaving ? 'Saving...' : 'Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _save() {
    final values = {
      for (final entry in _controllers.entries)
        entry.key: entry.value.text.trim(),
    }..removeWhere((_, value) => value.isEmpty);

    final payload = widget.payloadWrapper == null
        ? values
        : {widget.payloadWrapper!: values};

    context.read<EmpProfileBloc>().add(
      UpdateEmpProfileSection(section: widget.section, values: payload),
    );
    Navigator.pop(context);
  }
}

class _BasicEditSheet extends StatefulWidget {
  const _BasicEditSheet({required this.data});

  final Map<String, dynamic> data;

  @override
  State<_BasicEditSheet> createState() => _BasicEditSheetState();
}

class _BasicEditSheetState extends State<_BasicEditSheet> {
  static const _fields = [
    'firstName',
    'lastName',
    'employmentType',
    'workModel',
    'probationPeriod',
    'noticePeriod',
  ];

  late final Map<String, TextEditingController> _controllers;
  File? _photoFile;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final field in _fields)
        field: TextEditingController(text: _valueForKey(widget.data, field)),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmpProfileBloc, EmpProfileState>(
      builder: (context, state) {
        final isSaving = state.updatingSection == 'basic';
        final currentPhoto = _firstText(widget.data, [
          'profilePhoto',
          'profileLogo',
          'avatar',
          'image',
        ]);

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Update Basic Info',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: isSaving
                            ? null
                            : () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: AppColors.blueTint,
                          backgroundImage: _photoFile != null
                              ? FileImage(_photoFile!)
                              : _networkImage(currentPhoto),
                          child: _photoFile == null && currentPhoto.isEmpty
                              ?  Icon(
                                  Icons.person_outline_rounded,
                                  size: 42,
                                  color: AppColors.info,
                                )
                              : null,
                        ),
                        Positioned(
                          right: -6,
                          bottom: -6,
                          child: _RoundIconButton(
                            tooltip: 'Change photo',
                            icon: Icons.photo_camera_outlined,
                            onTap: isSaving ? null : _pickProfilePhoto,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ..._fields.map(
                    (field) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: _controllers[field],
                        enabled: !isSaving,
                        decoration: InputDecoration(
                          labelText: _prettyLabel(field),
                          filled: true,
                          fillColor: AppColors.lightBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isSaving ? null : _save,
                      icon: isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(isSaving ? 'Saving...' : 'Save Basic Info'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickProfilePhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png'],
    );

    final path = result?.files.single.path;
    if (path == null) return;

    setState(() {
      _photoFile = File(path);
    });
  }

  void _save() {
    final values = {
      for (final entry in _controllers.entries)
        entry.key: entry.value.text.trim(),
      if (_photoFile != null) 'profilePhoto': _photoFile!,
    }..removeWhere((_, value) => value is String && value.isEmpty);

    context.read<EmpProfileBloc>().add(
      UpdateEmpProfileSection(section: 'basic', values: values),
    );
    Navigator.pop(context);
  }
}

class _RoundIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundIconButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: AppColors.white, size: 18),
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.data,
    required this.preferredKeys,
    this.onEdit,
    this.isUpdating = false,
  });

  final String title;
  final IconData icon;
  final Map<String, dynamic> data;
  final List<String> preferredKeys;
  final VoidCallback? onEdit;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final rows = _rowsFor(data, preferredKeys);

    return _SectionFrame(
      title: title,
      icon: icon,
      onEdit: onEdit,
      isUpdating: isUpdating,
      child: rows.isEmpty
          ? const _MiniEmpty(message: 'No details found')
          : Column(
              children: rows
                  .map((row) => _InfoRow(label: row.key, value: row.value))
                  .toList(),
            ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.emptyMessage,
    this.onEdit,
    this.isUpdating = false,
  });

  final String title;
  final IconData icon;
  final List<Map<String, dynamic>> items;
  final String emptyMessage;
  final VoidCallback? onEdit;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: title,
      icon: icon,
      onEdit: onEdit,
      isUpdating: isUpdating,
      child: items.isEmpty
          ? _MiniEmpty(message: emptyMessage)
          : Column(
              children: items
                  .map(
                    (item) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Column(
                        children:
                            _rowsFor(item, const [
                                  'degree',
                                  'specialization',
                                  'college',
                                  'university',
                                  'cgpa',
                                  'percentage',
                                  'passingYear',
                                  'companyName',
                                  'role',
                                  'designation',
                                  'startDate',
                                  'endDate',
                                  'technologies',
                                ])
                                .map(
                                  (row) => _InfoRow(
                                    label: row.key,
                                    value: row.value,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _SectionFrame extends StatelessWidget {
  const _SectionFrame({
    required this.title,
    required this.icon,
    required this.child,
    this.onEdit,
    this.isUpdating = false,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onEdit;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style:  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (onEdit != null)
                IconButton(
                  tooltip: 'Edit',
                  onPressed: isUpdating ? null : onEdit,
                  icon: isUpdating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.edit_outlined, size: 20),
                ),
            ],
          ),
          const Divider(height: 22),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(
              _prettyLabel(label),
              style:  TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:  TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.slate700),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style:  TextStyle(
                color: AppColors.slate700,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warningTint,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warningColor),
      ),
      child: Row(
        children: [
           Icon(Icons.info_outline_rounded, color: AppColors.amberDark),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style:  TextStyle(
                color: AppColors.amberDarker,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Icon(
              Icons.cloud_off_outlined,
              size: 44,
              color: AppColors.redAccent,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              _cleanError(message),
              textAlign: TextAlign.center,
              style:  TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () =>
                  context.read<EmpProfileBloc>().add(const LoadEmpProfile()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.icon, required this.message, this.action});

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: AppColors.emeraldLight),
          const SizedBox(height: 10),
          Text(
            message,
            style:  TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 14), action!],
        ],
      ),
    );
  }
}

class _MiniEmpty extends StatelessWidget {
  const _MiniEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style:  TextStyle(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

NetworkImage? _networkImage(String value) {
  final uri = Uri.tryParse(value);
  if (uri == null || !uri.hasScheme) return null;
  return NetworkImage(value);
}

Future<void> _openUrl(String value) async {
  final uri = Uri.tryParse(value);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

void _showEditSheet({
  required BuildContext context,
  required String title,
  required String section,
  required Map<String, dynamic> data,
  required List<String> fields,
  String? payloadWrapper,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<EmpProfileBloc>(),
      child: _EditSheet(
        title: title,
        section: section,
        data: data,
        fields: fields,
        payloadWrapper: payloadWrapper,
      ),
    ),
  );
}

Future<void> _pickAndUploadDocument(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
  );

  if (result == null || result.files.single.path == null) return;
  if (!context.mounted) return;

  final documentType = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      final controller = TextEditingController();
      return AlertDialog(
        title: const Text('Document Type'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Example: Aadhaar, PAN, Resume',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              controller.text.trim().isEmpty
                  ? 'Document'
                  : controller.text.trim(),
            ),
            child: const Text('Upload'),
          ),
        ],
      );
    },
  );

  if (documentType == null || !context.mounted) return;

  context.read<EmpProfileBloc>().add(
    UploadEmpProfileDocument(
      documentType: documentType,
      file: File(result.files.single.path!),
    ),
  );
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

List<Map<String, dynamic>> _listFromAny(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
  if (value is Map) return [Map<String, dynamic>.from(value)];
  return [];
}

List<MapEntry<String, String>> _rowsFor(
  Map<String, dynamic> data,
  List<String> preferredKeys,
) {
  final rows = <MapEntry<String, String>>[];
  final used = <String>{};

  for (final key in preferredKeys) {
    final value = _valueForKey(data, key);
    if (value.isNotEmpty) {
      rows.add(MapEntry(key, value));
      used.add(key.toLowerCase());
    }
  }

  for (final entry in data.entries) {
    if (used.contains(entry.key.toLowerCase())) continue;
    if (entry.value is Map || entry.value is List<Map>) continue;
    final value = _text(entry.value);
    if (value.isNotEmpty) rows.add(MapEntry(entry.key, value));
  }

  return rows.take(12).toList();
}

String _firstText(
  Map<String, dynamic> data,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = _valueForKey(data, key);
    if (value.isNotEmpty) return value;
  }
  return fallback;
}

String _valueForKey(Map<String, dynamic> data, String key) {
  for (final entry in data.entries) {
    if (entry.key.toLowerCase() == key.toLowerCase()) {
      return _text(entry.value);
    }
  }

  for (final entry in data.entries) {
    final nested = _asMap(entry.value);
    if (nested.isEmpty) continue;
    final value = _valueForKey(nested, key);
    if (value.isNotEmpty) return value;
  }

  return '';
}

String _text(dynamic value) {
  if (value == null) return '';
  if (value is DateTime) return value.toIso8601String().split('T').first;
  if (value is List) {
    return value.map(_text).where((item) => item.trim().isNotEmpty).join(', ');
  }
  if (value is Map) return '';
  final text = value.toString().trim();
  if (text == 'null' || text == '[]') return '';
  if (RegExp(r'^\d{4}-\d{2}-\d{2}T').hasMatch(text)) {
    return text.split('T').first;
  }
  return text;
}

String _prettyLabel(String value) {
  final spaced = value
      .replaceAll('_', ' ')
      .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)}',
      )
      .trim();
  if (spaced.isEmpty) return value;
  return spaced[0].toUpperCase() + spaced.substring(1);
}

String _cleanError(String value) {
  return value
      .replaceFirst('Exception: ', '')
      .replaceFirst('DioException ', '');
}



