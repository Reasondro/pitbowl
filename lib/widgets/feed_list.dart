import 'package:flutter/material.dart';

class FeedList extends StatelessWidget {
  const FeedList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: Column(
            children: [
              const ListTile(
                title: Text("Random Username"),
                subtitle: Text("Category"),
                // trailing: IconButton(
                //   icon: Icon(Icons.more_vert),
                //   onPressed: () {},
                // ),
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
                    icon: const Icon(Icons.favorite_outline),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.mode_comment_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.paid,
                      // color: Color.fromARGB(255, 48, 197, 48),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
