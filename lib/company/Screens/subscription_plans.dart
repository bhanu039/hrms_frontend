import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../models/plan_model.dart';

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
      backgroundColor: const Color.fromARGB(255, 246, 220, 220),

      appBar: AppBar(
        title: const Text("Subscription Plans"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(152, 237, 235, 235),
        elevation: 0,
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _plans.isEmpty
          ? const Center(
              child: Text(
                "No Plans Found",
                style: TextStyle(color: Colors.white),
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
                      gradient: LinearGradient(
                        colors: isSelected
                            ? [
                                const Color.fromARGB(
                                  255,
                                  67,
                                  68,
                                  68,
                                ).withValues(alpha: 0.25),
                                Colors.cyan.withValues(alpha: 0.08),
                              ]
                            : [
                                const Color.fromARGB(255, 53, 38, 38),
                                const Color.fromARGB(26, 255, 206, 206),
                              ],
                      ),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.white12,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.25),
                                blurRadius: 18,
                              ),
                            ]
                          : [],
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${plan.price}",
                              style: TextStyle(
                                color: isSelected
                                    ? const Color.fromARGB(255, 0, 254, 89)
                                    : const Color.fromARGB(179, 251, 1, 1),
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
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${e.key}: ${e.value}",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 248, 247, 247),
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
                                  ? Colors.blue
                                  : Colors.white12,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedPlanId = plan.id;
                              });
                            },
                            child: Text(
                              isSelected ? "Selected Plan" : "Choose Plan",
                              style: const TextStyle(color: Colors.white),
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
