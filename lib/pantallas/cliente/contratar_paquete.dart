import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ContratarPaquetes extends StatefulWidget {
  final int id;
  const ContratarPaquetes({super.key, required this.id});

  @override
  _ContratarPaquetesState createState() => _ContratarPaquetesState();
}

class _ContratarPaquetesState extends State<ContratarPaquetes> {
  final _formKey = GlobalKey<FormState>();
  String _servicio = '';
  late Future<List<dynamic>> _futurePaquetes = obtienePaquetes();

  @override
  void initState() {
    super.initState();
    this._futurePaquetes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contratar Servicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _futurePaquetes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay servicios disponibles'));
            } else {
              print(snapshot.data);
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButtonFormField<dynamic>(
                      decoration: InputDecoration(
                        constraints: BoxConstraints(minHeight: 100),
                        label: PackageCard(package: snapshot.data![0]),
                        border: OutlineInputBorder(),
                      ),
                      items: snapshot.data!.map((dynamic value) {
                        print(value);
                        return DropdownMenuItem<String>(
                          value: value[
                              'id_paquete'].toString(), // Assuming 'nombre' is a field in your service data
                          child: PackageCard(package: value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _servicio = newValue!;
                        });
                      },
                      value: snapshot.data!.any((element) => element['nombre_paquete'] == _servicio) ? _servicio : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione un servicio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print(_servicio +', '+ widget.id.toString());
                          postPaqueteCliente(int.parse(_servicio), widget.id);
                          // Aquí puedes agregar la lógica para contratar el servicio
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Servicio contratado con éxito')),
                          );
                        }
                      },
                      child: Text('Contratar'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
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
  Future<List<dynamic>> postPaqueteCliente(p, c) async {
    final resultado = await ApiService.solicitud(
      tabla: 'postPaqueteCliente',
      metodo: 'post',
      cuerpo: {'id_paquetes_servicios' : p, 'id_cliente' : c}
    );
    return resultado;
  }
}
class PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;

  const PackageCard({
    Key? key,
    required this.package,
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
      default:
        return Color(0xFF6B7280); // Gris
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getPackageColor();
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        elevation: 0,
        
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
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ID: ${package['id_paquete']}',
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Precio
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${package['precio']}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
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
                  children: (package['servicios_relacionados'].split(', ') as List<String>).map((service) {
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
                  }).toList(),
                ),
              ],
            ),
          ),
      
      ),
    );
  }

  
}
