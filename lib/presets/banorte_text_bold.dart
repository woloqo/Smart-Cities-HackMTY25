import 'package:flutter/material.dart';

class BanorteTextBold extends StatelessWidget {
  const BanorteTextBold(this.text, this.textColor,{super.key});

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Ghotam',
          fontSize: 25,
        ),
    );
  }
}