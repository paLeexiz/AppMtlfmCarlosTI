
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class DetallesTicket extends StatelessWidget {
  final int id_Ticket;
  const DetallesTicket({super.key, required this.id_Ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles del Ticket',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A5C9E),
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

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
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
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Información del Ticket',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A5C9E),
                                  ),
                                ),
                                SizedBox(height: 10),
                                DataTable(
                                  columnSpacing: 8,
                                  headingRowHeight: 8,
                                  columns: [
                                    DataColumn(label: Text('')),
                                    DataColumn(label: Text('')),
                                  ],
                                  rows: ticket.keys
                                      .map((key) => DataRow(cells: [
                                            DataCell(
                                              Text(key,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            DataCell(
                                                Text(ticket[key].toString())),
                                          ]))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
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
