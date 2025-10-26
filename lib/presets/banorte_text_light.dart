import 'package:flutter/material.dart';

class BanorteTextLight extends StatelessWidget {
  const BanorteTextLight(this.text, this.textColor, {super.key});

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.normal,
          fontFamily: 'Ghotam',
          fontSize: 15,
        ),
    );
  }
}