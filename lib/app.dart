import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/providers/ambience_provider.dart';
import 'shared/providers/session_provider.dart';
import 'shared/providers/journal_provider.dart';
import 'shared/theme/app_theme.dart';
import 'features/home/home_screen.dart';

/// Root widget that configures providers, theme, and navigation.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AmbienceProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
      ],
      child: MaterialApp(
        title: 'Immerse',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
