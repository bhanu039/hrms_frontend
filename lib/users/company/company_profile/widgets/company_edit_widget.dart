import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/company_profile_modal.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyEditWidget extends StatefulWidget {
  final CompanyProfileData profile;
  final Function(Map<String, dynamic>) onSave;
  final Function() onLogoSelected;
  final List<IndustryType> industryTypes;
  final bool isReadOnly;

  const CompanyEditWidget({
    Key? key,
    required this.profile,
    required this.onSave,
    required this.onLogoSelected,
    required this.industryTypes,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  State<CompanyEditWidget> createState() => _CompanyEditWidgetState();
}

class _CompanyEditWidgetState extends State<CompanyEditWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _ownerNameController;
  late TextEditingController _ownerEmailController;
  late TextEditingController _legalNameController;
  late TextEditingController _domainController;
  late TextEditingController _linkedinController;
  late TextEditingController _cinController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _geofenceController;

  String? _selectedIndustryTypeId;
  String? _selectedCompanySize;

  final List<String> _companySizes = [
    'Startup',
    '1-10',
    '11-50',
    '51-200',
    '201-500',
    '501-1000',
    '1000+',
  ];

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _websiteController = TextEditingController(text: widget.profile.website);
    _ownerNameController = TextEditingController(
      text: widget.profile.ownerName,
    );
    _ownerEmailController = TextEditingController(
      text: widget.profile.ownerEmail,
    );
    _legalNameController = TextEditingController(
      text: widget.profile.legalName,
    );
    _domainController = TextEditingController(text: widget.profile.domain);
    _linkedinController = TextEditingController(
      text: widget.profile.linkedinUrl,
    );
    _cinController = TextEditingController(text: widget.profile.cinNumber);
    _latitudeController = TextEditingController(
      text: widget.profile.latitude?.toString(),
    );
    _longitudeController = TextEditingController(
      text: widget.profile.longitude?.toString(),
    );
    _geofenceController = TextEditingController(
      text: widget.profile.geofenceRadius?.toString(),
    );

    _selectedIndustryTypeId = widget.profile.industryTypeId;
    _selectedCompanySize = widget.profile.companySize;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _legalNameController.dispose();
    _domainController.dispose();
    _linkedinController.dispose();
    _cinController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _geofenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Section
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: widget.isReadOnly ? null : widget.onLogoSelected,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.brandBlue,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: widget.profile.companyLogo != null
                                ? Image.network(
                                    widget.profile.companyLogo!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholder();
                                    },
                                  )
                                : _buildPlaceholder(),
                          ),
                        ),
                        if (!widget.isReadOnly)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.brandBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!widget.isReadOnly)
                     Text(
                      'Tap to change logo',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Basic Information Section
            _buildSectionTitle('Basic Information'),
            _buildTextField(
              controller: _nameController,
              label: 'Company Name',
              icon: Icons.business,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Company name is required' : null,
            ),
            _buildTextField(
              controller: _legalNameController,
              label: 'Legal Name',
              icon: Icons.description,
            ),
            _buildTextField(
              controller: _domainController,
              label: 'Domain',
              icon: Icons.domain,
            ),
            const SizedBox(height: 16),

            // Contact Information Section
            _buildSectionTitle('Contact Information'),
            _buildTextField(
              controller: _emailController,
              label: 'Company Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              controller: _websiteController,
              label: 'Website',
              icon: Icons.language,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            // Owner Information Section
            _buildSectionTitle('Owner Information'),
            _buildTextField(
              controller: _ownerNameController,
              label: 'Owner Name',
              icon: Icons.person,
            ),
            _buildTextField(
              controller: _ownerEmailController,
              label: 'Owner Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Company Details Section
            _buildSectionTitle('Company Details'),

            _buildDropdown(
              label: 'Company Size',
              value: _selectedCompanySize,
              items: _companySizes
                  .map(
                    (size) => DropdownMenuItem(value: size, child: Text(size)),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedCompanySize = value),
            ),
            _buildTextField(
              controller: _cinController,
              label: 'CIN Number',
              icon: Icons.numbers,
            ),
            _buildTextField(
              controller: _linkedinController,
              label: 'LinkedIn URL',
              icon: Icons.link,
            ),
            const SizedBox(height: 16),

            // Location Information Section
            _buildSectionTitle('Location Information'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _latitudeController,
                    label: 'Latitude',
                    icon: Icons.location_on,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _longitudeController,
                    label: 'Longitude',
                    icon: Icons.location_on,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            _buildTextField(
              controller: _geofenceController,
              label: 'Geofence Radius (meters)',
              icon: Icons.circle,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Action Buttons - Only show in edit mode
            if (!widget.isReadOnly)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleSave,
                      icon: _isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.blue.shade900,
                                ),
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.brandBlue.withOpacity(0.1),
      child:  Icon(Icons.business, color: AppColors.brandBlue, size: 50),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.brandBlue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: widget.isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.brandBlue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(color: AppColors.amberDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(color: AppColors.brandBlue, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(color: AppColors. amberDark),
          ),
          filled: true,
          fillColor: AppColors.grey.withOpacity(0.05),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    // Only use the value if it exists in items to prevent dropdown errors
    final validValue =
        items.isNotEmpty && items.any((item) => item.value == value)
        ? value
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: validValue,
        items: items,
        onChanged: widget.isReadOnly ? null : (val) => onChanged(val),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(color: AppColors.amberDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(color: AppColors.brandBlue, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(color: AppColors.amberDark),
          ),
          filled: true,
          fillColor: AppColors.grey.withOpacity(0.05),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updatedData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'website': _websiteController.text,
        'ownerName': _ownerNameController.text,
        'ownerEmail': _ownerEmailController.text,
        'legalName': _legalNameController.text,
        'domain': _domainController.text,
        'linkedinUrl': _linkedinController.text,
        'cinNumber': _cinController.text,
        'industryTypeId': _selectedIndustryTypeId,
        'companySize': _selectedCompanySize,
        if (_latitudeController.text.isNotEmpty)
          'latitude': double.parse(_latitudeController.text),
        if (_longitudeController.text.isNotEmpty)
          'longitude': double.parse(_longitudeController.text),
        if (_geofenceController.text.isNotEmpty)
          'geofenceRadius': int.parse(_geofenceController.text),
      };

      widget.onSave(updatedData);

      // Reset loading state after a delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    }
  }
}



