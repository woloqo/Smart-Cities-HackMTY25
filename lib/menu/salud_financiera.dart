import 'package:flutter/material.dart';

class SaludFinanciera extends StatefulWidget {
  const SaludFinanciera({super.key});

  @override
  State<SaludFinanciera> createState() => _SaludFinancieraState();
}

class _SaludFinancieraState extends State<SaludFinanciera> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Salud Financiera Page Content'),
    );
  }
}