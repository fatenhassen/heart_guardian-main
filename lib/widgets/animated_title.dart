import 'package:flutter/material.dart';

class AnimatedTitle extends StatelessWidget {
  final String text;
  final Animation<double> animation;

  const AnimatedTitle({super.key, required this.text, required this.animation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ScaleTransition(
        scale: animation,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Agbalumo',
            color: Color(0xFF042D46),
          ),
        ),
      ),
    );
  }
}