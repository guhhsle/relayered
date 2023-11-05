import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration speed;
  const AnimatedText({
    Key? key,
    required this.text,
    required this.speed,
    required this.style,
  }) : super(key: key);

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  bool paused = false;
  String title = '';

  @override
  Widget build(BuildContext context) {
    Stream titleStream = Stream.periodic(widget.speed);
    if (paused) {
      return Text(title, style: widget.style);
    }
    return StreamBuilder(
      stream: titleStream,
      builder: (context, snapshot) {
        if (title == widget.text) {
          Future.delayed(const Duration(milliseconds: 1), () {
            setState(() => paused = true);
          });
        } else {
          title = title + widget.text[title.length];
        }
        return Text(title, style: widget.style);
      },
    );
  }
}
