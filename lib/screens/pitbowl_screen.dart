import 'package:flutter/material.dart';
import 'package:pitbowl/main.dart';

class PitbowlScreen extends StatefulWidget {
  const PitbowlScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PitbwolScreenState();
  }
}

class _PitbwolScreenState extends State<PitbowlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Pitbowl"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.money),
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
      )),
    );
  }
}
