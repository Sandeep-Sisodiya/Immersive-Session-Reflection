// Manually written Hive TypeAdapter for JournalEntry.
// This avoids the need for hive_generator / build_runner.

part of 'journal_entry.dart';

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String,
      ambienceId: fields[1] as String,
      ambienceTitle: fields[2] as String,
      reflection: fields[3] as String,
      moodIndex: fields[4] as int,
      date: fields[5] as DateTime,
      sessionDurationSeconds: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(7) // number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ambienceId)
      ..writeByte(2)
      ..write(obj.ambienceTitle)
      ..writeByte(3)
      ..write(obj.reflection)
      ..writeByte(4)
      ..write(obj.moodIndex)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.sessionDurationSeconds);
  }
}
