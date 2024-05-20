import 'package:flutter/material.dart';
import 'package:pitbowl/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PitbowlScreen extends ConsumerStatefulWidget {
  const PitbowlScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PitbwolScreenState();
  }
}

class _PitbwolScreenState extends ConsumerState<PitbowlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pitbowl"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            "Your screen",
            style: TextStyle(
                fontSize: 20, color: pitbowlColorTheme.copyWith().onSurface),
          ),
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
            icon: Icon(Icons.add),
            label: "Add",
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (index) {},
      ),
    );
  }
}
