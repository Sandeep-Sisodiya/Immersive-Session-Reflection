import 'package:hive/hive.dart';

part 'journal_entry_adapter.dart';

/// Mood options for post-session reflection.
enum Mood {
  calm,
  grounded,
  energized,
  sleepy;

  String get label {
    switch (this) {
      case Mood.calm:
        return 'Calm';
      case Mood.grounded:
        return 'Grounded';
      case Mood.energized:
        return 'Energized';
      case Mood.sleepy:
        return 'Sleepy';
    }
  }

  String get emoji {
    switch (this) {
      case Mood.calm:
        return '😌';
      case Mood.grounded:
        return '🌿';
      case Mood.energized:
        return '⚡';
      case Mood.sleepy:
        return '😴';
    }
  }
}

/// A single journal / reflection entry saved after a session.
@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ambienceId;

  @HiveField(2)
  final String ambienceTitle;

  @HiveField(3)
  final String reflection;

  @HiveField(4)
  final int moodIndex; // stored as int, mapped to Mood enum

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final int sessionDurationSeconds;

  JournalEntry({
    required this.id,
    required this.ambienceId,
    required this.ambienceTitle,
    required this.reflection,
    required this.moodIndex,
    required this.date,
    required this.sessionDurationSeconds,
  });

  Mood get mood => Mood.values[moodIndex];

  String get formattedDuration {
    final minutes = sessionDurationSeconds ~/ 60;
    final seconds = sessionDurationSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  String get reflectionPreview {
    if (reflection.length <= 80) return reflection;
    return '${reflection.substring(0, 80)}…';
  }
}
