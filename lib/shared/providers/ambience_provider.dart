import 'package:flutter/material.dart';
import '../../data/datasources/ambience_datasource.dart';
import '../../data/models/ambience.dart';

/// Manages ambience list, search, and filtering state.
class AmbienceProvider extends ChangeNotifier {
  final AmbienceDatasource _datasource = AmbienceDatasource();

  List<Ambience> _allAmbiences = [];
  List<Ambience> _filteredAmbiences = [];
  String _searchQuery = '';
  String _selectedTag = 'All';
  bool _isLoading = false;
  String? _error;

  // ── Getters ──
  List<Ambience> get ambiences => _filteredAmbiences;
  String get searchQuery => _searchQuery;
  String get selectedTag => _selectedTag;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _filteredAmbiences.isEmpty && !_isLoading;

  List<String> get availableTags {
    final tags = _allAmbiences.map((a) => a.tag).toSet().toList();
    tags.sort();
    return ['All', ...tags];
  }

  // ── Load Data ──
  Future<void> loadAmbiences() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allAmbiences = await _datasource.loadAmbiences();
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load ambiences. Please try again.';
      _filteredAmbiences = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Search ──
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // ── Filter ──
  void setSelectedTag(String tag) {
    _selectedTag = tag;
    _applyFilters();
    notifyListeners();
  }

  // ── Lookup ──
  Ambience? getAmbienceById(String id) {
    try {
      return _allAmbiences.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Private ──
  void _applyFilters() {
    _filteredAmbiences = _allAmbiences.where((ambience) {
      final matchesSearch = _searchQuery.isEmpty ||
          ambience.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ambience.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          ambience.tag.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesTag =
          _selectedTag == 'All' || ambience.tag == _selectedTag;

      return matchesSearch && matchesTag;
    }).toList();
  }
}
