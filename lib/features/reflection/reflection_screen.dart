import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/ambience.dart';
import '../../data/models/journal_entry.dart';
import '../../shared/providers/journal_provider.dart';
import '../../shared/providers/session_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/mood_chip.dart';

/// Post-session reflection screen with text input and mood selection.
class ReflectionScreen extends StatefulWidget {
  final Ambience ambience;

  const ReflectionScreen({super.key, required this.ambience});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _reflectionController = TextEditingController();
  int _selectedMoodIndex = 0;
  bool _isSaving = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _saveReflection() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    final session = context.read<SessionProvider>();

    await context.read<JournalProvider>().addEntry(
          ambienceId: widget.ambience.id,
          ambienceTitle: widget.ambience.title,
          reflection: _reflectionController.text.trim().isEmpty
              ? 'No reflection added.'
              : _reflectionController.text.trim(),
          moodIndex: _selectedMoodIndex,
          sessionDurationSeconds: session.elapsedSeconds,
        );

    session.resetSession();

    if (mounted) {
      // Pop all the way back to home
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded,
                  color: AppColors.moodGrounded, size: 20),
              const SizedBox(width: 10),
              const Text('Reflection saved ✨'),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.ambience.color.withOpacity(0.15),
                AppColors.background,
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // ── Header ──
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.primaryLight,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Session Complete',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'How are you feeling after "${widget.ambience.title}"?',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textMuted),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // ── Scrollable Body ──
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Mood Selection ──
                          Text(
                            'Your Mood',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: Mood.values.map((mood) {
                              return MoodChip(
                                mood: mood,
                                isSelected: _selectedMoodIndex == mood.index,
                                onTap: () {
                                  setState(
                                      () => _selectedMoodIndex = mood.index);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),

                          // ── Reflection Text ──
                          Text(
                            'Reflection',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Write anything that comes to mind…',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _reflectionController,
                              maxLines: 6,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                height: 1.6,
                              ),
                              decoration: const InputDecoration(
                                hintText:
                                    'What thoughts or feelings came up during the session?',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.all(18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // ── Save Button ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        24, 12, 24, MediaQuery.of(context).padding.bottom + 24),
                    child: GestureDetector(
                      onTap: _saveReflection,
                      child: Container(
                        width: double.infinity,
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
                        child: Center(
                          child: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.save_rounded,
                                        color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Save Reflection',
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
