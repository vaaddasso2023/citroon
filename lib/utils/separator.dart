import 'package:flutter/material.dart';

class SeparatorLineWithText extends StatelessWidget {
  final String text;
  final double lineThickness;
  final double textSize;
  final Color lineColor;
  final Color textColor;

  SeparatorLineWithText({
    required this.text,
    this.lineThickness = 1.0,
    this.textSize = 16.0,
    this.lineColor = Colors.grey,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: lineThickness,
            color: lineColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: textSize,
              color: textColor,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: lineThickness,
            color: lineColor,
          ),
        ),
      ],
    );
  }
}
