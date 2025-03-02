import 'package:appmltpltfrm_carlos_ti/pantallas/admin/Ticket.dart';
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class DetallesTicket extends StatelessWidget {
  final int id_Ticket;
  const DetallesTicket({super.key, required this.id_Ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Ticket'),
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

            return Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height,
                    ), 
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            columns: [
                              DataColumn(label: Text('Informacion')),
                              DataColumn(label: Text('del ticket'))
                            ],
                            rows: ticket.keys.map((key) => DataRow(cells: [
                              DataCell(Text(key)),
                              DataCell(Text(ticket[key].toString()))
                            ])).toList()

                            // [
                            //   DataRow(
                            //     cells: [
                            //       DataCell(
                            //         Text(
                            //           'Título',
                            //           style: Theme.of(context).textTheme.bodyMedium,
                            //         ),
                            //       ),
                            //       DataCell(
                            //         Text(
                            //           'titulo',
                            //           style: Theme.of(context).textTheme.bodyMedium,
                            //         ),
                            //       )
                            //     ]
                            //   ),
                            //   DataRow(
                            //     cells: [
                            //       DataCell(
                            //         Text(
                            //           'Descripción',
                            //           style: Theme.of(context).textTheme.bodyMedium,
                            //         ),
                            //       ),
                            //       DataCell(
                            //         Text(
                            //           'titulo',
                            //           style: Theme.of(context).textTheme.bodyMedium,
                            //         ),
                            //       )
                            //     ]
                            //   )
                            // ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            );
          }
        }
      )
    );
  }

  Future<Map<String, dynamic>> obtieneTicket() async {
    final resultado = await ApiService.solicitud(
      tabla: 'tickets',
      metodo: 'get',
      id: id_Ticket.toString(),
    );
    return resultado as Map<String, dynamic>;
  }
}
