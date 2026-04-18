import 'dart:ui';

/// Represents a single meditation ambience loaded from JSON.
class Ambience {
  final String id;
  final String title;
  final String description;
  final String tag;
  final int duration; // in seconds
  final String audioFile;
  final String imageUrl;
  final List<String> sensoryTags;
  final Color color;

  const Ambience({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.duration,
    required this.audioFile,
    required this.imageUrl,
    required this.sensoryTags,
    required this.color,
  });

  factory Ambience.fromJson(Map<String, dynamic> json) {
    final colorHex = (json['color'] as String).replaceFirst('#', '');
    return Ambience(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tag: json['tag'] as String,
      duration: json['duration'] as int,
      audioFile: json['audioFile'] as String,
      imageUrl: json['imageUrl'] as String,
      sensoryTags: List<String>.from(json['sensoryTags'] as List),
      color: Color(int.parse('FF$colorHex', radix: 16)),
    );
  }

  /// Formatted duration string (e.g., "10 min", "1 hr 20 min")
  String get formattedDuration {
    final minutes = duration ~/ 60;
    if (minutes >= 60) {
      final hrs = minutes ~/ 60;
      final mins = minutes % 60;
      return mins > 0 ? '$hrs hr $mins min' : '$hrs hr';
    }
    return '$minutes min';
  }
}
