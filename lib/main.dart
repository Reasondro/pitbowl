import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:pitbowl/screens/auth_screen.dart';
import 'package:pitbowl/widgets/feed_list.dart';
import 'firebase_options.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:pitbowl/screens/pitbowl_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/screens/new_pitch_screen.dart';

final ColorScheme pitbowlColorTheme = ColorScheme.fromSeed(
    // seedColor: const Color.fromARGB(255, 48, 0, 104),
    // seedColor: const Color.fromARGB(255, 255, 227, 135),
    seedColor: const Color.fromARGB(255, 135, 255, 249),
    brightness: Brightness.dark);

final ThemeData pitbowlTheme = ThemeData().copyWith(
    colorScheme: pitbowlColorTheme,
    textTheme: GoogleFonts.alegreyaSansTextTheme().copyWith(
      titleLarge:
          GoogleFonts.alfaSlabOne(fontWeight: FontWeight.w300, fontSize: 35),
      titleMedium:
          GoogleFonts.alegreyaSans(fontWeight: FontWeight.bold, fontSize: 30),
      labelSmall:
          GoogleFonts.alegreyaSans(fontWeight: FontWeight.bold, fontSize: 15),
    ),
    appBarTheme: AppBarTheme(
      // color: const Color.fromARGB(255, 41, 0, 94),
      // color: Colors.white,
      color: Colors.black,
      // foregroundColor: Color.fromARGB(255, 41, 0, 94),
      // foregroundColor: Color.fromARGB(255, 172, 154, 55),
      foregroundColor: pitbowlColorTheme.primary,
    ),
    navigationBarTheme: NavigationBarThemeData(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.black,
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
    // scaffoldBackgroundColor: Colors.white
    scaffoldBackgroundColor: Colors.black);

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
        title: 'Pitbowl', theme: pitbowlTheme, home: const AuthScreen()
        // const PitbowlScreen(),
        // home: const NewPostScreen(),
        // home: const FeedList(),
        // ,initialRoute: , //todo , try to learn from sanudi project
        );
  }
}
