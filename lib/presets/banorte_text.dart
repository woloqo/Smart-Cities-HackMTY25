import 'package:flutter/material.dart';

class BanorteText extends StatelessWidget {
  const BanorteText(this.text, this.textColor, {super.key});

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Ghotam',
          fontSize: 15,
        ),
    );
  }
}