import 'package:appmltpltfrm_carlos_ti/pantallas/admin/detalles_empleado.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_empleados.dart';
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class EmployeeForm extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? employeeData;

  const EmployeeForm({
    Key? key,
    this.isEditing = false,
    this.employeeData,
  }) : super(key: key);

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passController;

  // Variables para los campos de selección
  String _selectedDepartment = 'Ingenieria Redes';
  String _selectedTurno = 'Matutino';
  List<String> _selectedDays = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes'
  ];

  // Listas de opciones
  final List<String> _departments = [
    'Ingenieria Redes',
    'Ingenieria Telecomunicaciones',
    'Ingenieria Seguridad\nInformática',
    'Ingenieria Desarrollo\nde Software',
    'Ingenieria Ciencia de Datos',
    'Ingenieria Ciberseguridad',
    'Ingenieria Automatización\ny Robótica'
  ];
  final Map<String, String> _turnos = {
    'Matutino':'06:00-14:00',
    'Vespertino':'14:00-22:00',
    'Nocturno':'22:00-06:00'
};
  final List<String> _days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
  ];

  @override
  void initState() {
    super.initState();

    // Inicializar controladores con datos existentes o vacíos
    if (widget.isEditing && widget.employeeData != null) {
      _nameController =
          TextEditingController(text: widget.employeeData!['nombre'] ?? '');
      _usernameController =
          TextEditingController(text: widget.employeeData!['username'] ?? '');
      _emailController =
          TextEditingController(text: widget.employeeData!['email'] ?? '');
      _phoneController = TextEditingController(
          text: widget.employeeData!['telefono'] ?? '');

      // Inicializar selecciones con datos existentes
      _selectedDepartment =
          widget.employeeData!['departamento'] ?? _departments[0];
      _selectedTurno = widget.employeeData!['turno'] == '06:00-14:00'? 'Matutino' : widget.employeeData!['turno'] == '14:00-22:00'? 'Vespertino' : 'Nocturno';// ?? _turnos['Matutino'];
      _selectedDays = List<String>.from(widget.employeeData!['dias'] ?? _selectedDays);
    } else {
      _nameController = TextEditingController();
      _usernameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _passController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      var employeeData = {
      };

      // Si estamos editando, incluir el ID
      if (widget.isEditing && widget.employeeData != null) {
        employeeData = {
          'nombre': _nameController.text,
          'username': _usernameController.text,
          'email': _emailController.text,
          'telefono': _phoneController.text,
          'depa': _selectedDepartment,
          'turno': _turnos[_selectedTurno],
          'dias': _selectedDays.join(','),
          'id': widget.employeeData!['id_usuario'],
        };
        putEmpleado(employeeData);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Actualizado con Éxito')));
        
        // Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DetallesEmpleado(id_Empleado: widget.employeeData!['id_operador'])));
      } else {
        employeeData = {
          'nombre': _nameController.text,
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passController.text,
          'depa': _selectedDepartment,
          'turno': _selectedTurno,
          'dias': _selectedDays.join(','),
        };
        crearEmpleado(employeeData);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Creado con Éxito')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListaEmpleados()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Actualizar Empleado' : 'Crear Empleado',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2563EB),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información personal
                  Text(
                    'Información Personal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  LayoutBuilder(builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _nameController,
                              label: 'Nombre Completo',
                              hint: 'Ingrese nombre completo',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese el nombre';
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                              child: _buildTextField(
                            controller: _usernameController,
                            label: 'Nombre de Usuario',
                            hint: 'Ingrese nombre de usuario',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el nombre de usuario';
                              }
                              return null;
                            },
                          )),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Nombre Completo',
                            hint: 'Ingrese nombre completo',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el nombre';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            controller: _usernameController,
                            label: 'Nombre de Usuario',
                            hint: 'Ingrese nombre de usuario',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el nombre de usuario';
                              }
                              return null;
                            },
                          )
                        ],
                      );
                    }
                  }),

                  _buildTextField(
                    controller: _emailController,
                    label: 'Correo Electrónico',
                    hint: 'ejemplo@correo.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el correo';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Ingrese un correo válido';
                      }
                      return null;
                    },
                  ),

                  _buildTextField(
                    controller: _phoneController,
                    label: 'Teléfono',
                    hint: '(123) 456-7890',
                    keyboardType: TextInputType.phone,
                  ),
                  !widget.isEditing
                      ? _buildTextField(
                          controller: _passController,
                          label: 'Contraseña',
                          hint: '*********',
                          obscureText: true
                          // keyboardType: TextInputType.,
                          )
                      : SizedBox(height: 0),

                  SizedBox(height: 32),

                  // Información laboral
                  Text(
                    'Información Laboral',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Departamento',
                          value: _selectedDepartment,
                          items: _departments,
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartment = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Turno',
                          value: _selectedTurno,
                          items: _turnos.keys.toList(),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _selectedTurno = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Días laborales
                  Text(
                    'Días Laborales',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 12),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _days.map((day) {
                        final isSelected = _selectedDays.contains(day);
                        return FilterChip(
                          label: Text(
                            day,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w500,
                            ),
                          ),
                          selected: isSelected,
                          backgroundColor: Colors.grey[100],
                          selectedColor: Color(0xFF3C91E6),
                          // checkmarkColor: Colors.white,
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedDays.add(day);
                              } else {
                                _selectedDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.grey[800],
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            widget.isEditing ? 'Actualizar' : 'Guardar',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> crearEmpleado(cuerpo) async {
    // final resultado = 
    await ApiService.solicitud(
      tabla: 'crearEmpleado',
      metodo: 'post',
      cuerpo: cuerpo,
    );
  }

  Future<void> putEmpleado(cuerpo) async {
    // final resultado = 
    await ApiService.solicitud(
      tabla: 'putEmpleado',
      metodo: 'put',
      id: widget.employeeData!['id_operador'].toString(),
      cuerpo: cuerpo,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
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
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[400]),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: InputBorder.none,
                errorStyle: TextStyle(height: 0.8),
              ),
              keyboardType: keyboardType,
              obscureText: obscureText,
              validator: validator,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            style: TextStyle(fontSize: 12, color: Colors.black),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              border: InputBorder.none,
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Container(
                  width: 109,
                  child:Text(item),),
              );
            }).toList(),
            onChanged: onChanged,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF3C91E6),
              size: 17,
            ),
            // isExpanded: true,
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
