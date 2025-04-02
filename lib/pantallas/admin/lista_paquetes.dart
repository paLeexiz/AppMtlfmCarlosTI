import 'package:appmltpltfrm_carlos_ti/pantallas/cliente/contratar_paquete.dart';
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class PackagesView extends StatelessWidget {
  final int? id;

  const PackagesView({Key? key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 225, 232),
      appBar: AppBar(
        title: Text(
          id != null ? 'Paquetes Contratados' : 'Paquetes',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: id != null ? a(id) : obtienePaquetes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar los paquetes: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Stack(children: [
              Positioned(
                top: 100,
                right: 0,
                left: 0,
                child: Text('No hay paquetes disponibles')
              ),
              id != null ?
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: const Color.fromARGB(135, 186, 192, 196),
                  child: ContratarPaquetes(id: id!)),
              ) : Container(),
            ]);
          } else {
            final packages = snapshot.data!;
            return Stack(children: [
              ListView.builder(
                padding: EdgeInsets.all(16),    
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final package = packages[index];
                  return PackageCard(package: package, id: id);
                },
              ),
              id != null ?
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: const Color.fromARGB(135, 186, 192, 196),
                  child: ContratarPaquetes(id: id!)),
              ) : Container(),
            ]);
          }
        },
      ),
    );
  }

  Future<List<dynamic>> obtienePaquetes() async {
    final resultado = await ApiService.solicitud(
      tabla: 'obtenerPaquetes',
      metodo: 'get',
    );
    return resultado;
  }

  Future<List<dynamic>> obtienePaquetesC(id) async {
    final resultado = await ApiService.solicitud(
        tabla: 'obtenerPaquetesC', metodo: 'get', id: id.toString());
    return resultado;
  }

  Future<List<dynamic>> a(id) async {
    var packs = await obtienePaquetes();
    var packsC = await obtienePaquetesC(id);
    var values =
        packsC.map((element) => element['id_paquetes_servicios']).toList();
    // print(packs);
    // print(packsC);
    // print(values);
    return packs
        .where((element) => values.contains(element['id_paquete']))
        .toList();
  }
}

class PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;
final int? id;
  const PackageCard({
    Key? key,
    required this.package,
    this.id = 0,
  }) : super(key: key);

  IconData getServiceIcon(String service) {
    switch (service.toLowerCase()) {
      case 'internet':
        return Icons.wifi;
      case 'telefonia':
        return Icons.phone;
      case 'streaming de video':
        return Icons.video_library;
      case 'streaming de musica':
        return Icons.music_note;
      default:
        return Icons.check_circle;
    }
  }

  Color getPackageColor() {
    switch (package['nombre_paquete'].toString().toLowerCase()) {
      case 'premium':
        return Color(0xFF2563EB); // Azul
      case 'combinado':
        return Color(0xFF059669); // Verde
      case 'estandar hogar':
        return Color(0xFFD97706); // Naranja
      case 'uth estudiatil':
        return Color.fromARGB(255, 6, 161, 217);
      default:
        return Color(0xFF6B7280); // Gris
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getPackageColor();

    return Container(
      // decoration: BoxDecoration(
      //   boxShadow: [
      //       BoxShadow(
      //         color: Color(0xFFA3B1C6),
      //         offset: Offset(2, 2),
      //         blurRadius: 4,
      //         // inset: true,
      //       ),
      //       BoxShadow(
      //         color: Colors.white,
      //         offset: Offset(-2, -2),
      //         blurRadius: 6,
      //         // inset: true,
      //       ),
      //     ],
      // ),
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del paquete
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre y tipo de paquete
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package['nombre_paquete'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  // Precio
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\$${package['precio']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),

              // Descripción
              Text(
                package['descripcion'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),

              // Servicios relacionados
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (package['servicios_relacionados'].split(', ')
                        as List<String>)
                    .map((service) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getServiceIcon(service),
                          size: 16,
                          color: color,
                        ),
                        SizedBox(width: 6),
                        Text(
                          service,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),),
                
            ],
          ),
        ),
      ),
    );
  }
}
