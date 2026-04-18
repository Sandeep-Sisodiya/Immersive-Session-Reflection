import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/session_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../reflection/reflection_screen.dart';
import 'widgets/breathing_animation.dart';

/// Full-screen player with timer, controls, and breathing animation.
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Go back but keep session running (mini player will show)
          Navigator.pop(context);
        }
      },
      child: Consumer<SessionProvider>(
        builder: (context, session, _) {
          if (session.currentAmbience == null) {
            return const Scaffold(
              body: Center(child: Text('No active session')),
            );
          }

          final ambience = session.currentAmbience!;

          // If session completed, navigate to reflection
          if (session.sessionState == SessionState.completed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ReflectionScreen(ambience: ambience),
                ),
              );
            });
          }

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ambience.color.withOpacity(0.3),
                    AppColors.background,
                    AppColors.background,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // ── Top Bar ──
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                size: 28),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  AppColors.surface.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            'Session Active',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ── Breathing Animation ──
                    BreathingAnimation(color: ambience.color),

                    const SizedBox(height: 40),

                    // ── Title ──
                    Text(
                      ambience.title,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ambience.tag,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ambience.color,
                            fontWeight: FontWeight.w500,
                          ),
                    ),

                    const SizedBox(height: 48),

                    // ── Timer Display ──
                    Text(
                      session.remainingFormatted,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w200,
                        color: AppColors.textPrimary,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'remaining',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                            letterSpacing: 2,
                          ),
                    ),

                    const SizedBox(height: 32),

                    // ── Progress Bar ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: session.progress,
                              backgroundColor: AppColors.surfaceLight,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(ambience.color),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                session.elapsedFormatted,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(fontSize: 11),
                              ),
                              Text(
                                session.totalFormatted,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ── Controls ──
                    Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ── End Session ──
                          GestureDetector(
                            onTap: () => _showEndConfirmation(context),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.stop_rounded,
                                color: AppColors.accent,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // ── Play/Pause ──
                          GestureDetector(
                            onTap: session.togglePlayPause,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                session.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // ── Spacer for symmetry ──
                          const SizedBox(width: 56, height: 56),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEndConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text(
          'Are you sure you want to end this session early? You can still save a reflection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Continue',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              final session = context.read<SessionProvider>();
              final ambience = session.currentAmbience!;
              session.endSession();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ReflectionScreen(ambience: ambience),
                ),
              );
            },
            child: Text(
              'End Session',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
