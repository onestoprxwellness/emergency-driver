import 'package:flutter/material.dart';

class TranslatableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  
  const TranslatableText({
    Key? key,
    required this.text,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
