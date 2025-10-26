import 'package:flutter/material.dart';
import 'package:prototipo/presets/banorte_text.dart';
import 'package:prototipo/presets/banorte_text_bold.dart';
import 'package:prototipo/presets/banorte_text_light.dart';

import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            //Fondo rojo
            fondoRojo(size: size),
            //Logo Banorte
            logoBanorte(size),
            
            // <--- CORRECCIÓN 1: ENVUELVE LA COLUMNA CON UN SCROLL
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.35),
                  
                  form(context), 
                  
                  SizedBox(height: 30),
                  BanorteTextLight('Crear una cuenta', Color(0xFF566670)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container form(BuildContext context) { 
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          SizedBox(height: 20),
          BanorteTextBold('Bienvenido a Banorte Movil', Color(0xFF000000)),
          SizedBox(height: 10),
          BanorteTextLight('Por favor, inicie sesión para continuar', Color(0xFF5B6670)),
          SizedBox(height: 190),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      hintText: 'ejemplo@gmail.com',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      return EmailValidator.validate(value.toString())
                          ? null
                          : 'El valor ingresado no es un correo electronico';
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      hintText: '********',
                      prefixIcon: Icon(Icons.key),
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(onPressed:  () {
                    
                    Navigator.pushReplacementNamed(context,'home'); 
                  
                  },
                  disabledColor: Color(0xFF566670),
                    color: Color(0xFFEB0029),
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const BanorteText('Iniciar Sesión', Colors.black),
                  ),
                ],
              ),
            )
          ),
          
          // Agregamos un padding al final para que el botón no quede pegado
          SizedBox(height: 20), 

        ],
      )
    // ) // Cierre del SingleChildScrollView que quitamos
    );
  }

  Padding logoBanorte(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.15),
      child: SizedBox(
        width: double.infinity,
        child: Image.asset('images/logo_banorte_blanco.png'),
      ),
    );
  }
}

class fondoRojo extends StatelessWidget {
  const fondoRojo({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEB0029),
      width: double.infinity,
      height: size.height * 0.4,
    );
  }
}