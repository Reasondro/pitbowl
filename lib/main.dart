import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:pitbowl/widgets/feed_list.dart';
import 'firebase_options.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:pitbowl/screens/pitbowl_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/screens/new_pitch_screen.dart';

final ColorScheme pitbowlColorTheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 48, 0, 104),
    brightness: Brightness.light);

final ThemeData pitbowlTheme = ThemeData().copyWith(
    colorScheme: pitbowlColorTheme,
    textTheme: GoogleFonts.alegreyaSansTextTheme().copyWith(
      titleLarge:
          GoogleFonts.alegreyaSans(fontWeight: FontWeight.bold, fontSize: 35),
      titleMedium:
          GoogleFonts.alegreyaSans(fontWeight: FontWeight.bold, fontSize: 30),
      labelSmall:
          GoogleFonts.alegreyaSans(fontWeight: FontWeight.bold, fontSize: 10),
    ),
    appBarTheme: const AppBarTheme(
      // color: const Color.fromARGB(255, 41, 0, 94),
      color: Colors.white,
      foregroundColor: Color.fromARGB(255, 41, 0, 94),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      // indicatorColor: const Color.fromARGB(255, 41, 0, 94),
      indicatorColor: pitbowlColorTheme.secondaryContainer,
      indicatorShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          color: pitbowlColorTheme.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.white);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitbowl',
      theme: pitbowlTheme,
      home: const PitbowlScreen(),
      // home: const NewPostScreen(),
      // home: const FeedList(),
      // ,initialRoute: , //todo , try to learn from sanudi project
    );
  }
}
