import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/api_service.dart';
import '../company_list_repo.dart';
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
      var result = await CompanyListRepo.getCompanies(event.data);
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
      bool success = await CompanyListRepo.restoreCompany(event.companyId);
      if (success) {
        emit(DeletedCompaniesActionSuccess("Company restored successfully"));
        add(FetchCompanies(data: 'active'));
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
      bool success = await CompanyListRepo.deleteCompany(event.status, event.companyId);
      if (success) {
        emit(DeletedCompaniesActionSuccess("Company deleted permanently"));
        add(FetchCompanies(data: 'active'));
      } else {
        emit(DeletedCompaniesError("Delete failed"));
      }
    } catch (e) {
      emit(DeletedCompaniesError("Error: $e"));
    }
  }
}
