import 'package:flutter/material.dart';
import 'package:prototipo/presets/banorte_text_bold.dart';
import 'package:pdfx/pdfx.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

// En tu archivo de servicio o donde llames a la API

final String _apiKey = dotenv.env['API_KEY'] ?? 'CLAVE_NO_ENCONTRADA';

class Services extends StatefulWidget {
 const Services({super.key});

 @override
 State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {

 final TextEditingController _promptController = TextEditingController();
 String _geminiResponse = '';
 bool _isLoadingGemini = false;
 GenerativeModel? _model;
 bool _initialPredictionMade = false;

 final TextEditingController _apartarController = TextEditingController(); 

 final List<Map<String, dynamic>> _historialLuz = [
   {'mes': 'Octubre', 'costo': 450.20}, 
   {'mes': 'Septiembre', 'costo': 470.10},
   {'mes': 'Agosto', 'costo': 495.30},
   {'mes': 'Julio', 'costo': 480.00},
   {'mes': 'Junio', 'costo': 460.80},
   {'mes': 'Mayo', 'costo': 435.00},
   {'mes': 'Abril', 'costo': 420.50},
 ];

 @override
 void initState() {
   super.initState();
   _model = GenerativeModel(
     model: 'gemini-2.5-flash', 
     apiKey: _apiKey,
   );
 }

 @override
 void dispose() {
   _promptController.dispose();
   _apartarController.dispose();
   super.dispose();
 }

 Future<void> _getInitialPrediction() async { 
   if (_model == null || _isLoadingGemini) return;

   setState(() {
     _isLoadingGemini = true;
     _geminiResponse = '';
   });

   String historialTexto = _historialLuz
       .map((e) => "Mes: ${e['mes']}, Costo: \$${e['costo'].toStringAsFixed(2)}")
       .join('\n');

   String prompt = """
   Basado en el siguiente historial de gastos de electricidad (en MXN):
   $historialTexto

   1. Predice el costo aproximado para el próximo mes (Noviembre).
   2. Dame 2-3 recomendaciones breves y prácticas para reducir mi consumo de luz en casa.

   Responde de forma concisa y amigable, separando la predicción y las recomendaciones claramente.

   No utilices formateo como negritas o listas, solo texto plano. Si el ususario hace preguntas que se desvian del tema
   de consumo de agua, electricidad, etc, como por ejemplo si te preguntan como estás o te intentan sacar platica cotidiana,
   recuerdale que solo puedes ayudar con temas relacionados a servicios públicos.

   """;

   try {
     final content = [Content.text(prompt)];
     final response = await _model!.generateContent(content);

     setState(() {
       _geminiResponse = response.text ?? 'No se recibió respuesta.';
       _isLoadingGemini = false;
       _initialPredictionMade = true;
     });
   } catch (e) {
     setState(() {
       _geminiResponse = 'Error al contactar a Gemini: ${e.toString()}';
       _isLoadingGemini = false;
       _initialPredictionMade = true; // Aún así marcamos como hecho
     });
     print("Error Gemini (Initial): $e");
   }
 }

 Future<void> _callGeminiFollowUp() async { 
   final promptText = _promptController.text.trim();
   if (promptText.isEmpty || _model == null || _isLoadingGemini) {
     return;
   }

   setState(() {
     _isLoadingGemini = true;
   });

   try {
     final content = [Content.text(promptText)];
     final response = await _model!.generateContent(content);

     setState(() {
       _geminiResponse = response.text ?? 'No se recibió respuesta.';
       _isLoadingGemini = false;
       _promptController.clear();
     });
   } catch (e) {
     setState(() {
       _geminiResponse = 'Error al contactar a Gemini: ${e.toString()}';
       _isLoadingGemini = false;
     });
     print("Error Gemini (Follow-up): $e");
   }
 }

 void _mostrarRecibo(BuildContext context, String pdfAssetPath) async {
    try {
      final pdfDocument = PdfDocument.openAsset(pdfAssetPath);
      final pdfController = PdfController(document: pdfDocument); 

      if (!context.mounted) return;

      showDialog( 
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  backgroundColor: Color(0xFFEB0029), 
                  title: Text('Visor de Recibo'),
                  leading: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: PdfView(controller: pdfController),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
       if (!context.mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           backgroundColor: Colors.red,
           content: Text('Error al cargar el recibo. Archivo no encontrado.'),
         ),
       );
       print("Error al abrir PDF: $e");
    }
 }

 @override
 Widget build(BuildContext context) {
   return SingleChildScrollView(
     child: Column(
       children: [
         Align( 
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
              child: BanorteTextBold('Monitoreo y pago de servicios', Colors.black),
            ),
         ),
         const SizedBox(height: 40),
         Container( 
             width: double.infinity,
           margin: const EdgeInsets.symmetric(horizontal: 16.0), 
           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), 
           decoration: BoxDecoration(
             color: Color(0xFFFF671B), 
             borderRadius: BorderRadius.circular(1.0),
             border: Border.all(color: Colors.grey.shade400),
             boxShadow: [
               BoxShadow(
                 color: Colors.black.withValues(alpha: 0.2),
                 blurRadius: 5.0,
                 offset: Offset(0, 3),
               ),
             ],
           ),
           child: Row(
             children: [
               BanorteTextBold('Adeudo total', Colors.black),
               Spacer(),
               BanorteTextBold('\$1759.70', Colors.black),
               SizedBox(width: 10),
             ],
           ),
         ),
         const SizedBox(height: 20),
         Padding( 
           padding: const EdgeInsets.symmetric(horizontal: 16.0),
           child: ExpansionTile(
             title: Text('Desglozar por servicio', style: TextStyle(fontWeight: FontWeight.bold)),
             shape: RoundedRectangleBorder(  ),
             collapsedShape: RoundedRectangleBorder(),
             children: [
               cajaServicio(
                 servicio: 'Agua',
                 cantidad: '\$150.00',
                 onVerRecibo: () {
                   _mostrarRecibo(context, 'assets/pdf/recibo_ejemplo.pdf');
                 },
               ),
               SizedBox(height: 20),
               cajaServicio(
                 servicio: 'Luz',
                 cantidad: '\$450.20',
                 onVerRecibo: () {
                   _mostrarRecibo(context, 'assets/pdf/recibo_ejemplo.pdf');
                 },
               ),
               SizedBox(height: 20),
               cajaServicio(
                 servicio: 'Teléfono',
                 cantidad: '\$299.00',
                 onVerRecibo: () {
                   _mostrarRecibo(context, 'assets/pdf/recibo_ejemplo.pdf');
                 },
               ),
               SizedBox(height: 20),
               cajaServicio(
                 servicio: 'Internet',
                 cantidad: '\$500.00',
                 onVerRecibo: () {
                   _mostrarRecibo(context, 'assets/pdf/recibo_ejemplo.pdf');
                 },
               ),
               SizedBox(height: 20),
               cajaServicio(
                 servicio: 'Gas',
                 cantidad: '\$210.50',
                 onVerRecibo: () {
                   _mostrarRecibo(context, 'assets/pdf/recibo_ejemplo.pdf');
                 },
               ),
               SizedBox(height: 20),
               cajaServicio(
                 servicio: 'Transporte',
                 cantidad: '\$100.00',
                 onVerRecibo: () {
                   _mostrarRecibo(context, 'assets/pdf/recibo_ejemplo.pdf');
                 },
               ),
               SizedBox(height: 20),
               cajaServicio(
                 servicio: 'Basura',
                 cantidad: '\$50.00',
                 onVerRecibo: () {
                   _mostrarRecibo(context, 'assets/pdf/recibo_ejemplo.pdf');
                 },
               ),
               SizedBox(height: 20),
             ],
           ),
         ),
         const SizedBox(height: 20),

         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0),
           child: ExpansionTile(
             title: Text('Historial de Luz', style: TextStyle(fontWeight: FontWeight.bold)),
             shape: RoundedRectangleBorder( /* ... */ ),
             collapsedShape: RoundedRectangleBorder( /* ... */ ),
             children: [
               Column(
                 children: _historialLuz.map((entry) => _buildHistoryEntry(
                   mes: entry['mes'] as String,
                   costo: entry['costo'] as double,
                 )).toList(),
               ),
               SizedBox(height: 10),
             ],
           ),
         ),

         const SizedBox(height: 20),

         Padding( 
           padding: const EdgeInsets.symmetric(horizontal: 16.0),
           child: ExpansionTile(
             title: Text(
               'Predecir Gasto de Luz (con Gemini)',
               style: TextStyle(fontWeight: FontWeight.bold),
             ),
             shape: RoundedRectangleBorder( ),
             collapsedShape: RoundedRectangleBorder( ),
             onExpansionChanged: (isExpanded) {
               if (isExpanded && !_initialPredictionMade && !_isLoadingGemini) {
                 _getInitialPrediction();
               }
             },
             children: [
                Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   children: [
                     if (_isLoadingGemini && !_initialPredictionMade)
                       Padding(
                         padding: const EdgeInsets.symmetric(vertical: 20.0),
                         child: CircularProgressIndicator(),
                       )
                     else if (_geminiResponse.isNotEmpty)
                       Container(
                         width: double.infinity,
                         margin: const EdgeInsets.only(bottom: 20.0),
                         padding: EdgeInsets.all(12),
                         decoration: BoxDecoration(
                           color: Colors.grey[200],
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: Text(
                           _geminiResponse,
                           style: TextStyle(color: Colors.black87),
                         ),
                       ),
                     if (_initialPredictionMade) ...[
                       Divider(height: 30, thickness: 1),
                       Text('¿Tienes otra pregunta sobre tus gastos?', style: TextStyle(fontWeight: FontWeight.bold)),
                       SizedBox(height: 10),
                       TextField(
                         controller: _promptController,
                         decoration: InputDecoration(
                           hintText: 'Escribe tu pregunta aquí...',
                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                           filled: true,
                           fillColor: Colors.grey[100],
                         ),
                         maxLines: 2,
                       ),
                       SizedBox(height: 15),
                       _isLoadingGemini
                         ? Padding(
                             padding: const EdgeInsets.symmetric(vertical: 10.0),
                             child: CircularProgressIndicator(),
                           )
                         : ElevatedButton.icon(
                             icon: Icon(Icons.send, color: Colors.white, size: 18),
                             label: Text('Preguntar', style: TextStyle(color: Colors.white)),
                             onPressed: _callGeminiFollowUp,
                             style: ElevatedButton.styleFrom(
                               backgroundColor: const Color(0xFFEB0029),
                               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                             ),
                           ),
                     ] else if (!_isLoadingGemini && _geminiResponse.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text("Abre este panel para ver tu predicción.", style: TextStyle(color: Colors.grey[600])),
                        )
                   ],
                 ),
               ),
             ],
           ),
         ),

         const SizedBox(height: 20),

         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0),
           child: ExpansionTile(
             title: Text('Apartar \$', style: TextStyle(fontWeight: FontWeight.bold)),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8.0),
               side: BorderSide(color: Colors.grey.shade100, width: 1),
             ),
             children: [
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   children: [
                     TextField(
                       controller: _apartarController,
                       keyboardType: TextInputType.numberWithOptions(decimal: true), 
                       inputFormatters: <TextInputFormatter>[
                         FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                       ],
                       decoration: InputDecoration(
                         labelText: 'Monto a apartar',
                         prefixText: '\$ ', // Símbolo de pesos
                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                         filled: true,
                         fillColor: Colors.grey[100],
                       ),
                     ),
                     SizedBox(height: 20),

                     ElevatedButton(
                       onPressed: () {
                         final montoString = _apartarController.text;
                         if (montoString.isNotEmpty) {
                           final monto = double.tryParse(montoString);
                           if (monto != null && monto > 0) {
                             print('Apartando: \$${monto.toStringAsFixed(2)}');
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text('Apartaste \$${monto.toStringAsFixed(2)} con éxito.'),
                                 backgroundColor: Colors.green,
                               ),
                             );
                             _apartarController.clear();
                           } else {
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text('Por favor, ingresa un monto válido.'),
                                 backgroundColor: Colors.orange,
                               ),
                             );
                           }
                         }
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: const Color(0xFFEB0029), // Rojo Banorte
                         padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       ),
                       child: Text('Apartar', style: TextStyle(color: Colors.white, fontSize: 16)),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),

         const SizedBox(height: 20),

         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0),
           child: ExpansionTile(
             title: Text('Vincular', style: TextStyle(fontWeight: FontWeight.bold)),
             shape: RoundedRectangleBorder( /* ... */ ),
             collapsedShape: RoundedRectangleBorder( /* ... */ ),
             children: [ Padding(padding: const EdgeInsets.all(16.0), child: Text('Vincula tus servicios...')) ],
           ),
         ),
         const SizedBox(height: 20),
       ],
     ),
   );
 }

 Container cajaDeDatos(String text, Color bg, Color textColor) {
   return Container(
     width: double.infinity,
     margin: const EdgeInsets.symmetric(horizontal: 25.0),
     padding: EdgeInsets.all(16.0),
     decoration: BoxDecoration(
       color: bg,
       borderRadius: BorderRadius.circular(1.0),
       boxShadow: [
         BoxShadow(
           color: Colors.black.withValues(alpha: 0.2),
           blurRadius: 5.0,
           offset: Offset(0, 3),
         ),
       ],
     ),
     child: Center(
       child: BanorteTextBold(text, textColor),
     ),
   );
 }

 Widget cajaServicio({
   required String servicio,
   required String cantidad,
   required VoidCallback onVerRecibo,
 }) {
   return Container(
     width: double.infinity,
     margin: const EdgeInsets.symmetric(horizontal: 25.0),
     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.circular(1.0),
       border: Border.all(color: Colors.grey.shade400), 
       boxShadow: [
         BoxShadow(
           color: Colors.black.withValues(alpha: 0.2),
           blurRadius: 5.0,
           offset: Offset(0, 3),
         ),
       ],
     ),
     child: Row(
       children: [
         BanorteTextBold(servicio, Colors.black),
         Spacer(),
         BanorteTextBold(cantidad, Colors.black),
         SizedBox(width: 10),
         InkWell(
           onTap: onVerRecibo,
           child: Icon(Icons.receipt_long, color: Colors.grey[700]),
         ),
       ],
     ),
   );
 }

 Widget _buildHistoryEntry({required String mes, required double costo}) {
   return Container(
     width: double.infinity,
     margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
     decoration: BoxDecoration(
       color: Colors.grey[100],
       borderRadius: BorderRadius.circular(8.0),
       border: Border.all(color: Colors.grey.shade300),
     ),
     child: Row(
       children: [
         Text(
           mes,
           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
         ),
         Spacer(),
         Text(
           '\$${costo.toStringAsFixed(2)}',
           style: TextStyle(fontSize: 16, color: Colors.black87),
         ),
       ],
     ),
   );
 }

} 