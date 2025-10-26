import 'package:flutter/material.dart';

import 'package:prototipo/menu/account.dart';
import 'package:prototipo/menu/principal.dart';
import 'package:prototipo/menu/settings.dart';
import 'package:prototipo/menu/salud_financiera.dart';
import 'package:prototipo/menu/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 2;
  
  final List<Widget> pages = [
    Account(),
    SaludFinanciera(),
    Principal(),
    Services(),
    Settings(),
  ];

  // Esta función manejará el clic
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Image.asset('images/logo_banorte_blanco.png', width: 150, height: 150),
        backgroundColor: const Color(0xFFEB0029),
        centerTitle: true,
      ),
      
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        // ----- LA LÓGICA -----
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Cuenta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Finanzas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page_sharp),
            label: 'Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,

        type: BottomNavigationBarType.fixed, 
        backgroundColor: const Color(0xFFEB0029),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF000000),
      ),
    );
  }
}