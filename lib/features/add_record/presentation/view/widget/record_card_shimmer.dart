import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecordCardShimmer extends StatelessWidget {
  const RecordCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 40, height: 16, color: Colors.white),
                Container(width: 100, height: 16, color: Colors.white),
                Icon(Icons.more_vert, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
