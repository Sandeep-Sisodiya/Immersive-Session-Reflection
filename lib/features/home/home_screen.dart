import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/ambience_provider.dart';
import '../../shared/providers/session_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import '../details/details_screen.dart';
import '../history/history_screen.dart';
import '../player/widgets/mini_player.dart';
import 'widgets/ambience_card.dart';
import 'widgets/filter_chips_bar.dart';

/// Main home screen showing list of ambiences with search and filter.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AmbienceProvider>().loadAmbiences();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // ── Main Content ──
            CustomScrollView(
              slivers: [
                // ── Header ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Immerse',
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Find your calm space',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                ),
                              ],
                            ),
                            // ── History Button ──
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HistoryScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.history_rounded,
                                  color: AppColors.textSecondary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // ── Search Bar ──
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              context
                                  .read<AmbienceProvider>()
                                  .setSearchQuery(value);
                            },
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search ambiences...',
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        context
                                            .read<AmbienceProvider>()
                                            .setSearchQuery('');
                                      },
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: AppColors.textMuted,
                                        size: 18,
                                      ),
                                    )
                                  : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // ── Filter Chips ──
                SliverToBoxAdapter(
                  child: Consumer<AmbienceProvider>(
                    builder: (context, provider, _) {
                      return FilterChipsBar(
                        tags: provider.availableTags,
                        selectedTag: provider.selectedTag,
                        onTagSelected: provider.setSelectedTag,
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // ── Ambience List ──
                Consumer<AmbienceProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }

                    if (provider.error != null) {
                      return SliverFillRemaining(
                        child: EmptyState(
                          icon: Icons.error_outline_rounded,
                          title: 'Oops!',
                          subtitle: provider.error!,
                        ),
                      );
                    }

                    if (provider.isEmpty) {
                      return const SliverFillRemaining(
                        child: EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'No ambiences found',
                          subtitle:
                              'Try a different search or clear your filters.',
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Add bottom padding for mini player
                            if (index == provider.ambiences.length) {
                              return const SizedBox(height: 100);
                            }
                            final ambience = provider.ambiences[index];
                            return AmbienceCard(
                              ambience: ambience,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailsScreen(ambience: ambience),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: provider.ambiences.length + 1,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // ── Mini Player ──
            Consumer<SessionProvider>(
              builder: (context, session, _) {
                if (!session.isActive) return const SizedBox.shrink();
                return const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MiniPlayer(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
