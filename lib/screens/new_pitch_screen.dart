import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/model/pitch.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class NewPitchScreen extends ConsumerStatefulWidget {
  const NewPitchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewPitchScreenState();
  }
}

class _NewPitchScreenState extends ConsumerState<NewPitchScreen> {
  final TextEditingController _pitchTitleTextController =
      TextEditingController();
  final TextEditingController _pitchDescTextController =
      TextEditingController();

  @override
  void dispose() {
    _pitchTitleTextController.dispose();
    _pitchDescTextController.dispose();
    // _te

    super.dispose();
  }

  void _submitPitch() async {
    final String enteredPitchTitle = _pitchTitleTextController.text;
    final String enteredPitchDesc = _pitchDescTextController.text;

    if (enteredPitchTitle.trim().isEmpty && enteredPitchDesc.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You must fill the title and the description of your pitch",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15),
            textAlign: TextAlign.left,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          dismissDirection: DismissDirection.horizontal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
      );
      return;
    } else if (enteredPitchTitle.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You must fill the title of your pitch",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15),
            textAlign: TextAlign.left,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          dismissDirection: DismissDirection.horizontal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
      );
      return;
    } else if (enteredPitchDesc.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You must fill the title of your pitch",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15),
            textAlign: TextAlign.left,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          dismissDirection: DismissDirection.horizontal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
      );
      return;
    }

    //? if succefully filled
    FocusScope.of(context).unfocus();
    _pitchTitleTextController.clear();
    _pitchDescTextController.clear();

    final Reference storageRefPitch = FirebaseStorage.instance
        .ref()
        .child('user_pitches')
        .child(enteredPitchTitle);
    //todo make the user unique id as a child. so all of them in the same folder

    await storageRefPitch.putString(
      enteredPitchDesc,
      metadata: SettableMetadata(
          customMetadata: {'Pitch description': enteredPitchDesc}),
    );

    //     final String downloadURL = await storageRefPitch.getDownloadURL();
    // final http.Response downloadData = await http.get(Uri.parse(downloadURL));

    // print('File contents: ${downloadData.body}');
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        // leading: Padding(
        //   padding: const EdgeInsets.all(0), // Set padding to 0
        //   child: IconButton(
        //     icon: Icon(Icons.arrow_back, size: 30.0),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        // ),
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
              controller: _pitchTitleTextController,
              decoration: const InputDecoration(
                labelText: "Pitch title",
              ),
            ),
            TextField(
              controller: _pitchDescTextController,
              decoration: const InputDecoration(
                labelText: "Pitch description",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _submitPitch();
              },
              child: const Text("Pitch"),
            ),
          ],
        ),
      ),
    );
  }
}
