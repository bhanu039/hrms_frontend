import 'package:flutter/material.dart';
import '../company/models/plan_model.dart';
import '../services/api_service.dart';

class SubscriptionAdminPage extends StatefulWidget {
  const SubscriptionAdminPage({super.key});

  @override
  State<SubscriptionAdminPage> createState() => _SubscriptionAdminPageState();
}

class _SubscriptionAdminPageState extends State<SubscriptionAdminPage> {
  List<Plan> _plans = [];
  bool _loading = false;

  String? selectedPlanId; // ✅ Selected plan for UI highlight
  String? editingId; // ✅ Current plan being edited

  final _formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final featureCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlans();
  }

  // 🔵 FETCH PLANS
  Future<void> fetchPlans() async {
    setState(() => _loading = true);
    try {
      final response = await ApiService.getSubscriptionPlans();
      _plans = response;
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() => _loading = false);
  }

  // 🔴 DELETE PLAN
  Future<void> deletePlan(String id) async {
    try {
      final response = await ApiService.deleteSubscriptionPlan(id);
      if (response.statusCode == 200 && response.data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Plan deleted successfully")),
        );
        fetchPlans();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to delete plan")));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 🔵 CLEAR FORM
  void clearForm() {
    editingId = null;
    titleCtrl.clear();
    priceCtrl.clear();
    durationCtrl.clear();
    featureCtrl.clear();
  }

  // 🟢 SHOW PLAN DIALOG (CREATE / EDIT)
  void showPlanDialog({Plan? plan}) {
    final _dialogFormKey = GlobalKey<FormState>();

    final titleController = TextEditingController(text: plan?.name ?? '');
    final priceController = TextEditingController(
      text: plan?.price.toString() ?? '',
    );
    final durationController = TextEditingController(
      text: plan?.duration.toString() ?? '',
    );

    List<MapEntry<TextEditingController, TextEditingController>>
    featureControllers = [];

    if (plan != null) {
      editingId = plan.id;

      // Fixed features first
      featureControllers.add(
        MapEntry(
          TextEditingController(text: "Support"),
          TextEditingController(text: plan.features.support),
        ),
      );
      featureControllers.add(
        MapEntry(
          TextEditingController(text: "Employees"),
          TextEditingController(text: plan.features.employees),
        ),
      );

      // Extra features
      plan.features.extraFeatures.forEach((key, value) {
        featureControllers.add(
          MapEntry(
            TextEditingController(text: key),
            TextEditingController(text: value),
          ),
        );
      });
    } else {
      clearForm();
      // Default empty support and employees
      featureControllers.add(
        MapEntry(TextEditingController(), TextEditingController()),
      );
      featureControllers.add(
        MapEntry(TextEditingController(), TextEditingController()),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _dialogFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          plan == null ? "Create Plan" : "Edit Plan",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.isEmpty ? "Enter title" : null,
                        ),
                        const SizedBox(height: 12),

                        // Price
                        TextFormField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Price",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.isEmpty ? "Enter price" : null,
                        ),
                        const SizedBox(height: 12),

                        // Duration
                        TextFormField(
                          controller: durationController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Duration",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "Enter duration" : null,
                        ),
                        const SizedBox(height: 12),

                        // Features header + Add button
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

                        // Dynamic Features List
                        Column(
                          children: featureControllers
                              .asMap()
                              .entries
                              .map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          controller: entry.value.key,
                                          decoration: const InputDecoration(
                                            labelText: "Feature Name",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (v) => v!.isEmpty
                                              ? "Enter feature name"
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 6,
                                        child: TextFormField(
                                          controller: entry.value.value,
                                          decoration: const InputDecoration(
                                            labelText: "Feature Value",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (v) => v!.isEmpty
                                              ? "Enter feature value"
                                              : null,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            featureControllers.removeAt(
                                              entry.key,
                                            );
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 20),

                        // Cancel / Save Buttons
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
                                  if (!_dialogFormKey.currentState!.validate())
                                    return;

                                  // Build Features object
                                  Map<String, String> extraFeatures = {};
                                  String support = '';
                                  String employees = '';

                                  for (var f in featureControllers) {
                                    String key = f.key.text;
                                    String value = f.value.text;

                                    if (key.toLowerCase() == "support") {
                                      support = value;
                                    } else if (key.toLowerCase() ==
                                        "employees") {
                                      employees = value;
                                    } else {
                                      extraFeatures[key] = value;
                                    }
                                  }

                                  Features features = Features(
                                    support: support,
                                    employees: employees,
                                    extraFeatures: extraFeatures,
                                  );

                                  Plan newPlan = Plan(
                                    id: plan?.id ?? DateTime.now().toString(),
                                    name: titleController.text,
                                    price: double.parse(priceController.text),
                                    duration: int.parse(
                                      durationController.text,
                                    ),
                                    features: features,
                                  );

                                  // Call API save function here
                                  // await savePlan(newPlan);

                                  Navigator.pop(context);
                                  fetchPlans();
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
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Subscription Plans"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _plans.isEmpty
          ? const Center(
              child: Text(
                "No Plans Found",
                style: TextStyle(color: Colors.black87),
              ),
            )
          : ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];

                // ✅ Combine fixed + extra features
                Map<String, String> allFeatures = {
                  "Support": plan.features.support,
                  "Employees": plan.features.employees,
                  ...plan.features.extraFeatures,
                };

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
                                Colors.blue.withOpacity(0.25),
                                const Color.fromARGB(
                                  255,
                                  109,
                                  194,
                                  205,
                                ).withOpacity(0.08),
                              ]
                            : [
                                 const Color.fromARGB(255, 253, 12, 12),
                                const Color.fromARGB(26, 255, 255, 255),
                              ],
                      ),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.white12,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.25),
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
                                color: Color.fromARGB(255, 24, 23, 23),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${plan.price}",
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.greenAccent,
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
                          children: allFeatures.entries.map((e) {
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
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 14),

                        /// BUTTONS
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? Colors.blue
                                      : Colors.white12,
                                ),
                                onPressed: () {
                                  showPlanDialog(plan: plan);
                                },
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                onPressed: () => deletePlan(plan.id),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
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
        onPressed: () {
          showPlanDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
