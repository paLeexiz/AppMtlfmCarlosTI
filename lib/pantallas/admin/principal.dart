// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:appmltpltfrm_carlos_ti/pantallas/admin/incidencias.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_empleados.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_paquetes.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_servicios.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_tickets.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Versión alternativa con efecto aún más hundido
class AdminPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 225, 232),
      appBar: AppBar(
        title: Text(
          'Panel de Inicio',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 31),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: _buildDeepPortalItem(
                          context,
                          'Empleados',
                          Icons.support_agent_outlined,
                          Color.fromARGB(255, 52, 156, 253),
                          () => Navigator.push(context, MaterialPageRoute(builder: (contex) => ListaEmpleados())),
                        ),
                      ),
                      Expanded(
                        child: _buildDeepPortalItem(
                          context,
                          'Incidencias',
                          Icons.bar_chart_outlined,
                          Color.fromARGB(255, 10, 206, 108),
                          () => Navigator.push(context, MaterialPageRoute(builder: (contex) => Incidencias())),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDeepPortalItem(
                          context,
                          'Tickets',
                          Icons.confirmation_number_outlined,
                          Color(0xFFF59E0B),
                          () => Navigator.push(context, MaterialPageRoute(builder: (contex) => ListaTickets())),
                          height: 90
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: 
                      _buildDeepPortalItem(
                        context,
                        'Paquetes',
                        Icons.inventory_2_outlined,
                        Color(0xFFEF4444),
                        () => Navigator.push(context, MaterialPageRoute(builder: (contex) => PackagesView())),
                        height: 100
                      ),
                      ),
                      Expanded(
                        child: _buildDeepPortalItem(
                          context,
                          'Servicio',
                            Icons.production_quantity_limits_rounded,
                            Color.fromARGB(255, 94, 220, 218),
                          () => Navigator.push(context, MaterialPageRoute(builder: (contex) => ListaServicios())),
                          height: 100
                        ),
                      ),
                      Expanded(
                        child: _buildDeepPortalItem(
                          context,
                          'Log out',
                          Icons.logout_outlined,
                          Color.fromARGB(255, 47, 4, 4),
                          () => Navigator.push(context, MaterialPageRoute(builder: (contex) => Login())),
                          height: 100
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepPortalItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    {double? width,
    double? height}
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(9),
        padding: EdgeInsets.all(10),
        width: width??123,
        height: height??123,
        decoration: BoxDecoration(
          color: Color(0xFFE0E5EC),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 217, 217, 217),
              const Color.fromARGB(255, 234, 234, 234),
              const Color.fromARGB(255, 245, 245, 245),
              Colors.white
            ],
            end: Alignment.bottomRight,
            begin: Alignment.topLeft,
          ), //   // Sombra interna (efecto hundido)
          boxShadow: [
            BoxShadow(
              color: Color(0xFFA3B1C6),
              offset: Offset(2, 2),
              blurRadius: 4,
              // inset: true,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              blurRadius: 6,
              // inset: true,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            // SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





















// import 'package:flutter/material.dart';

// class AdminPrincipal extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFB0BEC5),
//       appBar: AppBar(
//         title: Text('Admin Principal'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           children: <Widget>[
//             _buildCard(context, 'Usuarios', Icons.people, '/usuarios'),
//             _buildCard(context, 'Paquetes,Servicio', Icons.report, '/reportes'),
//             _buildCard(context, 'Configuración', Icons.settings, '/configuracion'),
//             _buildCard(context, 'Estadísticas', Icons.bar_chart, '/estadisticas'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context, String title, IconData icon, String route) {
//     return GestureDetector(
//       onTap: () {
//       Navigator.push(context, MaterialPageRoute(builder: (contex) => ListaEmpleados()//       }),
//       child: Card(
//       // elevation: 10,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(190, 235, 234, 234),
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black26,
//                 offset: Offset(4, 4), // Dirección opuesta a la luz
//                 blurRadius: 10,
//               ),
//               BoxShadow(
//                 color:Color(0xFFB0BEC5), 
//                 offset: Offset(-4, -4), // Dirección de la luz
//                 blurRadius: 10,
//               ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Icon(icon, size: 50),
//               SizedBox(height: 10),
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//       ),
//     );
//   }
// }