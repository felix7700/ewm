import 'package:flutter/material.dart';

class EditItemIconButton extends StatelessWidget {
  const EditItemIconButton(
      {required this.itemId, required this.color, Key? key})
      : super(key: key);
  final int itemId;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 16.0,
      icon: const Icon(Icons.edit),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      color: color,
      onPressed: () {
        debugPrint('edit Item');
      },
    );
  }
}
