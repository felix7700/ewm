import 'package:flutter/material.dart';

class IncreaseItemCountIconButton extends StatelessWidget {
  const IncreaseItemCountIconButton(
      {required this.itemId,
      required this.color,
      required this.buttonPressed,
      Key? key})
      : super(key: key);
  final int itemId;
  final Color color;
  final Function buttonPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.add_circle_rounded,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      color: color,
      onPressed: () => buttonPressed(itemId),
    );
  }
}
