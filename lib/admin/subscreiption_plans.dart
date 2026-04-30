import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _supportController = TextEditingController();
  final TextEditingController _employeesController = TextEditingController();

  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isEditing = false;
  String? _editingPlanId;
  String? _responseMessage;
  List<Map<String, dynamic>> _plans = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _supportController.dispose();
    _employeesController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    try {
      final plans = await ApiService.getSubscriptionPlans();
      if (!mounted) return;
      setState(() {
        _plans = plans;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _responseMessage = 'Unable to load plans: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitPlan() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final duration = int.tryParse(_durationController.text.trim());
    final support = _supportController.text.trim();
    final employees = _employeesController.text.trim();

    if (price == null || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Price and duration must be valid numbers.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _responseMessage = null;
    });

    try {
      final response = _isEditing && _editingPlanId != null
          ? await ApiService.updateSubscriptionPlan(
              id: _editingPlanId!,
              name: name,
              price: price,
              duration: duration,
              support: support,
              employees: employees,
            )
          : await ApiService.createSubscriptionPlan(
              name: name,
              price: price,
              duration: duration,
              support: support,
              employees: employees,
            );
      print("object: $response");

      final success =
          response.statusCode == 200 &&
          response.data is Map<String, dynamic> &&
          response.data['success'] == true;
      final message = response.data is Map<String, dynamic>
          ? (response.data['message']?.toString() ??
                (success
                    ? (_isEditing
                          ? 'Plan updated successfully.'
                          : 'Plan created successfully.')
                    : 'Submission failed.'))
          : response.statusMessage ??
                (_isEditing ? 'Plan update completed.' : 'Plan submitted.');

      if (!mounted) return;
      setState(() {
        _responseMessage = message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      if (success) { 
        _resetForm();
        await _fetchPlans();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _responseMessage = 'Submission error: $e';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Submission error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    TextInputType keyboardType,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _featureChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: Colors.blue.shade900,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _durationController.clear();
    _supportController.clear();
    _employeesController.clear();
    setState(() {
      _isEditing = false;
      _editingPlanId = null;
      _responseMessage = null;
    });
  }

  void _editPlan(Map<String, dynamic> plan) {
    final planId = plan['id'] ?? plan['_id'] ?? plan['planId'];
    var featuresData = plan['features'];

    if (featuresData is List && featuresData.isNotEmpty) {
      final firstItem = featuresData.first;
      if (firstItem is Map<String, dynamic>) {
        featuresData = firstItem;
      }
    }

    final features = <String, dynamic>{};
    if (featuresData is Map) {
      features.addAll(Map<String, dynamic>.from(featuresData));
    }

    setState(() {
      _isEditing = true;
      _editingPlanId = planId?.toString();
      _nameController.text = plan['name']?.toString() ?? '';
      _priceController.text = plan['price']?.toString() ?? '';
      _durationController.text = plan['duration']?.toString() ?? '';
      _supportController.text = features['support']?.toString() ?? '';
      _employeesController.text = features['employees']?.toString() ?? '';
      _responseMessage = 'Editing "${plan['name'] ?? ''}"';
    });
  }

  Future<void> _confirmDeletePlan(String planId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete plan'),
          content: const Text('Are you sure you want to delete this plan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deletePlan(planId);
    }
  }

  Future<void> _deletePlan(String planId) async {
    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    try {
      final response = await ApiService.deleteSubscriptionPlan(planId);
      final success =
          response.statusCode == 200 &&
          response.data is Map<String, dynamic> &&
          response.data['success'] == true;
      final message = response.data is Map<String, dynamic>
          ? (response.data['message']?.toString() ??
                (success ? 'Plan deleted successfully.' : 'Delete failed.'))
          : response.statusMessage ?? 'Delete request completed.';

      if (!mounted) return;
      setState(() {
        _responseMessage = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      if (success) {
        await _fetchPlans();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _responseMessage = 'Delete error: $e';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final features = Map<String, dynamic>.from(plan['features'] ?? {});
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan['name']?.toString() ?? 'Unnamed Plan',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Duration ${plan['duration']?.toString() ?? '0'} days',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '₹${plan['price']?.toString() ?? '0'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Plan ID',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            plan['id']?.toString() ?? '',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _featureChip(
                        'Support',
                        features['support']?.toString() ?? '-',
                      ),
                      _featureChip(
                        'Employees',
                        features['employees']?.toString() ?? '-',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _editPlan(plan),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(50, 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final id = plan['id']?.toString();
                            if (id != null && id.isNotEmpty) {
                              _confirmDeletePlan(id);
                            }
                          },
                          icon: const Icon(Icons.delete_outline, size: 16),
                          label: const Text('Delete'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            minimumSize: const Size(90, 38),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Plans'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Manage plans',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Create new subscription plans and review current offerings.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${_plans.length} plans',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_responseMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  _responseMessage!,
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Add a new plan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Enter plan details and hit Create to publish a new subscription.',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _nameController,
                        'Plan name',
                        'Enter plan name',
                        TextInputType.text,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              _priceController,
                              'Price',
                              'Enter price',
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              _durationController,
                              'Duration',
                              'Enter duration in days',
                              TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              _supportController,
                              'Support',
                              'Enter support level',
                              TextInputType.text,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              _employeesController,
                              'Employees',
                              'Enter employee limit',
                              TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitPlan,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_isEditing ? 'Update Plan' : 'Create Plan'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),

            Text(
              'Available Plans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),

            const SizedBox(height: 26),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_plans.isEmpty)
              Center(
                child: Text(
                  'No plans available.',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              )
            else
              Column(
                children: _plans.map((plan) => _buildPlanCard(plan)).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
