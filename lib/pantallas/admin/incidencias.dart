import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  List<dynamic> incidencias = [];
  int totalIncidencias = 0;
  int llegadasTardias = 0;
  int llegadasATiempo = 0;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setInitialDates();
  }

  void _setInitialDates() {
    DateTime now = DateTime.now();
    switch (selectedPeriod) {
      case 'Este año':
        startDate = DateTime(now.year, 1, 1);
        endDate = now;
        break;
      case 'Este mes':
        startDate = DateTime(now.year, now.month, 1);
        endDate = now;
        break;
      case 'Esta semana':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = now;
        break;
      case 'Este día':
        startDate = now;
        endDate = now;
        break;
    }
    _startDateController.text = DateFormat('dd/MM/yyyy').format(startDate!);
    _endDateController.text = DateFormat('dd/MM/yyyy').format(endDate!);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> fetchIncidencias() async {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, seleccione ambas fechas')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/obtenerIncidencias'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fecha_inicio': DateFormat('yyyy-MM-dd').format(startDate!),
        'fecha_final': DateFormat('yyyy-MM-dd').format(endDate!),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        incidencias = json.decode(response.body);
        totalIncidencias = incidencias.length;
        llegadasTardias = incidencias.where((incidencia) => incidencia['turno'] == 'Retardo').length;
        llegadasATiempo = incidencias.where((incidencia) => incidencia['turno'] == 'A tiempo').length;
      });
    } else {
      setState(() {
        incidencias = [];
        totalIncidencias = 0;
        llegadasTardias = 0;
        llegadasATiempo = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falló al cargar las incidencias, compruebe su conexión a internet :)')),
      );
    }
  }

  void _validateAndFetchIncidencias() {
    if (startDate != null && endDate != null) {
      fetchIncidencias();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, seleccione ambas fechas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C91E6),
      body: Stack(
        children: [
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
                    Color(0xFFFEFEFE),
                    Color(0xFFCFE8FF),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(9),
              child: Column(
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
                          fetchIncidencias().then((_) {
                            setState(() {
                              isRefreshing = false;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Reporte de Incidencias',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                              _setInitialDates();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryCard('Total Incidencias', totalIncidencias.toString(), Color(0xFF7C3AED)),
                      _buildSummaryCard('Llegadas Tardías', llegadasTardias.toString(), Color(0xFFA78BFA)),
                      _buildSummaryCard('Llegadas a Tiempo', llegadasATiempo.toString(), Color(0xFFD8B4FE)),
                    ],
                  ),
                  SizedBox(height: 24),
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
                      _buildDateSelector(context, 'Fecha Inicio', startDate, (date) {
                        setState(() {
                          startDate = date;
                        });
                      }, _startDateController, DateTime(2000), DateTime.now()),
                      SizedBox(width: 16),
                      _buildDateSelector(context, 'Fecha Fin', endDate, (date) {
                        setState(() {
                          endDate = date;
                        });
                      }, _endDateController, DateTime(2023, 1, 1), DateTime.now()),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _validateAndFetchIncidencias,
                    child: Text('Validar y Buscar Incidencias'),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              Color(0xFFD8B4FE).withOpacity(0.1),
                            ),
                            columns: [
                              DataColumn(label: Text('Nombre\n(Empleado)')),
                              DataColumn(label: Text('Hora en\nque entró')),
                              DataColumn(label: Text('Turno')),
                              DataColumn(label: Text('Hora en\nque salió')),
                            ],
                            rows: incidencias.map((incidencia) {
                              return DataRow(cells: [
                                DataCell(Text(incidencia['nombre_empleado']?.toString() ?? 'NO ASIGNADO')),
                                DataCell(Text(incidencia['hora_entrada']?.toString() ?? 'NO ASIGNADO')),
                                DataCell(Text(incidencia['turno']?.toString() ?? 'NO ASIGNADO')),
                                DataCell(Text(incidencia['hora_salida']?.toString() ?? 'NO ASIGNADO')),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, String label, DateTime? selectedDate, Function(DateTime?) onDateSelected, TextEditingController controller, DateTime firstDate, DateTime lastDate) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFD8B4FE)),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime now = DateTime.now();
          DateTime adjustedInitialDate = selectedDate ?? now;

          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: adjustedInitialDate,
            firstDate: firstDate,
            lastDate: lastDate,
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
            onDateSelected(picked);
            controller.text = DateFormat('dd/MM/yyyy').format(picked);
          }
        },
      ),
    );
  }
}