import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/api_service.dart';
import '../../company/models/plan_model.dart';
import 'package:goexperts/core/app_constants/app_color.dart';
class SubscriptionAdminPage extends StatefulWidget {
  const SubscriptionAdminPage({super.key});

  @override
  State<SubscriptionAdminPage> createState() => _SubscriptionAdminPageState();
}

class _SubscriptionAdminPageState extends State<SubscriptionAdminPage> {
  List<Plan> _plans = [];
  bool _loading = false;

  String? selectedPlanId;

  @override
  void initState() {
    super.initState();
    fetchPlans();
  }

  // ================= FETCH =================
  Future<void> fetchPlans() async {
    setState(() => _loading = true);
    try {
      _plans = await ApiService.getSubscriptionPlans();
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() => _loading = false);
  }

  // ================= DELETE =================
  Future<void> deletePlan(String id) async {
    await ApiService.deleteSubscriptionPlan(id);
    fetchPlans();
  }

  // ================= DIALOG =================
  void showPlanDialog({Plan? plan}) {
    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController(text: plan?.name ?? '');

    final priceController = TextEditingController(
      text: plan?.price.toString() ?? '',
    );

    final durationController = TextEditingController(
      text: plan?.duration.toString() ?? '',
    );

    // ✅ FULL DYNAMIC FEATURES LIST
    List<MapEntry<TextEditingController, TextEditingController>>
    featureControllers = [];

    void loadFeatures() {
      featureControllers.clear();

      if (plan != null) {
        final data = plan.features.toJson();

        data.forEach((key, value) {
          featureControllers.add(
            MapEntry(
              TextEditingController(text: key),
              TextEditingController(text: value.toString()),
            ),
          );
        });
      } else {
        featureControllers.add(
          MapEntry(TextEditingController(), TextEditingController()),
        );
      }
    }

    loadFeatures();

    showDialog(
      context: context,
      builder: (context) {
        bool checker = false;
        return StatefulBuilder(
          
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: SafeArea(
                  child: Container(
                    
                    constraints: const BoxConstraints(maxWidth: 520),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                  
                      // modern soft shadow
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                  
                      // subtle border for SaaS look
                      border: Border.all(color: AppColors.grey.shade200),
                    ),
                  
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan == null ? "Create Plan" : "Edit Plan",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  
                            const SizedBox(height: 16),
                  
                            // TITLE
                            TextFormField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: "Title",
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? "Enter title" : null,
                            ),
                  
                            const SizedBox(height: 12),
                  
                            // PRICE
                            TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Price",
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? "Enter price" : null,
                            ),
                  
                            const SizedBox(height: 12),
                  
                            // DURATION
                            TextFormField(
                              controller: durationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Duration",
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? "Enter duration"
                                  : null,
                            ),
                  
                            const SizedBox(height: 16),
                  
                            // FEATURES HEADER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Features",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon:  Icon(
                                    Icons.add_circle,
                                    color: AppColors.blue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      checker = true;
                  
                                      featureControllers.add(
                                        MapEntry(
                                          TextEditingController(),
                                          TextEditingController(),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                  
                            const SizedBox(height: 10),
                  
                            // FEATURES LIST
                            Column(
                              children: featureControllers.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                  
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: entry.value.key,
                                          decoration: const InputDecoration(
                                            labelText: "Feature Name",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (v) => v == null || v.isEmpty
                                              ? "Enter feature"
                                              : null,
                                        ),
                                      ),
                  
                                      const SizedBox(width: 8),
                  
                                      Expanded(
                                        child: TextFormField(
                                          controller: entry.value.value,
                                          decoration: const InputDecoration(
                                            labelText: "Feature Value",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (v) => v == null || v.isEmpty
                                              ? "Enter value"
                                              : null,
                                        ),
                                      ),
                                      checker
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: AppColors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  featureControllers.removeAt(
                                                    index,
                                                  );
                                                });
                                              },
                                            )
                                          : Text(""),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                  
                            const SizedBox(height: 20),
                  
                            Row(
                              children: [
                                const SizedBox(width: 30),
                                SizedBox(
                                  width: 100,
                                  height: 42,
                                  child: Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.grey.shade300,
                                        foregroundColor: AppColors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                  ),
                                ),
                  
                                const SizedBox(width: 20),
                  
                                // SAVE BUTTON
                                SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }
                  
                                      // ✅ BUILD MAP
                                      Map<String, String> finalFeatures = {};
                  
                                      for (var f in featureControllers) {
                                        final key = f.key.text.trim();
                                        final value = f.value.text.trim();
                  
                                        if (key.isNotEmpty && value.isNotEmpty) {
                                          finalFeatures[key] = value;
                                        }
                                      }
                  
                                      // ✅ CONVERT MAP TO LIST
                                      final List<String> apiFeatures =
                                          finalFeatures.entries
                                              .map((e) => "${e.key}: ${e.value}")
                                              .toList();
                  
                                      try {
                                        // CREATE
                                        if (plan == null) {
                                          await ApiService.createSubscriptionPlan(
                                            title: titleController.text,
                                            price: 
                                              double.parse(priceController.text.toString()),
                                            
                                            duration: int.parse(
                                              durationController.text,
                                            ),
                                            features: apiFeatures,
                                          );
                                        }
                                        // UPDATE
                                        else {

                                          await ApiService.updateSubscriptionPlan(
                                            id: plan.id,
                                            title: titleController.text,
                                            price: double.parse(
                                              priceController.text,
                                            ),
                                            duration: int.parse(
                                              durationController.text,
                                            ),
                                            features: apiFeatures,
                                          );
                                        }
                  
                                        context.pop();
                  
                                        fetchPlans();
                  
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              plan == null
                                                  ? "Plan Created Successfully"
                                                  : "Plan Updated Successfully",
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                         context.pop();
                  
                                        fetchPlans();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    },
                                    child: Text(
                                      plan == null ? "Create" : "Update",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,

      appBar: AppBar(
        title: const Text("Subscription Plans"),
        centerTitle: true,
        backgroundColor: AppColors.surfaceElevated,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _plans.isEmpty
          ?  Center(
              child: Text(
                "No Plans Found",
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          : ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];

                final features = plan.features.toJson();

                final isSelected = selectedPlanId == plan.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPlanId = plan.id;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: isSelected
                          ? AppColors.blueTint
                          : AppColors.surfaceElevated,
                      border: Border.all(
                        color: isSelected ? AppColors.info : AppColors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.info.withValues(alpha: 0.18)
                              : AppColors.shadowSoft,
                          blurRadius: isSelected ? 24 : 14,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE + PRICE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              plan.name,
                              style:  TextStyle(
                                color: AppColors.textDark,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${plan.price}",
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.successColor
                                    : AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// FEATURES
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: features.entries.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.successColor ,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${e.key}: ${e.value}",
                                    style:  TextStyle(
                                      color: AppColors.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        /// BUTTON
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => showPlanDialog(plan: plan),
                                child: const Text("Edit"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.red,
                                ),
                                onPressed: () => deletePlan(plan.id),
                                child: const Text("Delete"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showPlanDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}


