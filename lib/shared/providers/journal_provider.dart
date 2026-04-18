import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/journal_datasource.dart';
import '../../data/models/journal_entry.dart';

/// Manages journal entries (reflection history) with Hive persistence.
class JournalProvider extends ChangeNotifier {
  final JournalDatasource _datasource = JournalDatasource();
  final Uuid _uuid = const Uuid();

  List<JournalEntry> _entries = [];
  bool _isLoading = false;

  // ── Getters ──
  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  bool get isEmpty => _entries.isEmpty && !_isLoading;

  // ── Load ──
  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();

    _entries = await _datasource.getAllEntries();

    _isLoading = false;
    notifyListeners();
  }

  // ── Add Entry ──
  Future<void> addEntry({
    required String ambienceId,
    required String ambienceTitle,
    required String reflection,
    required int moodIndex,
    required int sessionDurationSeconds,
  }) async {
    final entry = JournalEntry(
      id: _uuid.v4(),
      ambienceId: ambienceId,
      ambienceTitle: ambienceTitle,
      reflection: reflection,
      moodIndex: moodIndex,
      date: DateTime.now(),
      sessionDurationSeconds: sessionDurationSeconds,
    );

    await _datasource.addEntry(entry);
    _entries.insert(0, entry); // newest first
    notifyListeners();
  }

  // ── Delete ──
  Future<void> deleteEntry(String id) async {
    await _datasource.deleteEntry(id);
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
