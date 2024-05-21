import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedItem extends ConsumerStatefulWidget {
  const FeedItem({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FeedItemState();
  }
}

class _FeedItemState extends ConsumerState<FeedItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Column(
        children: [
          ListTile(
            title: Text("Random Username"),
            subtitle: Text("Category"),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
            contentPadding: const EdgeInsets.only(left: 10),
          ),
          Image.network(
            "https://via.placeholder.com/250",
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
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
