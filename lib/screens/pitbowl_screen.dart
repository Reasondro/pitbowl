import 'package:flutter/material.dart';
import 'package:pitbowl/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/screens/new_pitch_screen.dart';
import 'package:pitbowl/widgets/feed_list.dart';

class PitbowlScreen extends ConsumerStatefulWidget {
  const PitbowlScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PitbwolScreenState();
  }
}

class _PitbwolScreenState extends ConsumerState<PitbowlScreen> {
  int currentScreenIndex = 0;

  void _postNewPitch() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NewPitchScreen()));
  }

  Widget content = const FeedList();

  void _selectScreen(int index) {
    setState(() {
      currentScreenIndex = index;
    });
    if (currentScreenIndex == 0) {
      activeScreenTitle = "Pitbowl";
      content = const FeedList();
    } else if (currentScreenIndex == 1) {
      activeScreenTitle = "Browse the Market";
      content = Text(
        "You can search here",
        style: TextStyle(
            fontSize: 20, color: pitbowlColorTheme.copyWith().onSurface),
      );
    } else if (currentScreenIndex == 2) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      _postNewPitch();
      // });
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
  }

  String activeScreenTitle = "Pitbowl";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activeScreenTitle),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active),
          ),
        ],
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: content),
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
        },
      ),
    );
  }
}
