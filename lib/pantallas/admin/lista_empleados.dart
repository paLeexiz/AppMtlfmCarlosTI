import 'dart:ui';

import 'package:appmltpltfrm_carlos_ti/pantallas/admin/crear-actualizar_empleado.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/detalles_empleado.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/principal.dart';
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class ListaEmpleados extends StatefulWidget {
  const ListaEmpleados({super.key});

  @override
  _ListaEmpleadosState createState() => _ListaEmpleadosState();
}

class _ListaEmpleadosState extends State<ListaEmpleados> {
  bool isRefreshing = false;
  final TextEditingController b = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // Forma curva superior morada
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A5C9E), // Morado pastel claro
                    Color(0xFF3C91E6), // Morado pastel
                    Color(0xFF3C91E6), // Morado pastel
                  ],
                ),
                // color: Color(0xFF3C91E6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ),
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
                        onPressed: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AdminPrincipal())),
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
                SizedBox(height: 14),

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
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.list_alt, color: Color(0xFF342E37)),
                        Text(
                          'Lista de Empleados',
                          style: TextStyle(
                            fontSize: 18 - 3,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF342E37),
                          ),
                        ),
                        SizedBox(width: 12),
                        FloatingActionButton.small(
                          tooltip: 'agregar empleado',
                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmployeeForm()));
                          },
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),

                // Lista de Empleados
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: obtieneEmpleados(),
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
                                'No hay Empleados disponibles',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      } else {
                        var Empleados = snapshot.data!;

                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 9),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Card(
                                      margin: EdgeInsets.only(top: 7),
                                      shadowColor:
                                          Color.fromARGB(0, 255, 255, 255),
                                      color: Color(0xBBD5EBFF),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 9, sigmaY: 3),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: 60,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        Empleados.length
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      Text(
                                                        'Total de Empleados',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Color(
                                                                0xCF464545)),
                                                      ),
                                                    ]),
                                              )))),
                                  Card(
                                      margin: EdgeInsets.only(top: 7),
                                      shadowColor:
                                          Color.fromARGB(0, 255, 255, 255),
                                      color: Color(0xBBD5EBFF),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 9, sigmaY: 3),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: 60,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        Empleados.where(
                                                                (empleado) {
                                                          return empleado[
                                                                  'estado'] ==
                                                              'Activo'; //? empleado : null;
                                                        })
                                                            .toList()
                                                            .length
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ), //.length.toString()),
                                                      Text(
                                                        'Empleados Activos',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Color(
                                                                0xCF464545)),
                                                      ),
                                                    ]),
                                              )))),
                                ]),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              child: GlassTextField(
                                  b: b,
                                  hintText: 'Email/Estado/Turno/username',
                                  Empleados: Empleados,
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
    );
  }

  Future<List<dynamic>> obtieneEmpleados() async {
    final resultado = await ApiService.solicitud(
      tabla: 'operadores',
      metodo: 'get',
    );
    return resultado;
  }
}

// ignore: must_be_immutable
class GlassTextField extends StatelessWidget {
  final TextEditingController b;
  final String hintText;
  List<dynamic>? Empleados;
  final snapshot;
  GlassTextField(
      {super.key,
      required this.b,
      required this.hintText,
      required this.Empleados,
      required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(20), // Bordes redondeados para el efecto
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
          style: TextStyle(color: const Color(0xcd342E37)), // Texto en blanco
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: const Color(0x99342E37),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: const Color(0xB3342E37),
            ),
            border: InputBorder.none, // Sin bordes internos
            contentPadding:
                EdgeInsets.only(left: -20, right: -20, top: 13, bottom: 14),
            filled: true,
            fillColor: Color.fromARGB(255, 193, 209, 215)
                .withOpacity(0.5), // Fondo semitransparente
          ),
          buildCounter: (BuildContext context,
              {required int currentLength,
              required bool isFocused,
              required int? maxLength}) {
            // setState(() {
            Empleados = snapshot.data!.where((empleado) {
              return empleado['Username']
                      .toString()
                      .toLowerCase()
                      .contains(b.text.toLowerCase()) ||
                  empleado['Email']
                      .toString()
                      .toLowerCase()
                      .contains(b.text.toLowerCase()) ||
                  empleado['Estado']
                      .toString()
                      .toLowerCase()
                      .contains(b.text.toLowerCase()) ||
                  empleado['Turno']
                      .toString()
                      .toLowerCase()
                      .contains(b.text.toLowerCase());
            }).toList();
            // });
            return Center(
                child: Container(
              margin: EdgeInsets.only(top: 0, right: 30, left: 30, bottom: 10),
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
                  height: 470, // Set a fixed height for the container
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        horizontalMargin: 10,
                        columnSpacing: 20,
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
                              'Estado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF342E37),
                              ),
                            ),
                            headingRowAlignment: MainAxisAlignment.center,
                          ),
                          DataColumn(
                            label: Text(
                              'Empleado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF342E37),
                              ),
                            ),
                            headingRowAlignment: MainAxisAlignment.center,
                          ),
                          DataColumn(
                            label: Text(
                              'Horario', //turno, dias laborales
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF342E37),
                              ),
                            ),
                            headingRowAlignment: MainAxisAlignment.center,
                          ),
                        ],
                        rows: Empleados!.map((Empleado) {
                          return DataRow(
                            cells: [
                              DataCell(Center(
                                child: Icon(
                                  Icons.circle,
                                  color: Empleado['Estado'] == 'Activo'
                                      ? const Color.fromARGB(208, 77, 237, 141)
                                      : const Color.fromARGB(255, 252, 98, 87),
                                  size: 15,
                                ),
                              )),
                              DataCell(Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Empleado['Username'],
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18 - 3,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      Empleado['Email'],
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 12),
                                    ),
                                  ])),
                              DataCell(Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      Empleado['Turno'] ?? '',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(Empleado['Días Laborales'] ?? '',
                                        style: TextStyle(
                                          color: Colors.black87,
                                        )),
                                  ],
                                ),
                              )),
                            ],
                            onSelectChanged: (value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetallesEmpleado(
                                      id_Empleado: Empleado['id_operador']),
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
    );
  }
}
