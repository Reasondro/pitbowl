import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/model/pitch.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pitbowl/widgets/user_video_input.dart';

class NewPitchScreen extends ConsumerStatefulWidget {
  const NewPitchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewPitchScreenState();
  }
}

class _NewPitchScreenState extends ConsumerState<NewPitchScreen> {
  final TextEditingController _businessNameTextController =
      TextEditingController();
  final TextEditingController _businessCategoryTextController =
      TextEditingController();
  final TextEditingController _pitchTitleTextController =
      TextEditingController();
  final TextEditingController _pitchDescTextController =
      TextEditingController();

  File? _selectedVideo;

  @override
  void dispose() {
    _pitchTitleTextController.dispose();
    _pitchDescTextController.dispose();
    _businessNameTextController.dispose();
    _businessCategoryTextController.dispose();
    // _te

    super.dispose();
  }

  void _submitPitch() async {
    final String enteredBusinessName = _businessNameTextController.text.trim();
    final String enteredBusinessCategory =
        _businessCategoryTextController.text.trim();
    final String enteredPitchTitle = _pitchTitleTextController.text.trim();
    final String enteredPitchDesc = _pitchDescTextController.text.trim();

    if (enteredPitchTitle.isEmpty ||
        enteredPitchDesc.isEmpty ||
        enteredBusinessName.isEmpty ||
        enteredBusinessCategory.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You must fill the form for your pitch",
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
    } else if (_selectedVideo == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You must choose a video for your pitch",
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
    _businessNameTextController.clear();
    _businessCategoryTextController.clear();

    //todo impolement below code with user id and stuffs
    // final Reference storageRefPitch = FirebaseStorage.instance
    //     .ref()
    //     .child('user_pitches')
    //     .child(enteredPitchTitle)
    //     .child("$enteredPitchTitle Video.mp4");
    //todo make the user unique id as a child. so all of them in the same folder

    final Reference storageRefPitch = FirebaseStorage.instance
        .ref()
        .child('user_pitches_dummy')
        .child("$enteredPitchTitle Video.mp4");
    // await storageRefPitch.putString(
    //   enteredPitchDesc,
    //   metadata: SettableMetadata(
    //       customMetadata: {'Pitch description': enteredPitchDesc}),
    // );
    await storageRefPitch.putFile(
      _selectedVideo!,
      SettableMetadata(customMetadata: {
        'Business name': enteredBusinessName,
        'Business category': enteredBusinessCategory,
        'Pitch title': enteredPitchTitle,
        'Pitch description': enteredPitchDesc
      }),
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
              controller: _businessNameTextController,
              decoration: const InputDecoration(
                labelText: "Business name",
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _businessCategoryTextController,
              decoration: const InputDecoration(
                labelText: "Business category",
              ),
              // maxLength: 20,
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _pitchTitleTextController,
              decoration: const InputDecoration(
                labelText: "Pitch title",
              ),
              // maxLength: 30,
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _pitchDescTextController,
              decoration: const InputDecoration(
                labelText: "Pitch description",
              ),
              // maxLength: 50,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 15,
            ),
            VideoInput(onPickVideo: (video) {
              _selectedVideo = video;
            }),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary.withAlpha(25),
                ),
              ),
              onPressed: () {
                _submitPitch();
              },
              child: const Text("Pitch it!"),
            ),
          ],
        ),
      ),
    );
  }
}
