import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Reporte extends StatelessWidget {
  final int id;

  const Reporte({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Color.fromARGB(255, 220, 225, 232),

      appBar: AppBar(
        title: Text(
          'Reportes del Empleado',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey[800]),
            onPressed: () {
              // Forzar recarga
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Reporte(id: id),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerReportesEmpleado(id.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF1A73E8),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando reportes...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Error al cargar los reportes',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Reporte(id: id),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    color: Colors.grey[400],
                    size: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay reportes disponibles',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Este empleado no tiene reportes registrados',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final reportes = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: reportes.length,
                itemBuilder: (context, index) {
                  final reporte = reportes[index];
                  
                  // Extraer los datos del reporte
                  final nombreReporte = reporte['nombre_reporte'] ?? 'Reporte sin nombre';
                  final descripcion = reporte['descripcion'] ?? 'Sin descripción';
                  final fechaStr = reporte['fecha_reporte'] ?? '';
                  final nombreCliente = reporte['nombre_cliente'] ?? 'Cliente no especificado';
                  
                  // Formatear la fecha si existe
                  String fechaFormateada = 'Fecha no disponible';
                  if (fechaStr.isNotEmpty) {
                    try {
                      final fecha = DateTime.parse(fechaStr);
                      fechaFormateada = DateFormat('dd/MM/yyyy HH:mm').format(fecha);
                    } catch (e) {
                      fechaFormateada = fechaStr; // Usar el string original si no se puede parsear
                    }
                  }
                  
                  return _buildReporteCard(
                    context,
                    nombreReporte,
                    descripcion,
                    fechaFormateada,
                    nombreCliente,
                    index,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildReporteCard(
    BuildContext context,
    String nombreReporte,
    String descripcion,
    String fecha,
    String nombreCliente,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del reporte
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: Color(0xFF1A73E8).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF1A73E8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreReporte,
                        style: TextStyle(
                          fontSize: 15.4,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Cliente: $nombreCliente',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A73E8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    fecha,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido del reporte
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descripción:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  descripcion,
                  style: TextStyle(
                    fontSize: 13.6,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> obtenerReportesEmpleado(String id) async {
    final resultado = await ApiService.solicitud(
      tabla: 'obtenerReportesEmpleado',
      metodo: 'get',
      id: id,
    );
    
    // Si el resultado es una lista de strings, convertirlo a una lista de mapas
    if (resultado.isNotEmpty && resultado[0] is String) {
      return resultado.map((item) => {
        'nombre_reporte': 'Reporte ${resultado.indexOf(item) + 1}',
        'descripcion': item,
        'fecha': DateTime.now().subtract(Duration(days: resultado.indexOf(item))).toIso8601String(),
        'nombre_cliente': 'Cliente ${resultado.indexOf(item) + 1}',
      }).toList();
    }
    
    return resultado;
  }
}

