import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:pitbowl/screens/pitbowl_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme pitbowlColorTheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 48, 0, 104),
    brightness: Brightness.light);

final ThemeData pitbowlTheme = ThemeData().copyWith(
    colorScheme: pitbowlColorTheme,
    textTheme: GoogleFonts.alegreyaSansTextTheme(),
    appBarTheme: AppBarTheme(
      color: const Color.fromARGB(255, 41, 0, 94),
      foregroundColor: pitbowlColorTheme.copyWith().onPrimary,
    ),
    scaffoldBackgroundColor: Colors.white);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitbowl',
      theme: pitbowlTheme,
      home: const PitbowlScreen(),
    );
  }
}
