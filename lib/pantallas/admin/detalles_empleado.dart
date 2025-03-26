import 'package:appmltpltfrm_carlos_ti/pantallas/admin/crear-actualizar_empleado.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_empleados.dart';
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class DetallesEmpleado extends StatelessWidget {
  final int id_Empleado;
  const DetallesEmpleado({super.key, required this.id_Empleado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalles del Empleado',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1A5C9E),
          leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListaEmpleados())),

        ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: obtieneTicket(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay tickets disponibles'));
              } else {
                final ticket = snapshot.data!;
                final tickets = Map.from(ticket)
                  ..removeWhere((key, value) {
                    // Add your condition here to remove the elements you don't want to keep
                    // For example, to remove entries with a specific key:
                    // return key == 'undesired_key';
                    return key != 'nombre' &&
                        key != 'username' &&
                        key != 'email' &&
                        key != 'telefono' &&
                        key != 'ultimo_acceso' &&
                        key != 'estado' &&
                        key != 'departamento' &&
                        key != 'dias_laborales' &&
                        key != 'fecha_registro' &&
                        key != 'turno'; // Modify this condition as needed
                  });
                // print(ticket);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        minHeight: MediaQuery.of(context).size.height * .9,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Información del Empleado',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A5C9E),
                                  ),
                                ),
                                SizedBox(height: 16),
                                DataTable(
                                    columnSpacing: 8,
                                    headingRowHeight: 8,
                                    columns: [
                                      DataColumn(label: Text('')),
                                      DataColumn(label: Text(''))
                                    ],
                                    rows: tickets.keys
                                        .map((key) => DataRow(cells: [
                                              DataCell(Text(key,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                              DataCell(
                                                  Text(tickets[key].toString()))
                                            ]))
                                        .toList()),
                                  SizedBox(height: 16),
                                  Center(
                                    child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeForm(isEditing: true, employeeData: ticket)));
                                    },
                                    icon: Icon(Icons.edit),
                                    label: Text('Editar'),
                                    style: ElevatedButton.styleFrom(
                                        alignment: Alignment.center,
                                      // primary: const Color(0xFF1A5C9E),
                                      // onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        
                                        horizontal: 20, vertical: 11
                                      ),
                                    ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }));
  }

  Future<Map<String, dynamic>> obtieneTicket() async {
    final resultado = await ApiService.solicitud(
      tabla: 'operadores',
      metodo: 'get',
      id: id_Empleado.toString(),
    );
    return resultado as Map<String, dynamic>;
  }
}
