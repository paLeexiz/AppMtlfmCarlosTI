// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_paquetes.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/cliente/lista_tickets.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Versión alternativa con efecto aún más hundido
class ClientePrincipal extends StatelessWidget {
  final int id;
  const ClientePrincipal({super.key, required this.id});

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
                    children: [
                      Expanded(
                        child: _buildDeepPortalItem(
                          context,
                          'Tickets',
                          Icons.confirmation_number_outlined,
                          Color(0xFFF59E0B),
                          () => Navigator.push(context, MaterialPageRoute(builder: (contex) => ListaTickets(id: id,))),
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