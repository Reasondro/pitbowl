import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pitbowl/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/model/pitch.dart';
import 'package:pitbowl/screens/new_pitch_screen.dart';
import 'package:pitbowl/screens/splash_screen.dart';
import 'package:pitbowl/widgets/feed_list.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitbowl/widgets/market.dart';
import 'package:pitbowl/widgets/pitch_placeholder.dart';
import 'package:pitbowl/screens/auth_screen.dart';
import 'package:pitbowl/widgets/user_portfolio.dart';
import 'package:pitbowl/widgets/user_profile.dart';

class PitbowlScreen extends ConsumerStatefulWidget {
  const PitbowlScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PitbwolScreenState();
  }
}

class _PitbwolScreenState extends ConsumerState<PitbowlScreen> {
  String activeScreenTitle = "PITBOWL";
  int currentScreenIndex = 0;
  String username = "User";

  @override
  void initState() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      username = currentUser.displayName!;
    }

    super.initState();
    loadFile();
  }

  Future<void> _signOut() async {
    await ref.read(firebaseAuthProvider).signOut();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You have been signed out."),
        backgroundColor: Colors.blue,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  List<Pitch> pitches = [];
  bool isLoading = false;

  Future<void> loadFile() async {
    setState(() {
      isLoading = true;
      pitches.clear();
    });

    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('user_pitches_engpro');

    final listResult = await firebaseStorageRef.listAll();
    FullMetadata metadata;
    String downloadURL;
    String? pitchBusinessName;
    String? pitchBusinessId = "default id";
    String? businessCategory;
    String? pitchTitle;
    String? pitchDescription;
    DateTime? creationTime;

    Pitch pitch;
    List<Pitch> loadedPitches = [];
    for (var ref in listResult.items) {
      // print('Found file: ${ref.name}');
      downloadURL = await ref.getDownloadURL();
      metadata = await ref.getMetadata();
      pitchBusinessName = metadata.customMetadata!['Business name'];

      pitchBusinessId = metadata.customMetadata!["Business id"];

      businessCategory = metadata.customMetadata!['Business category'];
      pitchTitle = metadata.customMetadata!['Pitch title'];
      pitchDescription = metadata.customMetadata!['Pitch description'];
      creationTime = metadata.timeCreated!;

      pitch = Pitch(
          username: pitchBusinessName!,
          id: pitchBusinessId,
          category: businessCategory!,
          title: pitchTitle!,
          desc: pitchDescription!,
          videoPitchUrl: downloadURL,
          creationTime: creationTime);

      loadedPitches.add(pitch);
    }

    loadedPitches.sort((a, b) => b.creationTime!.compareTo(a.creationTime!));

    setState(() {
      pitches = loadedPitches;
      isLoading = false;
    });
  }

  void _postNewPitch() async {
    await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NewPitchScreen()))
        .then((_) => loadFile());
  }

  void _selectScreen(int index) {
    setState(() {
      if (index == 2) {
        return;
      }
      currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = FeedList(pitches: pitches);

    if (currentScreenIndex == 0) {
      activeScreenTitle = "PITBOWL";
      content = isLoading
          ? ListView.builder(
              itemCount: 5, // Number of shimmer placeholders
              itemBuilder: (context, index) {
                return const ShimmerPitchPlaceholder();
              },
            )
          : FeedList(
              pitches: pitches,
            );
    } else if (currentScreenIndex == 1) {
      activeScreenTitle = "Market";
      // content =
      // Text(
      //   "You can search here",
      //   style: TextStyle(
      //       fontSize: 20, color: pitbowlColorTheme.copyWith().onSurface),
      // );
      content = const MarketScreen();
    } else if (currentScreenIndex == 3) {
      activeScreenTitle = "Your Portfolio";
      // content = Text(
      //   "Some random chart here",
      //   style: TextStyle(
      //       fontSize: 20, color: pitbowlColorTheme.copyWith().onSurface),
      // );
      content = UserPortfolio(username: username);
    } else if (currentScreenIndex == 4) {
      activeScreenTitle = username;
      content =
          //     IconButton(
          //   onPressed: () {
          //     _firebaseAuth.signOut();
          //     ScaffoldMessenger.of(context).clearSnackBars();
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         content: Text(
          //           "You have been signed out",
          //           style: TextStyle(
          //               color: Theme.of(context).colorScheme.onPrimary,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 15),
          //           textAlign: TextAlign.left,
          //         ),
          //         backgroundColor: Theme.of(context).colorScheme.primary,
          //         dismissDirection: DismissDirection.horizontal,
          //         shape: const RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(7)),
          //         ),
          //       ),
          //     );
          //   },
          //   icon: const Icon(Icons.exit_to_app_outlined),
          //   color: Theme.of(context).colorScheme.onError,
          // );
          const UserProfile();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          activeScreenTitle,
          style: TextStyle(
            fontFamily: currentScreenIndex == 0
                ? GoogleFonts.ibarraRealNova().fontFamily
                : GoogleFonts.dmSans().fontFamily,
          ),
        ),
        actions: [
          if (currentScreenIndex != 4)
            IconButton(
              onPressed: () {
                // loadFile();
              },
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          if (currentScreenIndex == 4)
            IconButton(
              onPressed: () {
                _signOut();
              },
              icon: Icon(
                Icons.exit_to_app_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
      body: currentScreenIndex == 0
          ? RefreshIndicator(
              onRefresh: loadFile,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: content,
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: content,
              ),
            ),
      bottomNavigationBar: NavigationBar(
          // indicatorColor: ThemeData().colorScheme.primary,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            NavigationDestination(
              icon: Icon(Icons.movie_creation_outlined),
              label: "Pitch",
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_rounded),
              label: "Portfolio",
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle),
              label: "You",
            ),
          ],
          selectedIndex: currentScreenIndex,
          onDestinationSelected: (index) {
            _selectScreen(index);
            switch (index) {
              case 2:
                _postNewPitch();
                break;
              default:
                break;
            }
          }),
    );
  }
}
