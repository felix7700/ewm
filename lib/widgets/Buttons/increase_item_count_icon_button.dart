import 'package:flutter/material.dart';

class IncreaseItemCountIconButton extends StatelessWidget {
  const IncreaseItemCountIconButton(
      {required this.color, required this.increaseItemCountFunction, Key? key})
      : super(key: key);
  final Color color;
  final Function increaseItemCountFunction;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.add_circle_rounded,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      color: color,
      onPressed: () => increaseItemCountFunction(),
    );
  }
}
