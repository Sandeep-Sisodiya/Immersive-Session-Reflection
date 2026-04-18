import 'package:hive/hive.dart';
import '../models/journal_entry.dart';

/// Manages CRUD operations for journal entries using Hive.
class JournalDatasource {
  static const String _boxName = 'journal_entries';

  Future<Box<JournalEntry>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<JournalEntry>(_boxName);
    }
    return Hive.box<JournalEntry>(_boxName);
  }

  Future<List<JournalEntry>> getAllEntries() async {
    final box = await _getBox();
    final entries = box.values.toList();
    // Sort by date descending (newest first)
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<void> addEntry(JournalEntry entry) async {
    final box = await _getBox();
    await box.put(entry.id, entry);
  }

  Future<void> deleteEntry(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  Future<JournalEntry?> getEntry(String id) async {
    final box = await _getBox();
    return box.get(id);
  }
}
