import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/api_service.dart';
import 'company_list_event.dart';
import 'company_list_state.dart';


// ==========================
// BLOC
// ==========================
class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  CompaniesBloc() : super(CompaniesInitial()) {
    on<FetchCompanies>(_onFetchDeletedCompanies);
    
    on<SearchCompanies>(_onSearchCompanies);
    on<RestoreCompanyEvent>(_onRestoreCompany);
    on<DeleteCompanyPermanentEvent>(_onDeleteCompany);
  }

  List _allCompanies = [];

  Future<void> _onFetchDeletedCompanies(
    FetchCompanies event,
    Emitter<CompaniesState> emit,
  ) async {
    emit(CompaniesLoading());
    try {
      var result = await ApiService.getdeletedCompanies();
      _allCompanies = result["companies"] ?? [];
      emit(CompaniesLoaded(
        companies: _allCompanies,
        filteredCompanies: _allCompanies,
      ));
    } catch (e) {
      emit(DeletedCompaniesError("Fetch Error: $e"));
    }
  }


  void _onSearchCompanies(
    SearchCompanies event,
    Emitter<CompaniesState> emit,
  ) {
    if (state is CompaniesLoaded) {
      final query = event.query.toLowerCase();
      final results = _allCompanies.where((c) {
        final name = (c['name'] ?? '').toLowerCase();
        final email = (c['email'] ?? '').toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();

      emit(CompaniesLoaded(
        companies: _allCompanies,
        filteredCompanies: results,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onRestoreCompany(
    RestoreCompanyEvent event,
    Emitter<CompaniesState> emit,
  ) async {
    try {
      final ApiService apiService = ApiService();
      bool success = await apiService.restoreCompany(event.companyId);
      if (success) {
        emit(DeletedCompaniesActionSuccess("Company restored successfully"));
        add(FetchCompanies());
      } else {
        emit(DeletedCompaniesError("Restore failed"));
      }
    } catch (e) {
      emit(DeletedCompaniesError("Error: $e"));
    }
  }

  Future<void> _onDeleteCompany(
    DeleteCompanyPermanentEvent event,
    Emitter<CompaniesState> emit,
  ) async {
    try {
      bool success = await ApiService.deleteCompany(event.companyId);
      if (success) {
        emit(DeletedCompaniesActionSuccess("Company deleted permanently"));
        add(FetchCompanies());
      } else {
        emit(DeletedCompaniesError("Delete failed"));
      }
    } catch (e) {
      emit(DeletedCompaniesError("Error: $e"));
    }
  }
}
