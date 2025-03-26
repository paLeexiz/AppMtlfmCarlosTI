import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class LevantarTicket extends StatefulWidget {
  final dynamic id;

  const LevantarTicket({super.key, required this.id});

  @override
  _LevantarTicketState createState() => _LevantarTicketState();
}

class _LevantarTicketState extends State<LevantarTicket> {
  // Controladores
  final TextEditingController _descripcionController = TextEditingController();

  // Variables para las selecciones
  int? _selectedcategoria;
  int? _selectedPaquete;
  String _selectedPrioridad = 'Media';

  // Listas para los dropdowns
  List<dynamic> _categorias = [];
  List<dynamic> _paquetes = [];
  final List<String> _prioridades = ['Baja', 'Media', 'Alta'];

  // Estado de carga
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categoriasResult = await obtienecategorias();
      final paquetesResult = await a();

      setState(() {
        _categorias = categoriasResult;
        _paquetes = paquetesResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Levantar Ticket',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de información del ticket
                  _buildSectionTitle(
                      'Información del Ticket', Icons.info_outline),
                  SizedBox(height: 16),

                  // Categoría
                  _buildDropdownLabel('Categoría'),
                  FutureBuilder<List<dynamic>>(
                    future: Future.value(_categorias),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // final paquetes = snapshot.data ?? [];
                        return 
                  _buildDropdown<dynamic>(
                    items: _categorias,
                    value: _selectedcategoria,
                    hint: 'Selecciona una categoría',
                    onChanged: (value) {
                      setState(() {
                        _selectedcategoria = value;
                      });
                    },
                    itemBuilder: (item, d) => Text(item + '\n' + d),
                  );}
                    },
                  ),
                  SizedBox(height: 20),

                  // Paquete
                  _buildDropdownLabel('Paquete'),
                  FutureBuilder<List<dynamic>>(
                    future: Future.value(_paquetes),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final paquetes = snapshot.data ?? [];
                        return _buildDropdown<dynamic>(
                          items: paquetes,
                          value: _selectedPaquete,
                          hint: 'Selecciona un paquete',
                          onChanged: (value) {
                            setState(() {
                              _selectedPaquete = value;
                            });
                          },
                          itemBuilder: (item, d) => Text(item + '\n' + d),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),

                  // Prioridad
                  _buildDropdownLabel('Prioridad'),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 8,
                      children: _prioridades.map((prioridad) {
                        final isSelected = _selectedPrioridad == prioridad;
                        Color chipColor;

                        switch (prioridad) {
                          case 'Baja':
                            chipColor = Colors.green;
                            break;
                          case 'Media':
                            chipColor = Colors.blue;
                            break;
                          case 'Alta':
                            chipColor = Colors.orange;
                            break;
                          default:
                            chipColor = Colors.grey;
                        }

                        return ChoiceChip(
                          label: Text(
                            prioridad,
                            style: TextStyle(
                              color: isSelected ? Colors.white : chipColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: chipColor,
                          backgroundColor: chipColor.withValues(alpha: 0.1),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPrioridad = prioridad;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Descripción
                  _buildSectionTitle(
                      'Descripción del Problema', Icons.description),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _descripcionController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Describe el problema detalladamente...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Botón de envío
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Crear Ticket',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF2563EB), size: 20),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required List<T> items,
    required int? value,
    required String hint,
    required void Function(dynamic) onChanged,
    required Widget Function(T, T) itemBuilder,
  }) {
    // var nombres =
    //     items.map((item) => item).toList();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<dynamic>(
        value: value,
        hint: Text(hint),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: items.map((item) {
          var nombres =(item as Map).values.map((e) => e).toList();

          return DropdownMenuItem<dynamic>(
            value: nombres[0],
            // value: (item as Map)['nombre_paquete']),
            child: itemBuilder(
              nombres[1],
              nombres[2],
              // nombres.length > 4 ? nombres[4] : ''
            )
            // child: itemBuilder((item as Map)['nombre_paquete']),
          );
        }).toList(),
        onChanged: onChanged,
        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF2563EB)),
        isExpanded: true,
        dropdownColor: Colors.white,
      ),
    );
  }

  void _submitTicket() {
    // Validar campos
    if (_selectedcategoria == null ||
        _selectedPaquete == null ||
        _descripcionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Preparar datos para enviar
    final ticketData = {
      'id_cliente': widget.id,
      'categoria': _selectedcategoria,
      'paquete': _selectedPaquete,
      'prioridad': _selectedPrioridad,
      'descripcion': _descripcionController.text.trim(),
    };

    // Aquí iría la lógica para enviar el ticket
    insertTicket(ticketData);
    print('Enviando ticket: $ticketData');

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket creado con éxito')),
    );

    // Volver a la pantalla anterior
    Navigator.pop(context);
  }

  Future<void> insertTicket(c) async {
    await ApiService.solicitud(
      tabla: 'tickets',
      metodo: 'post',
      cuerpo: c
    );
  }
  Future<List<dynamic>> obtienecategorias() async {
    final resultado = await ApiService.solicitud(
      tabla: 'categories',
      metodo: 'get',
    );
    return resultado;
  }

  Future<List<dynamic>> a() async {
    var packs = await obtienePaquetes();
    var packsC = await obtienePaquetesC();
    var values =
        packsC.map((element) => element['id_paquetes_servicios']).toList();
    print(packs);
    print(packsC);
    print(values);
    return packs
        .where((element) => values.contains(element['id_paquete']))
        .toList();
  }

  Future<List<dynamic>> obtienePaquetes() async {
    final resultado =
        await ApiService.solicitud(tabla: 'obtenerPaquetes', metodo: 'get');
    return resultado;
  }

  Future<List<dynamic>> obtienePaquetesC() async {
    final resultado = await ApiService.solicitud(
        tabla: 'obtenerPaquetesC', metodo: 'get', id: widget.id.toString());
    return resultado;
  }
}

class PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;

  const PackageCard({
    Key? key,
    required this.package,
  }) : super(key: key);

  IconData getServiceIcon(String service) {
    switch (service.toLowerCase()) {
      case 'internet':
        return Icons.wifi;
      case 'telefonia':
        return Icons.phone;
      case 'streaming de video':
        return Icons.video_library;
      case 'streaming de musica':
        return Icons.music_note;
      default:
        return Icons.check_circle;
    }
  }

  Color getPackageColor() {
    switch (package['nombre_paquete'].toString().toLowerCase()) {
      case 'premium':
        return Color(0xFF2563EB); // Azul
      case 'combinado':
        return Color(0xFF059669); // Verde
      case 'estandar hogar':
        return Color(0xFFD97706); // Naranja
      default:
        return Color(0xFF6B7280); // Gris
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getPackageColor();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del paquete
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre y tipo de paquete
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package['nombre_paquete'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  // Precio
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\$${package['precio']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),

              // Descripción
              Text(
                package['descripcion'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),

              // Servicios relacionados
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (package['servicios_relacionados'].split(', ')
                        as List<String>)
                    .map((service) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getServiceIcon(service),
                          size: 16,
                          color: color,
                        ),
                        SizedBox(width: 6),
                        Text(
                          service,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
