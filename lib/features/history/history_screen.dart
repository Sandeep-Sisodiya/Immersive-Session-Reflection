import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/journal_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/journal_card.dart';
import 'widgets/journal_detail_sheet.dart';

/// Displays the history of saved reflection entries.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JournalProvider>().loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflection History'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Consumer<JournalProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.isEmpty) {
            return const EmptyState(
              icon: Icons.book_outlined,
              title: 'No reflections yet',
              subtitle:
                  'Complete a session and write your thoughts to see them here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            itemCount: provider.entries.length,
            itemBuilder: (context, index) {
              final entry = provider.entries[index];
              return JournalCard(
                entry: entry,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => JournalDetailSheet(entry: entry),
                  );
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Entry?'),
                      content: const Text(
                          'This reflection will be permanently removed.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text('Cancel',
                              style:
                                  TextStyle(color: AppColors.textSecondary)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text('Delete',
                              style: TextStyle(color: AppColors.accent)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    provider.deleteEntry(entry.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
