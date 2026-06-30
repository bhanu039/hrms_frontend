import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/app_constants/app_constants.dart';
import '../../../../core/state/auth/auth_bloc.dart';
import '../../../../core/state/auth/auth_event.dart';
import '../bloc/company_profile_bloc.dart';
import '../data/company_profile_modal.dart';
import '../widgets/company_documents_widget.dart';
import '../widgets/company_edit_widget.dart';
import '../widgets/company_header_widget.dart';
import '../widgets/company_overview_widget.dart';
import '../widgets/company_subscription_widget.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyProfileScreen extends StatefulWidget {
  final bool? isEditable;

  const CompanyProfileScreen({Key? key, this.isEditable = true})
    : super(key: key);

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditMode = false;
  final ImagePicker _imagePicker = ImagePicker();
  final FilePicker _filePicker = FilePicker.platform;

  late CompanyProfileData _editingProfile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchProfile();
  }

  void _fetchProfile() {
    context.read<CompanyProfileBloc>().add(const FetchCompanyProfileEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode && _editingProfile != null) {
        // Reset to original when canceling
        _editingProfile =
            (context.read<CompanyProfileBloc>().state as CompanyProfileLoaded)
                .profile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyProfileBloc, CompanyProfileState>(
      listener: (context, state) {
        if (state is CompanyProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is CompanyProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _toggleEditMode();
        } else if (state is CompanyDocumentUploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<CompanyProfileBloc, CompanyProfileState>(
        builder: (context, state) {
          if (state is CompanyProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is CompanyProfileError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Company Profile', style: TextStyle(color: AppConstants.primaryColor))),
              body: Center(
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _fetchProfile,
                          child: const Text('Retry'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: Colors
                                .white, // Ensures text visibility on a red background
                          ),
                          onPressed: () async {
                            context.read<AuthBloc>().add(AuthLogoutRequested());

                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );

                            context.go("/login");
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CompanyProfileLoaded) {
            _editingProfile = state.profile;

            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: AppConstants.backgroundColor,
                title: const Text(
                  'Company Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
                
                centerTitle: false,
                actions: [
                  if (widget.isEditable == true)
                   
                    Padding(padding: const EdgeInsets.only(right: 16.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            context.read<AuthBloc>().add(AuthLogoutRequested());

                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );

                            context.go("/login");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),),
                ],
              ),
           floatingActionButton: FloatingActionButton(
  backgroundColor: AppColors.brandBlue,
  onPressed: () {
    if (widget.isEditable == true) {
      _toggleEditMode();
    } else {
      TopMessage.show(
        context,
        "You don't have permission to edit.",
        color: AppColors.red,
      );
    }
  },
  child: Icon( Icons.edit,  ),
),
              body: _isEditMode
                  ? CompanyEditWidget(
                      profile: _editingProfile,
                      onSave: _handleSaveProfile,
                      onLogoSelected: _handleLogoSelected,
                      industryTypes: state.industryTypes,
                    )
                  : _buildViewMode(state),
            );
          }

          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shrinks layout box vertically to wrap tightly
                const Text(
                  'No profile data',
                  style: TextStyle(color: AppConstants.textColor, fontSize: 16),
                ),
                const SizedBox(
                  height: 16,
                ), // Gives balanced space between text and button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppConstants.primaryColor, // Vibrant Red brand code
                    foregroundColor:
                        AppConstants.backgroundColor, // White text/icon color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    context.read<AuthBloc>().add(AuthLogoutRequested());

                    await Future.delayed(const Duration(milliseconds: 100));

                    context.go("/login");
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildViewMode(CompanyProfileLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CompanyHeaderWidget(profile: state.profile),
          Material(
            color: AppConstants.backgroundColor, // Set background color here
            child: TabBar(
              controller: _tabController,

              indicatorColor: AppColors.brandBlue,
              labelColor: AppConstants.primaryColor,
              unselectedLabelColor: AppColors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.info_outline), text: 'Overview'),
                Tab(icon: Icon(Icons.description), text: 'Details'),
                Tab(icon: Icon(Icons.file_present), text: 'Documents'),
                Tab(icon: Icon(Icons.card_giftcard), text: 'Subscription'),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: TabBarView(
              controller: _tabController,
              children: [
                CompanyOverviewWidget(profile: state.profile),
                CompanyDetailsWidget(profile: state.profile),
                CompanyDocumentsWidget(
                  profile: state.profile,
                  onUploadDocument: _handleUploadDocument,
                ),
                CompanySubscriptionWidget(profile: state.profile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSaveProfile(Map<String, dynamic> updatedData) async {
    context.read<CompanyProfileBloc>().add(
      UpdateCompanyProfileEvent(data: updatedData),
    );
  }

  Future<void> _handleLogoSelected() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      // Update profile with new logo
      final updatedData = {'companyLogo': pickedFile.path};
      _handleSaveProfile(updatedData);
    }
  }

  Future<void> _handleUploadDocument() async {
    final result = await _filePicker.pickFiles();
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      context.read<CompanyProfileBloc>().add(
        UploadCompanyDocumentEvent(
          filePath: filePath,
          documentType: fileName.split('.').last,
        ),
      );
    }
  }
}

// Details Tab Widget
class CompanyDetailsWidget extends StatelessWidget {
  final CompanyProfileData profile;

  const CompanyDetailsWidget({Key? key, required this.profile})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDetailCard(
            icon: Icons.business,
            title: 'Company Name',
            value: profile.name ?? 'N/A',
          ),
          _buildDetailCard(
            icon: Icons.person,
            title: 'Owner Name',
            value: profile.ownerName ?? 'N/A',
          ),
          _buildDetailCard(
            icon: Icons.description,
            title: 'Legal Name',
            value: profile.legalName ?? 'N/A',
          ),
          _buildDetailCard(
            icon: Icons.domain,
            title: 'Domain',
            value: profile.domain ?? 'N/A',
          ),
          _buildDetailCard(
            icon: Icons.factory,
            title: 'Company Size',
            value: profile.companySize ?? 'N/A',
          ),
          _buildDetailCard(
            icon: Icons.calendar_today,
            title: 'Founded Year',
            value: profile.foundedYear?.toString() ?? 'N/A',
          ),
          _buildDetailCard(
            icon: Icons.numbers,
            title: 'CIN Number',
            value: profile.cinNumber ?? 'N/A',
          ),
          _buildDetailCard(
            icon: Icons.verified,
            title: 'Email Verified',
            value: (profile.isEmailVerified ?? false) ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.brandBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.brandBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



