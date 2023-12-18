import 'package:flutter/material.dart';

/// The `CustomWaitingWidget` class is a widget that displays a loading indicator on top of another
/// widget when `isWaiting` is true.
class CustomWaitingWidget extends StatelessWidget {
  const CustomWaitingWidget(
      {super.key,
      required this.isWaiting,
      required this.child,
      this.alignment = Alignment.center});

  final bool isWaiting;
  final Widget child;
  final Alignment alignment;
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: alignment, children: [
      child,
      if (isWaiting)
        Center(
          child: Transform.scale(
            scale: 1.5,
            child: const CircularProgressIndicator(),
          ),
        )
    ]);
  }
}
