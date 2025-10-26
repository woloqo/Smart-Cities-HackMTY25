import 'package:flutter/material.dart';
import 'package:prototipo/presets/banorte_text.dart';
import 'package:prototipo/presets/banorte_text_bold.dart';
import 'package:prototipo/presets/banorte_text_light.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    // Usamos SingleChildScrollView para que la pantalla se pueda deslizar
    // si el historial de compras es muy largo.
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
              child: BanorteTextBold('¡Bienvenid@ a tu banca móvil!', Colors.black ),
            ),
          ),

          const SizedBox(height: 10),

          // 1. Widget para el Saldo de la Cuenta
          _buildSaldoBox(), // <-- ESTE ES EL WIDGET MODIFICADO

          const SizedBox(height: 10),

          // 2. Widget para los Botones de Acción
          _buildActionButtons(),

          const SizedBox(height: 10),

          // 3. Widget para el Historial de Compras (desplegable)
          _buildHistoryTile(),

          const SizedBox(height: 20), // Un espacio al final
        ],
      ),
    );
  }

  // --- WIDGETS PERSONALIZADOS ---

  // ----- ¡¡AQUÍ ESTÁ LA MAGIA!! -----
  /// Muestra la caja principal con el saldo (Estilo Bicolor)
  Widget _buildSaldoBox() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0), // Margen exterior
      decoration: BoxDecoration(
        // Esta decoración es para la SOMBRA
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        // Este ClipRRect corta a los hijos para que tengan bordes redondeados
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Parte Roja (Título) ---
            Container(
              width: double.infinity,
              color: const Color(0xFFEB0029), // Color Rojo Banorte
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), // Padding
              child: Text(
                'Saldo de la cuenta',
                style: TextStyle(
                  color: Colors.white, // Texto blanco sobre rojo
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ghotam',
                  fontSize: 18, // Un tamaño de título legible
                ),
              ),
            ),

            // --- Parte Blanca (Saldo) ---
            Container(
              width: double.infinity,
              color: Colors.white, // Fondo blanco
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), // Padding
              // Usamos tu BanorteTextBold para el saldo
              child: BanorteTextBold('\$8254.80', Colors.black),
            ),
          ],
        ),
      ),
    );
  }
  // ----- FIN DE LA MODIFICACIÓN -----


  /// Muestra los botones de "Transferir" y "Pagar"
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espacio entre botones
        children: [
          // Botón de Transferir
          ElevatedButton.icon(
            icon: Icon(Icons.swap_horiz, color: Colors.white),
            label: Text('Transferir', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // Aquí iría la lógica para transferir
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB0029), // Color Rojo Banorte
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          // Botón de Pagar Servicios (extra)
          ElevatedButton.icon(
            icon: Icon(Icons.payment, color: Colors.white),
            label: Text('Pagar', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // Aquí iría la lógica para pagar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB0029), // Color Rojo Banorte
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra el menú desplegable del historial
  Widget _buildHistoryTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: ExpansionTile(
        // Título del menú
        title: Text(
          'Historial de compras',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // Estilos para que se parezca a tus cajas
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.black, width: 1),
        ),

        // Contenido que se despliega
        children: [
          // Aquí ponemos una lista de items de historial
          _buildHistoryItem(
              icon: Icons.shopping_cart,
              merchant: 'Amazon',
              date: '24 Oct, 2025',
              amount: '-\$1,200.00'),
          _buildHistoryItem(
              icon: Icons.coffee,
              merchant: 'Starbucks',
              date: '23 Oct, 2025',
              amount: '-\$95.00'),
          _buildHistoryItem(
              icon: Icons.receipt_long,
              merchant: 'Pago de Luz (CFE)',
              date: '22 Oct, 2025',
              amount: '-\$450.20'),
          _buildHistoryItem(
              icon: Icons.arrow_downward,
              merchant: 'Depósito',
              date: '22 Oct, 2025',
              amount: '+\$10,000.00'),
          SizedBox(height: 10), // Un espacio al final de la lista
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required String merchant,
    required String date,
    required String amount,
  }) {
    final bool isDeposit = amount.startsWith('+');
    final Color amountColor = isDeposit ? Colors.green[700]! : Colors.red[700]!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.0),
        border: Border.all(color: Colors.grey.shade400),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícono del comercio
          Icon(icon, color: Colors.grey[700]),
          SizedBox(width: 15),

          // 1. Envolvemos la Columna en 'Expanded'
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Este texto ahora se partirá en 2 líneas si es necesario
                BanorteTextLight(merchant, Colors.black),
                Text(date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 10)),
              ],
            ),
          ),

          // 3. Quitamos el 'Spacer()' y ponemos un 'SizedBox'
          SizedBox(width: 10), // Espacio entre el texto y el monto

          // Monto
          BanorteText(amount, amountColor),
        ],
      ),
    );
  }
}