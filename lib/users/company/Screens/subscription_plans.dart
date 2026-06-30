import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/plan_model.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  List<Plan> _plans = [];
  bool _loading = false;

  // ✅ FIX 1 (MISSING VARIABLE)
  String? selectedPlanId;

  @override
  void initState() {
    super.initState();
    fetchPlans();
  }

  // 🔵 GET PLANS (FIXED)
  Future<void> fetchPlans() async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await ApiService.getSubscriptionPlans();

      setState(() {
        _plans = response;
      });

      print("Fetched ${_plans.length} plans");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // 🧩 PLAN CARD UI
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
          ?    Center(
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
                        color: isSelected ? AppColors.info : AppColors.borderColor,
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
                              style:   TextStyle(
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
                                    color: AppColors.successColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${e.key}: ${e.value}",
                                    style: const TextStyle(
                                      color: AppColors.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? AppColors.info
                                  : AppColors.surfaceMuted,
                              foregroundColor: isSelected
                                  ? AppColors.white
                                  : AppColors.textDark,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedPlanId = plan.id;
                              });
                            },
                            child: Text(
                              isSelected ? "Selected Plan" : "Choose Plan",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}


