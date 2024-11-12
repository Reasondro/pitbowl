import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pitbowl/screens/auth_screen.dart';
import 'package:pitbowl/screens/pitbowl_screen.dart';
import 'package:pitbowl/widgets/user_video_input.dart';

class NewPitchScreen extends ConsumerStatefulWidget {
  const NewPitchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewPitchScreenState();
  }
}

class _NewPitchScreenState extends ConsumerState<NewPitchScreen> {
  final TextEditingController _businessCategoryTextController =
      TextEditingController();
  final TextEditingController _pitchTitleTextController =
      TextEditingController();
  final TextEditingController _pitchDescTextController =
      TextEditingController();

  File? _selectedVideo;
  bool _isUploading = false;

  @override
  void dispose() {
    _pitchTitleTextController.dispose();
    _pitchDescTextController.dispose();
    // _businessNameTextController.dispose();
    _businessCategoryTextController.dispose();
    // _te

    super.dispose();
  }

  void _submitPitch() async {
    final String enteredBusinessCategory =
        _businessCategoryTextController.text.trim();
    final String enteredPitchTitle = _pitchTitleTextController.text.trim();
    final String enteredPitchDesc = _pitchDescTextController.text.trim();

    if (enteredPitchTitle.isEmpty ||
        enteredPitchDesc.isEmpty ||
        enteredBusinessCategory.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You must fill the form for your pitch",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13),
            textAlign: TextAlign.left,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          dismissDirection: DismissDirection.horizontal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
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
                fontSize: 13),
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
    // _pitchTitleTextController.clear(); //? for now we clear this
    // _pitchDescTextController.clear();
    // _businessNameTextController.clear();
    // _businessCategoryTextController.clear();

    //todo impolement below code with user id and stuffs
    // final Reference storageRefPitch = FirebaseStorage.instance
    //     .ref()
    //     .child('user_pitches')
    //     .child(enteredPitchTitle)
    //     .child("$enteredPitchTitle Video.mp4");
    //todo make the user unique id as a child. so all of them in the same folder

    // await storageRefPitch.putString(
    //   enteredPitchDesc,
    //   metadata: SettableMetadata(
    //       customMetadata: {'Pitch description': enteredPitchDesc}),
    // );
    try {
      setState(() {
        _isUploading = true;
      });

      final Reference storageRefPitch = FirebaseStorage.instance
          .ref()
          .child('user_pitches_engpro')
          .child("$enteredPitchTitle Video.mp4");

      await storageRefPitch.putFile(
        _selectedVideo!,
        SettableMetadata(customMetadata: {
          // 'Business name': enteredBusinessName,
          'Business name': firebaseAuth.currentUser!.displayName!,
          'Business id': firebaseAuth.currentUser!.uid,
          'Business category': enteredBusinessCategory,
          'Pitch title': enteredPitchTitle,
          'Pitch description': enteredPitchDesc
        }),
      );
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars(); //? ⬇️ show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? "An error occurred!"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          // duration: Durations.long3,
          dismissDirection: DismissDirection.down,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
      );

      setState(() {
        _isUploading = false;
      });
    }

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
        title: const Text(
          "New Pitch",
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Business category",
                          style: TextStyle(
                              color: Color.fromARGB(255, 232, 235, 236),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: _businessCategoryTextController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 207, 218, 218)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 216, 216, 216)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pitch title",
                          style: TextStyle(
                              color: Color.fromARGB(255, 232, 235, 236),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: _pitchTitleTextController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 207, 218, 218)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 216, 216, 216)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pitch description",
                          style: TextStyle(
                              color: Color.fromARGB(255, 232, 235, 236),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: _pitchDescTextController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 207, 218, 218)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 216, 216, 216)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  VideoInput(onPickVideo: (video) {
                    _selectedVideo = video;
                  }),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.aspect_ratio,
                      color: Colors.black,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary.withAlpha(255)),
                    ),
                    onPressed: () {
                      _submitPitch();
                    },
                    label: const Text(
                      "Pitch it!",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            if (_isUploading)
              Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
