import 'package:flutter/material.dart';

class DislikeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DislikeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close, size: 40),
      color: Colors.grey,
      onPressed: onPressed,
    );
  }
}