import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoInput extends ConsumerStatefulWidget {
  const VideoInput({super.key, required this.onPickVideo});

  final void Function(File video) onPickVideo;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VideoInputState();
  }
}

class _VideoInputState extends ConsumerState<VideoInput> {
  File? _selectedVideo;

  void _chooseVideo() async {
    final ImagePicker videoPicker = ImagePicker();

    final pickedVideo =
        await videoPicker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo == null) {
      return;
    }
    setState(() {
      _selectedVideo = File(pickedVideo.path);
    });

    widget.onPickVideo(_selectedVideo!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: () {
          _chooseVideo();
        },
        icon: const Icon(Icons.video_camera_back_outlined),
        label: const Text("Take a video"));

    if (_selectedVideo != null) {
      content = GestureDetector(
          onTap: () {
            _chooseVideo();
          },
          child: Text(_selectedVideo.toString())
          // Image.file(
          //   _selectedVideo!,
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          );
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: content);
  }
}
