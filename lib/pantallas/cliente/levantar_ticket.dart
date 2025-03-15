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
  String? _selectedCategoria;
  String? _selectedServicio;
  String? _selectedPaquete;
  String _selectedPrioridad = 'Media';
  
  // Listas para los dropdowns
  List<dynamic> _servicios = [];
  List<dynamic> _paquetes = [];
  List<String> _categorias = ['Hardware', 'Software', 'Red', 'Cuenta', 'Otro'];
  List<String> _prioridades = ['Baja', 'Media', 'Alta', 'Crítica'];
  
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
      final serviciosResult = await obtieneServicios();
      final paquetesResult = await obtienePaquetes();
      
      setState(() {
        _servicios = serviciosResult;
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
                  _buildSectionTitle('Información del Ticket', Icons.info_outline),
                  SizedBox(height: 16),
                  
                  // Categoría
                  _buildDropdownLabel('Categoría'),
                  _buildDropdown<String>(
                    items: _categorias,
                    value: _selectedCategoria,
                    hint: 'Selecciona una categoría',
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoria = value;
                      });
                    },
                    itemBuilder: (item) => Text(item),
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
                        return _buildDropdown<String>(
                          items: paquetes.map<String>((p) => p['nombre_paquete'] as String).toList(),
                          value: _selectedPaquete,
                          hint: 'Selecciona un paquete',
                          onChanged: (value) {
                            setState(() {
                              _selectedPaquete = value;
                            });
                          },
                          itemBuilder: (item) => Text(item),
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
                          case 'Crítica':
                            chipColor = Colors.red;
                            break;
                          default:
                            chipColor = Colors.grey;
                        }
                        
                        return ChoiceChip(
                          label: Text(
                            prioridad,
                            style: TextStyle(
                              color: isSelected ? Colors.white : chipColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: chipColor,
                          backgroundColor: chipColor.withOpacity(0.1),
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
                  _buildSectionTitle('Descripción del Problema', Icons.description),
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
    required T? value,
    required String hint,
    required void Function(T?) onChanged,
    required Widget Function(T) itemBuilder,
  }) {
    return Container(
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
      child: DropdownButtonFormField<T>(
        value: value,
        hint: Text(hint),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: itemBuilder(item),
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
    if (_selectedCategoria == null || 
        _selectedServicio == null || 
        _selectedPaquete == null || 
        _descripcionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }
    
    // Preparar datos para enviar
    final ticketData = {
      'id_usuario': widget.id,
      'categoria': _selectedCategoria,
      'servicio': _selectedServicio,
      'paquete': _selectedPaquete,
      'prioridad': _selectedPrioridad,
      'descripcion': _descripcionController.text.trim(),
    };
    
    // Aquí iría la lógica para enviar el ticket
    print('Enviando ticket: $ticketData');
    
    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket creado con éxito')),
    );
    
    // Volver a la pantalla anterior
    Navigator.pop(context);
  }

  Future<List<dynamic>> obtieneServicios() async {
    final resultado = await ApiService.solicitud(
      tabla: 'servicios',
      metodo: 'get',
    );
    return resultado;
  }
  
  Future<List<dynamic>> obtienePaquetes() async {
    final resultado = await ApiService.solicitud(
      tabla: 'paquetes',
      metodo: 'get',
    );
    return resultado;
  }
}

