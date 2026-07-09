import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/company_list_bloc.dart';
import '../bloc/company_list_event.dart';
import '../bloc/company_list_state.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompaniesScreen extends StatefulWidget {
  final String data;
  const CompaniesScreen({super.key, required this.data});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  String get data => widget.data;

  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    
    context.read<CompaniesBloc>().add(FetchCompanies(data: data));
    super.initState();
  }


  @override
  void dispose() {

    searchController.dispose();
    super.dispose();
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.successColor,
                size: 60,
              ),
              const SizedBox(height: 10),
              const Text(
                "Success",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String _companyInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty || name.trim().isEmpty) return '';
    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  bool _isCompanyActive(Map company) {
    final status = (company['status'] ?? '').toString().toLowerCase();
    final activeFlag = company['active'];
    return activeFlag == true || status == 'active';
  }

  Widget _statusChip(Map company) {
    final active = _isCompanyActive(company);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? AppColors.green.withValues(alpha: 0.12)
            : AppColors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          color: active ? AppColors.green.shade800 : AppColors.red.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _subscriptionChip(Map company) {
    final active = (company['subscriptionStatus']=="ACTIVE" ? true : false);
    final status = active ? 'Subscribed' : 'Not Subscribed';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? AppColors.blue.withValues(alpha: 0.12)
            : AppColors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: active ? AppColors.blue.shade800 : AppColors.orange.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.grey.shade100,
      appBar: AppBar(
        title: const Text("Companies"),
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push("/admin/addcompany");
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Company"),
      ),
      body: BlocListener<CompaniesBloc, CompaniesState>(
        listener: (context, state) {
          if (state is DeletedCompaniesActionSuccess) {
            showSuccessDialog(context, state.message);
          } else if (state is DeletedCompaniesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },

        child: BlocBuilder<CompaniesBloc, CompaniesState>(
          builder: (context, state) {
            if (state is CompaniesLoading || state is CompaniesInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CompaniesLoaded) {
              final filteredCount = state.filteredCompanies.length;
              final totalCount = state.companies.length;

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company Directory',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$filteredCount of $totalCount companies',
                              style: TextStyle(color: AppColors.grey.shade700),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.business, color: primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                'Business',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          context.read<CompaniesBloc>().add(
                            SearchCompanies(value),
                          );
                        },
                        decoration: const InputDecoration(
                          hintText: "Search companies...",
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: state.filteredCompanies.isEmpty
                        ? Center(
                            child: Text(
                              'No companies found',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.grey.shade600),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.filteredCompanies.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final c = state.filteredCompanies[index];
                              final companyName = c['companyName'] ?? '';
                              final email = c['companyEmail'] ?? '';
                              final companyLogo = c['companyLogo'];
                              final location =
                                  c['location'] ?? 'Location not set';
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 1.5,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () {
                                   
                                          context.push(
                                            '/admin/reviewscreen/${c['id']}/false',
                                          );
                                        
                                  
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 26,
                                              backgroundColor: primaryColor
                                                  .withValues(alpha: 0.16),
                                              backgroundImage:
                                                  companyLogo != null &&
                                                      companyLogo.isNotEmpty
                                                  ? NetworkImage(companyLogo)
                                                  : null,
                                              child:
                                                  companyLogo == null ||
                                                      companyLogo.isEmpty
                                                  ? Text(
                                                      _companyInitials(
                                                        companyName,
                                                      ),
                                                      style: TextStyle(
                                                        color: AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    companyName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    email,
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .grey
                                                          .shade600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 14,
                                                        color: AppColors
                                                            .darkSecondaryColor,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        location,
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .grey
                                                              .shade500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Divider(
                                          color: AppColors.grey.shade200,
                                          height: 1,
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                _statusChip(c),
                                                const SizedBox(width: 8),
                                                _subscriptionChip(c),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                if(data=="deleted")
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.restore,
                                                    color:
                                                        AppColors.successColor,
                                                  ),
                                                  onPressed: () {
                                                    context.read().add(
                                                      RestoreCompanyEvent(
                                                        c['id'].toString(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: AppColors.errorColor,
                                                  ),
                                                  onPressed: () {
                                                    context.read().add(
                                                      DeleteCompanyPermanentEvent(
                                                        data,
                                                        c['id'].toString(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
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
                  ),
                ],
              );
            }
            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }
}
