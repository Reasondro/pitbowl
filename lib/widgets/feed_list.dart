import 'package:flutter/material.dart';
import 'package:pitbowl/widgets/feed_item.dart';
import 'package:pitbowl/model/pitch.dart';

class FeedList extends StatelessWidget {
  //todo required list of pitches from main screen

  const FeedList({super.key, required this.pitches});
  final List<Pitch> pitches;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pitches.length,
      itemBuilder: (context, index) {
        return  FeedItem(pitch: pitches[index],);
      },
    );
  }
}
