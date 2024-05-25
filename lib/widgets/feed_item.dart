import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:pitbowl/model/pitch.dart';

class FeedItem extends ConsumerStatefulWidget {
  const FeedItem({super.key, required this.pitch});

  final Pitch pitch;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FeedItemState();
  }
}

class _FeedItemState extends ConsumerState<FeedItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(
      widget.pitch.videoPitchUrl,
    ));
    // _controller = VideoPlayerController();
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.pitch.username),
            subtitle: Text(widget.pitch.category),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
            contentPadding: const EdgeInsets.only(left: 10),
          ),
          SizedBox(
            width: double.infinity,
            height: 250,
            child:  FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
             
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child:  Text(
             widget.pitch.title,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              widget.pitch.desc,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                color: Theme.of(context).colorScheme.secondary,
                icon: const Icon(Icons.favorite_outline),
                onPressed: () {},
              ),
              IconButton(
                color: Theme.of(context).colorScheme.secondary,
                icon: const Icon(Icons.mode_comment_outlined),
                onPressed: () {},
              ),
              IconButton(
                color: Theme.of(context).colorScheme.secondary,
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary.withAlpha(255)),
                ),
                onPressed: () {},
                label: const Text(
                  "Invest",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      // color: Theme.of(context).colorScheme.onPrimary),
                      color: Colors.black),
                ),
                icon: const Icon(
                  Icons.paid,
                  // color: Color.fromARGB(255, 48, 197, 48),
                  // color: Theme.of(context).colorScheme.onPrimary,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
