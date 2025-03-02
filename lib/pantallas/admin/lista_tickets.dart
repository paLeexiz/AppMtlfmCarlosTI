// import 'package:appmltpltfrm_carlos_ti/pantallas/admin/Ticket.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/detalles_ticket.dart';
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class ListaTickets extends StatelessWidget {
  // final List<Ticket> tickets;
  const ListaTickets({super.key/*, required this.tickets*/});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtieneTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay tickets disponibles'));
          } else {
            final Tickets = snapshot.data!;

            return Stack(
              children: [
              // Contenido principal con scroll horizontal
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                          Row(
                            children: [
                              Text(
                                'Lista de Tickets',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                          const SizedBox(height: 23.0),
                          DataTable(
                            columns: (Tickets[0] as Map<String, dynamic>).keys.map(
                              (column) => DataColumn(label: Text(column))
                            ).toList(),

                            rows: Tickets.map((ticket) {
                              return DataRow(
                                cells: (ticket as Map<String, dynamic>).values.map((cell)
                                  => DataCell(Text(cell.toString()))).toList(),
                                onSelectChanged: (value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetallesTicket(id_Ticket: ticket['id']),
                                    ),
                                  );
                                },
                                // [
                                //   DataCell(Text(ticket['id'].toString())),
                                //   DataCell(Text(ticket['status'])),
                                //   DataCell(Text(ticket['status'])),
                                //   DataCell(Text(ticket['status'])),
                                //   DataCell(Text(ticket['status'])),
                                //   DataCell(Text(ticket['status'])),
                                //   DataCell(Text(ticket['status'])),
                                //   DataCell(Text(ticket['status'])),
                                //   DataCell(Text(ticket['status'])),
                                //   DataCell(Text(ticket['subject'])
                                //     // Chip(
                                //     //   label: Text(
                                //     //     ticket.estado,
                                //     //     style: const TextStyle(color: Colors.white),
                                //     //   ),
                                //     //   backgroundColor: ticket.estado == 'Abierto'
                                //     //       ? Colors.orange
                                //     //       : Colors.green,
                                //     // ),
                                //   ),
                                // ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16.0,
                  bottom: 65.0,
                  child: ElevatedButton(
                    onPressed: () {
                      marcarEntrada();
                    },
                    child: Text('Marcar entrada'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> marcarEntrada() async {
    print('Botón presionado');
  }

  Future<List<dynamic>> obtieneTickets() async {
    final resultado = await ApiService.solicitud(
      tabla: 'tickets',
      metodo: 'get',
    );
    return resultado;
  }
}