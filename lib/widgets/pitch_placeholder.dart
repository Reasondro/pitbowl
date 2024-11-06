import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPitchPlaceholder extends StatelessWidget {
  const ShimmerPitchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 66, 66, 66),
      highlightColor: const Color.fromARGB(255, 90, 90, 90),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmering box for Title
            Container(
              height: 20,
              width: 150,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            // Shimmering box for Video/Image
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            // Shimmering box for Date
            Container(
              height: 16,
              width: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            // Shimmering boxes for Description
            Container(
              height: 14,
              width: 200,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            Container(
              height: 14,
              width: double.infinity,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
