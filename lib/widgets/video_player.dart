import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends ConsumerStatefulWidget {
  const VideoPlayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends ConsumerState<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 250,
      child: Text("This is a video"),
    );
  }
}
