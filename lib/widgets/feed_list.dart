import 'package:flutter/material.dart';
import 'package:pitbowl/widgets/feed_item.dart';

class FeedList extends StatelessWidget {
  //todo required list of pitches from main screen
  const FeedList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const FeedItem();
      },
    );
  }
}
