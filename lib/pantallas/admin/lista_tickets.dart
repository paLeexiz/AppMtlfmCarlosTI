import 'dart:ui';

import 'package:appmltpltfrm_carlos_ti/pantallas/admin/detalles_ticket.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_empleados.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_servicios.dart';
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class ListaTickets extends StatefulWidget {
  final id;
  const ListaTickets({super.key,  this.id});

  @override
  _ListaTicketsState createState() => _ListaTicketsState();
}

class _ListaTicketsState extends State<ListaTickets> {
  bool isRefreshing = false;
  final TextEditingController b = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF3C91E6),
      // backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // Forma curva superior morada
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 610,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF9F9F9), // Morado pastel claro
                    Color(0xFFF9F9F9), // Morado pastel
                    Color(0xffCFE8FF), // Morado pastel
                  ],
                ),
                // color: Color(0xFF3C91E6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),

       

          // Contenido principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                // Barra superior
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Administrador',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.black54),
                        onPressed: () {
                          setState(() {
                            isRefreshing = true;
                          });
                          Future.delayed(Duration(milliseconds: 50), () {
                            setState(() {
                              isRefreshing = false;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 23),

                // Título de la sección
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: .8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: .8),
                    // decoration: BoxDecoration(
                    //   color: Color(0xFFD8B4FE).withOpacity(0.3), // Morado pastel claro transparente
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.list_alt, color: Color(0xFF342E37)),
                        Text(
                          'Lista de Tickets',
                          style: TextStyle(
                            fontSize: 18 - 3,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF342E37),
                          ),
                        ),
                        SizedBox(width: 22),
                      ],
                    ),
                  ),
                ),

                // Lista de tickets
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: obtieneTickets(),
                    builder: (context, snapshot) {
                      if (isRefreshing ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFA78BFA),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 48),
                              SizedBox(height: 16),
                              Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inbox, color: Colors.grey, size: 48),
                              SizedBox(height: 16),
                              Text(
                                'No hay tickets disponibles',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      } else {
                        var tickets = snapshot.data!;

                        return Column(children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              child: GlassTextField(
                                  b: b,
                                  hintText: 'Estado/Paquete/Operador/Categoria/Prioridad',
                                  tickets: tickets,
                                  snapshot: snapshot)
                             )
                        ]);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xFF342E37),
      //   child: Icon(Icons.add, color: Colors.white),
      //   onPressed: () {
      //     // Acción para agregar nuevo ticket
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('Crear nuevo ticket'),
      //         backgroundColor: Color(0xFF342E37),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Future<void> marcarEntrada() async {
    print('Botón presionado');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entrada marcada correctamente'),
        backgroundColor: Color(0xFF342E37),
      ),
    );
  }

  Future<List<dynamic>> obtieneTickets() async {
    final resultado = await ApiService.solicitud(
      tabla: 'tickets',
      metodo: 'get',
    );
    return resultado;
  }
}

// ignore: must_be_immutable
class GlassTextField extends StatelessWidget {
  final TextEditingController b;
  final String hintText;
  List<dynamic>? tickets;
  final snapshot;
  GlassTextField(
      {super.key, required this.b,
      required this.hintText,
      required this.tickets,
      required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(20), // Bordes redondeados para el efecto
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 7), // Desenfoque
        child: Container(
          decoration: BoxDecoration(
            // color: const Color(0x33FD7238), // Fondo semitransparente
            // borderRadius: BorderRadius.circular(0),
            border:
                Border.all(color: Colors.white.withOpacity(0.1)), // Borde sutil
          ),
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: TextField(
            controller: b,
            cursorColor: Color(0xdd1A5C9E),
            cursorRadius: Radius.circular(3),
            cursorHeight: 19,
            cursorWidth: 2.4,
            cursorOpacityAnimates: true,
            style: TextStyle(color: const Color(0xFF342E37)), // Texto en blanco
            decoration: InputDecoration(
              
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0x99342E37),
                fontSize: 15.5,
                letterSpacing: -1
              ),
              prefixIcon: Icon(
                Icons.search,
                color: const Color(0xB3342E37),
              ),
              border: InputBorder.none, // Sin bordes internos
              contentPadding:
                  EdgeInsets.only(left: -20, right: -20, top: 13, bottom: 14),
              filled: true,
              fillColor: Color.fromARGB(255, 193, 209, 215).withOpacity(0.5),

            ),
            buildCounter: (BuildContext context,
                {required int currentLength,
                required bool isFocused,
                required int? maxLength}) {
              
              tickets = snapshot.data!.where((ticket) {
                return ticket['prioridad']
                        .toString()
                        .toLowerCase()
                        .contains(b.text.toLowerCase()) ||
                    ticket['estado_ticket']
                        .toString()
                        .toLowerCase()
                        .contains(b.text.toLowerCase()) ||
                    ticket['nombre_categoria']
                        .toString()
                        .toLowerCase()
                        .contains(b.text.toLowerCase()) ||
                    ticket['nombre_paquete']
                        .toString()
                        .toLowerCase()
                        .contains(b.text.toLowerCase()) ||
                    ticket['nombre_operador']
                        .toString()
                        .toLowerCase()
                        .contains(b.text.toLowerCase());
              }).toList();
              // });
              return Center(
                  child: Container(
                margin:
                    EdgeInsets.only(top: 0, right: 30, left: 30, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFffffFF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 579,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          horizontalMargin: 13,
                          columnSpacing: 18,
                          dataRowHeight: 64,
                          showCheckboxColumn: false,
                          headingRowHeight: 40,
                          headingRowColor: WidgetStateProperty.all(
                            Color(0xFFF9F9F9),
                          ),
                          dataRowColor: WidgetStateProperty.all(
                            Color(0xFFF9F9F9),
                          ),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Categoria',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF342E37),
                                ),
                              ),
                              headingRowAlignment: MainAxisAlignment.center,
                            ),
                            DataColumn(
                              label: Text(
                                'Descripción',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF342E37),
                                ),
                              ),
                              headingRowAlignment: MainAxisAlignment.center,
                            ),
                            DataColumn(
                              label: Text(
                                'Operador',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF342E37),
                                ),
                              ),
                              headingRowAlignment: MainAxisAlignment.center,
                            ),
                          ],
                          rows: tickets!.map((ticket) {
                            return DataRow(
                              cells: [
                                DataCell(Row(children: [
                                  Icon(
                                    Icons.circle,
                                    color: ticket['estado_ticket'] == 'Resuelto'
                                        ? Colors.green
                                        : ticket['estado_ticket'] == 'Pendiente'
                                            ? Colors.red
                                            : Colors.grey,
                                    size: 14,
                                  ),
                                  SizedBox(width: 18),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          ticket['nombre_categoria'],
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18 - 3,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Paquete ' + ticket['nombre_paquete'],
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12),
                                        ),
                                      ])
                                ])),
                                DataCell(SizedBox(
                                    width: 257,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: 6,
                                          child: SizedBox(
                                            width: 196,
                                            child: Text(
                                              ticket['descripcion_ticket'],
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: -2,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    String mensajeExtra = "";
                                                    if (ticket['prioridad'] ==
                                                        'Alta') {
                                                      mensajeExtra =
                                                          '¡Coyelle, coyelle en verdad urge!';
                                                    } else if (ticket[
                                                            'prioridad'] ==
                                                        'Media') {
                                                      mensajeExtra =
                                                          '¿Ya no hay prioridad alta?';
                                                    } else {
                                                      mensajeExtra =
                                                          'tómatelo con calma';
                                                    }
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'La prioridad es ${ticket['prioridad']}, $mensajeExtra'),
                                                        backgroundColor:
                                                            Color(0xFF342E37),
                                                      ),
                                                    );
                                                  },
                                                  child: Chip(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 1.2,
                                                        vertical: 0),
                                                    label: SizedBox(
                                                        width: 25,
                                                        child: Text(
                                                          ticket['prioridad'],
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xFF000000),
                                                            fontSize: 9,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    backgroundColor:
                                                        const Color(0xFFCFE8FF),
                                                  ),
                                                ),
                                                Text(
                                                  ticket['fecha_ticket']
                                                      .toString()
                                                      .substring(0, 10),
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 10),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ))),
                                DataCell(
                                  // SizedBox(height: 6),
                                  Text(
                                    ticket['nombre_operador'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // SizedBox(height: 4),
                                ),
                              ],
                              onSelectChanged: (value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetallesTicket(id_Ticket: ticket['id']),
                                  ),
                                );
                              },
                              selected: false,
                              // showCheckboxColumn: false,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
