import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLike;

  const LikeButton({required this.onPressed, required this.isLike});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isLike ? Icons.favorite : Icons.close, size: 40),
      color: isLike ? Colors.red : Colors.grey,
      onPressed: onPressed,
    );
  }
}