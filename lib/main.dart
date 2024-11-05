import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:pitbowl/screens/auth_screen.dart';
import 'package:pitbowl/screens/splash_screen.dart';
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
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      titleLarge:
          GoogleFonts.alfaSlabOne(fontWeight: FontWeight.w300, fontSize: 35),
      titleMedium:
          GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 30),
      labelSmall:
          GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 15),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.black,
      foregroundColor: pitbowlColorTheme.primary,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.black,
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
        title: 'Pitbowl',
        theme: pitbowlTheme,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData) {
                return const PitbowlScreen();
              }
              return const AuthScreen();
            })
        // const AuthScreen()
        // const PitbowlScreen(),
        // home: const NewPostScreen(),
        // home: const FeedList(),
        // ,initialRoute: , //todo , try to learn from sanudi project
        );
  }
}
