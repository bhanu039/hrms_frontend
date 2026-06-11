import 'package:flutter/material.dart';
import '../../company/models/plan_model.dart';
import '../../core/services/api_service.dart';

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
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 500,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
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
                          validator: (v) =>
                              v == null || v.isEmpty ? "Enter duration" : null,
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
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.blue,
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
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
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
                                    backgroundColor: Colors.grey.shade300,
                                    foregroundColor: Colors.black,
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
                                  final List<String> apiFeatures = finalFeatures
                                      .entries
                                      .map((e) => "${e.key}: ${e.value}")
                                      .toList();

                                  try {
                                    // CREATE
                                    if (plan == null) {
                                      await ApiService.createSubscriptionPlan(
                                        title: titleController.text,
                                        price: int.parse(priceController.text),
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
                                        price: int.parse(priceController.text),
                                        duration: int.parse(
                                          durationController.text,
                                        ),
                                        features: apiFeatures,
                                      );
                                    }

                                    Navigator.pop(context);

                                    fetchPlans();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          plan == null
                                              ? "Plan Created Successfully"
                                              : "Plan Updated Successfully",
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                                child: Text(plan == null ? "Create" : "Update"),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                                  backgroundColor: Colors.red,
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
