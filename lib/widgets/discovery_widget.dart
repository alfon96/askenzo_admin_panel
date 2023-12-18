import 'package:askenzo_admin_panel/models/discovery.dart';
import 'package:flutter/material.dart';

/// The `DiscoveryWidget` class is a stateless widget that displays the ID and title of a discovery in a
/// horizontal row.
class DiscoveryWidget extends StatelessWidget {
  const DiscoveryWidget({super.key, required this.discovery});
  final UpdateDiscoveryModel discovery;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text('${discovery.id}'),
            const SizedBox(width: 5),
            Text(discovery.title),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
