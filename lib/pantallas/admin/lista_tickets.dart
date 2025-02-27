import 'package:appmltpltfrm_carlos_ti/pantallas/admin/Ticket.dart';
import 'package:flutter/material.dart';

class ListaTickets extends StatelessWidget {
  final List<Ticket> tickets;
  const ListaTickets({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador'),
      ),
      body: Stack(
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
                        // const SizedBox(width: 8.0),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Título')),
                        DataColumn(label: Text('Descripción')),
                        DataColumn(label: Text('Estado')),
                      ],
                      rows: tickets.map((ticket) {
                        return DataRow(
                          cells: [
                            DataCell(Text(ticket.titulo)),
                            DataCell(Text(ticket.descripcion)),
                            DataCell(
                              Chip(
                                label: Text(
                                  ticket.estado,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: ticket.estado == 'Abierto'
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botón flotante en la esquina inferior derecha
          Positioned(
            right: 16.0,
            bottom: 658.0,
            child: ElevatedButton(
              onPressed: () {
                print('Botón presionado');
              },
              child: Text('marcar entrada'),
            ),
          ),
        ],
      ),
    );
  }
}