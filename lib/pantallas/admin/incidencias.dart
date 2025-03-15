import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Incidencias extends StatefulWidget {
  const Incidencias({super.key});

  @override
  _IncidenciasState createState() => _IncidenciasState();
}

class _IncidenciasState extends State<Incidencias> {
  String selectedPeriod = 'Este año';
  bool isRefreshing = false;

  DateTime? startDate;
  DateTime? endDate;
  // final List<Map<String, dynamic>> mockData = [
  //   {
  //     'id': 3,
  //     'nombre': 'Giacomo Guilizzoni\nFounder & CEO',
  //     'entrada': '5am',
  //     'turno': 'M:7:30am-1:30pm',
  //     'salida': '8pm',
  //   },
  //   {
  //     'id': 4,
  //     'nombre': 'Marco Botton\nTuttofare',
  //     'entrada': '5am',
  //     'turno': 'V:1:30pm-7pm',
  //     'salida': '7:30pm',
  //   },
  //   {
  //     'id': 6,
  //     'nombre': 'Valerie Liberty\nHead Chef',
  //     'entrada': '8am',
  //     'turno': 'N:2pm-9pm',
  //     'salida': '6:30pm',
  //   },
  //   {
  //     'id': 7,
  //     'nombre': 'Data Grid Docs',
  //     'entrada': '9am',
  //     'turno': '',
  //     'salida': '6pm',
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF3C91E6),
        body: Stack(children: [
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 543,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFEFEFE), // Morado pastel claro
                      Color(0xFFCFE8FF), // Morado pastel
                    ],
                  ),
                  // color: Color(0xFF3C91E6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                  ),
                ),
              )),
          SafeArea(
              child: Padding(padding: EdgeInsets.all(9), child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                  ),// Encabezado y Filtro
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Reporte de Incidencias',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFD8B4FE)),
                      ),
                      child: DropdownButton<String>(
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        value: selectedPeriod,
                        underline: SizedBox(),
                        items: [
                          'Este año',
                          'Este mes',
                          'Esta semana',
                          'Este día',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPeriod = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Tarjetas de resumen
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Card(
                          child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Incidencias',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '15',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                    // SizedBox(width: 16),
                    Expanded(
                      child: Card(
                          child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Llegadas Tardías',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '8',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFA78BFA),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                    // SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        // shape: Shap,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Inasistencias',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '7',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD8B4FE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Selector de período
                Text(
                  'PERIODO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFD8B4FE)),
                            ),
                            child: Text(
                              startDate != null
                                  ? DateFormat('dd/MM/yyyy').format(startDate!)
                                  : ' / / ',
                              style: TextStyle(
                                color: startDate != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today,
                              color: Color(0xFF7C3AED)),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color(0xFF7C3AED),
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() => startDate = picked);
                            }
                          },
                        ),
                      ],
                    )
                        // (date) => setState(() => startDate = date),
                        ),
                    SizedBox(width: 16),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFD8B4FE)),
                            ),
                            child: Text(
                              endDate != null
                                  ? DateFormat('dd/MM/yyyy').format(endDate!)
                                  : ' / / ',
                              style: TextStyle(
                                color: endDate != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today,
                              color: Color(0xFF7C3AED)),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color(0xFF7C3AED),
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() => endDate = picked);
                            }
                          },
                        ),
                      ],
                    ) // (date) => setState(() => endDate = date),
                        ),
                  ],
                ),
                SizedBox(height: 24),

                // Tabla de empleados
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          Color(0xFFD8B4FE).withOpacity(0.1),
                        ),
                        columns: [
                          DataColumn(label: Text('id')),
                          DataColumn(label: Text('Nombre\n(Empleado)')),
                          DataColumn(label: Text('Hora en\nque entró')),
                          DataColumn(label: Text('Turno')),
                          DataColumn(label: Text('Hora en\nque salió')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('id'.toString())),
                            DataCell(Text('nombre')),
                            DataCell(Text('entrada')),
                            DataCell(Text('turno')),
                            DataCell(Text('salida')),
                          ])
                        ]),
                  ),
                ),
              ],
            ),
        )),
        ]));
  }
}
// class uiyet {
//   static Widget _buildSummaryCard(String title, String value, Color color) {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );}
//   static Widget _buildDateSelector(
//     BuildContext context,
//     String label,
//     DateTime? selectedDate,
//     Function(DateTime?) onDateSelected,
// //   ) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Color(0xFFD8B4FE)),
//             ),
//             child: Text(
//               selectedDate != null
//                   ? DateFormat('dd/MM/yyyy').format(selectedDate)
//                   : ' / / ',
//               style: TextStyle(
//                 color: selectedDate != null ? Colors.black : Colors.grey,
//               ),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.calendar_today, color: Color(0xFF7C3AED)),
//           onPressed: () async {
//             final DateTime? picked = await showDatePicker(
//               context: context,
//               initialDate: selectedDate ?? DateTime.now(),
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2025),
//               builder: (context, child) {
//                 return Theme(
//                   data: Theme.of(context).copyWith(
//                     colorScheme: ColorScheme.light(
//                       primary: Color(0xFF7C3AED),
//                       onPrimary: Colors.white,
//                     ),
//                   ),
//                   child: child!,
//                 );
//               },
//             );
//             if (picked != null) {
//               onDateSelected(picked);
//             }
//           },
//         ),
//       ],
//     )
// //   }
// //   }
