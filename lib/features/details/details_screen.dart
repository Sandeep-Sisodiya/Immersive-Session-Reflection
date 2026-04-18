import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/ambience.dart';
import '../../shared/providers/session_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../player/player_screen.dart';

/// Shows full details for a single ambience with sensory chips
/// and a "Start Session" button.
class DetailsScreen extends StatelessWidget {
  final Ambience ambience;

  const DetailsScreen({super.key, required this.ambience});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background Gradient ──
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ambience.color.withOpacity(0.5),
                  ambience.color.withOpacity(0.1),
                  AppColors.background,
                ],
              ),
            ),
          ),
          // ── Glow Orb ──
          Positioned(
            top: 60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ambience.color.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // ── Content ──
          SafeArea(
            child: Column(
              children: [
                // ── App Bar ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface.withOpacity(0.5),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                // ── Scrollable Content ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // ── Large Icon ──
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: ambience.color.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: ambience.color.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _getIconForTag(ambience.tag),
                              size: 56,
                              color: ambience.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ── Title ──
                        Center(
                          child: Text(
                            ambience.title,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // ── Duration & Tag Row ──
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: ambience.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  ambience.tag,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ambience.color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.timer_outlined,
                                  size: 16, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                ambience.formattedDuration,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // ── Description ──
                        Text(
                          'About this session',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ambience.description,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.7,
                                  ),
                        ),
                        const SizedBox(height: 32),
                        // ── Sensory Tags ──
                        Text(
                          'Sensory Experience',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: ambience.sensoryTags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: ambience.color.withOpacity(0.15),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.spa_outlined,
                                    size: 14,
                                    color: ambience.color.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Start Session Button ──
          Positioned(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
            child: _StartButton(ambience: ambience),
          ),
        ],
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

class _StartButton extends StatelessWidget {
  final Ambience ambience;

  const _StartButton({required this.ambience});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final session = context.read<SessionProvider>();
        session.startSession(ambience);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PlayerScreen(),
          ),
        );
      },
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Start Session',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
