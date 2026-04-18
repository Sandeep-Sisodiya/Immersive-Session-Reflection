import 'package:flutter/material.dart';
import '../../../data/models/ambience.dart';
import '../../../shared/theme/app_colors.dart';

/// A visually rich card for displaying an ambience on the home screen.
class AmbienceCard extends StatelessWidget {
  final Ambience ambience;
  final VoidCallback onTap;

  const AmbienceCard({
    super.key,
    required this.ambience,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ambience.color.withOpacity(0.4),
              ambience.color.withOpacity(0.15),
            ],
          ),
          border: Border.all(
            color: ambience.color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // ── Background glow ──
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ambience.color.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // ── Content ──
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // ── Icon Container ──
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: ambience.color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getIconForTag(ambience.tag),
                        color: ambience.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // ── Text Content ──
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ambience.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _TagBadge(tag: ambience.tag, color: ambience.color),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.timer_outlined,
                                size: 14,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ambience.formattedDuration,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // ── Arrow ──
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTag(String tag) {
    switch (tag) {
      case 'Nature':
        return Icons.forest_rounded;
      case 'Water':
        return Icons.water_rounded;
      case 'Spiritual':
        return Icons.self_improvement_rounded;
      case 'Space':
        return Icons.auto_awesome_rounded;
      default:
        return Icons.music_note_rounded;
    }
  }
}

class _TagBadge extends StatelessWidget {
  final String tag;
  final Color color;

  const _TagBadge({required this.tag, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
