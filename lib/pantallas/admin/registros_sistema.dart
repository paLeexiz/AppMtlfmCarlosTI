import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrosSistema extends StatefulWidget {
  const RegistrosSistema({super.key});

  @override
  _RegistrosSistemaState createState() => _RegistrosSistemaState();
}

class _RegistrosSistemaState extends State<RegistrosSistema> {
  List<dynamic> registros = [];
  int totalRegistros = 0;

  @override
  void initState() {
    super.initState();
    fetchRegistros();
  }

  Future<void> fetchRegistros() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/obtenerRegistroSistema'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        registros = json.decode(response.body);
        totalRegistros = registros.length;
      });
    } else {
      setState(() {
        registros = [];
        totalRegistros = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falló al cargar los registros, compruebe su conexión a internet :)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C91E6),
      body: SafeArea(
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
                      setState(() {});
                      fetchRegistros().then((_) {
                        setState(() {});
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Reporte de Registros',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryCard('Total Registros', totalRegistros.toString(), Color(0xFF7C3AED)),
                ],
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
                        headingRowColor: MaterialStateProperty.all(Color(0xFFD8B4FE).withOpacity(0.1)), // Cambiar color de fondo del encabezado
                        dataRowColor: MaterialStateProperty.all(Colors.white),
                        columns: [
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Acción')),
                          DataColumn(label: Text('Fecha de Evento')),
                        ],
                        rows: registros.map((registro) {
                          return DataRow(cells: [
                            DataCell(Text(registro['nombre']?.toString() ?? 'NO ASIGNADO')),
                            DataCell(Text(registro['accion']?.toString() ?? 'NO ASIGNADO')),
                            DataCell(Text(registro['fecha_evento']?.toString() ?? 'NO ASIGNADO')),
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
}