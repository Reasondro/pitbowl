import 'package:flutter/material.dart';
import 'package:pitbowl/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/model/pitch.dart';
import 'package:pitbowl/screens/new_pitch_screen.dart';
import 'package:pitbowl/widgets/feed_list.dart';

import 'package:firebase_storage/firebase_storage.dart';

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

  @override
  void initState() {
    super.initState();
    loadFile();
  }

  List<Pitch> pitches = [];

  Future<void> loadFile() async {
    setState(() {
      pitches.clear();
    });
    // final firebaseStorageRef = FirebaseStorage.instance
    //     .ref()
    //     .child('user_pitches')
    //     .child('BBL DRIZZY')
    //     .child('BBL DRIZZY Video.mp4');

    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('user_pitches_dummy');

    final listResult = await firebaseStorageRef.listAll();
    var metadata;
    var downloadURL;
    var pitchBusinessName;
    var businessCategory;
    var pitchTitle;
    var pitchDescription;

    Pitch pitch;
    for (var ref in listResult.items) {
      // print('Found file: ${ref.name}');
      downloadURL = await ref.getDownloadURL();
      metadata = await ref.getMetadata();
      pitchBusinessName = metadata.customMetadata!['Business name'];
      businessCategory = metadata.customMetadata!['Business category'];
      pitchTitle = metadata.customMetadata!['Pitch title'];
      pitchDescription = metadata.customMetadata!['Pitch description'];
      print('Download URL: $downloadURL');
      print('Business name: $pitchBusinessName');
      print('Business category: $businessCategory');
      print('Pitch title: $pitchTitle');
      print('Pitch description: $pitchDescription');

      pitch = Pitch(
          username: pitchBusinessName,
          category: businessCategory,
          title: pitchTitle,
          desc: pitchDescription,
          videoPitchUrl: downloadURL);

      setState(() {
        pitches.add(pitch);
        //  pitches = pitches.reversed.toList();
        // pitches = [pitch, ...pitches];
      });
    }

    // final downloadURL = await firebaseStorageRef.getDownloadURL();

    // print('Download URL: $downloadURL');
    // final metadata = await firebaseStorageRef.getMetadata();
    // final pitchDescription = metadata.customMetadata!['Pitch description'];
    // print(
    //     'Pitch description: ${metadata.customMetadata!['Pitch description']}');
    print('Pitches: $pitches');
  }

  void _postNewPitch() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NewPitchScreen()));
  }

  void _selectScreen(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = FeedList(pitches: pitches);

    if (currentScreenIndex == 0) {
      activeScreenTitle = "PITBOWL";
      content = FeedList(
        pitches: pitches,
      );
    } else if (currentScreenIndex == 1) {
      activeScreenTitle = "Market";
      content = Text(
        "You can search here",
        style: TextStyle(
            fontSize: 20, color: pitbowlColorTheme.copyWith().onSurface),
      );
    } else if (currentScreenIndex == 3) {
      activeScreenTitle = "Your Portfolio";
      content = Text(
        "Some random chart here",
        style: TextStyle(
            fontSize: 20, color: pitbowlColorTheme.copyWith().onSurface),
      );
    } else if (currentScreenIndex == 4) {
      activeScreenTitle = "You";
      content = Text(
        "Some random profile content",
        style: TextStyle(
            fontSize: 20, color: pitbowlColorTheme.copyWith().onSurface),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          activeScreenTitle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              loadFile();
            },
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadFile,
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: content),
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
              label: "Pitch!",
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
