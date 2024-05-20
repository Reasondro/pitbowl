import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/model/pitch.dart';
import 'dart:io';

class NewPitchScreen extends ConsumerStatefulWidget {
  const NewPitchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewPitchScreenState();
  }
}

class _NewPitchScreenState extends ConsumerState<NewPitchScreen> {
  final TextEditingController _postTextController = TextEditingController();
  final TextEditingController _postImageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(0), // Set padding to 0
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 30.0),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        // automaticallyImplyLeading: false,
        title: const Text(
          "New Pitch",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _postTextController,
              decoration: const InputDecoration(
                labelText: "Pitch title",
              ),
            ),
            TextField(
              controller: _postImageController,
              decoration: const InputDecoration(
                labelText: "Pitch image",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final pitch = Pitch(
                  title: _postTextController.text,
                  desc: _postTextController.text,
                  username: "username",
                  userProfilePicture: File(""),
                  videoPitch: File(""),
                );
                // context.read(userPostsProvider).addPost(post);
                Navigator.pop(context);
              },
              child: const Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
