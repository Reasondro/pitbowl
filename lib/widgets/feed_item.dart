import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/widgets/invest_sheet.dart';
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

  void openInvestSheetOverlay(
    BuildContext context,
  ) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return InvestSheet(pitch: widget.pitch);
      },
    );
  }

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
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
            contentPadding: const EdgeInsets.only(left: 8),
          ),
          SizedBox(
            width: double.infinity,
            height: 250,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
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
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          height: _controller.value.size.height,
                          width: _controller.value.size.width,
                          child: VideoPlayer(_controller),
                        ),
                      ),
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
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.pitch.title,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
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
                color: isFavorite
                    ? Colors.red
                    : Theme.of(context).colorScheme.secondary,
                icon: isFavorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
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
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary.withAlpha(255)),
                  ),
                  onPressed: () {
                    openInvestSheetOverlay(context);
                  },
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
                    // color: Color.fromARGB(255, 48, 198, 48),
                    // color: Theme.of(context).colorScheme.onPrimary,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
