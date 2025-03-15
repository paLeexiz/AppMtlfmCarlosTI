import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_paquetes.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/admin/lista_tickets.dart' as admin;
import 'package:appmltpltfrm_carlos_ti/pantallas/cliente/contratar_paquete.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/cliente/levantar_ticket.dart';
import 'package:appmltpltfrm_carlos_ti/pantallas/operador/lista_tickets.dart' as operador;
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool cargando = false;
  String mensajeError = '';
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 243, 250, 250),
      body: Stack(
        children: [
          // Forma curva superior azul
          Positioned(
            top: -166,
            left: -98,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(150),
                  topRight: Radius.circular(150),
                  bottomLeft: Radius.circular(150),
                ),
              ),
            ),
          ),

          // Forma curva inferior azul oscuro
          Positioned(
            bottom: -980,
            left: MediaQuery.of(context).size.width / 2 - 600,
            child: Container(
              height: 1200,
              width: 1200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 42, 75, 168),
                borderRadius: BorderRadius.all(Radius.circular(600))
              ),
            ),
          ),
          Positioned(
            bottom: -808,
            left: MediaQuery.of(context).size.width / 2 - 500,
            child: Container(
              height: 1000,
              width: 1000,
              decoration: BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.all(Radius.circular(500))
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón de regreso y título
                SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inicio de\nsesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(onPressed: (){
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => admin.ListaTickets(id: 8)
                        // ));
                      }, child: Text('Registrarse'))
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 51),

                          // Campos de entrada
                          Text(
                            'Nombre de usuario',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 81, 72, 209),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1E3A8A).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: username,
                              style: TextStyle(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Ingrese su nombre de usuario',
                                hintStyle: TextStyle(color: Colors.white60),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          Text(
                            'Contraseña',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 81, 72, 209),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1E3A8A).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: password,
                              obscureText: true,
                              style: TextStyle(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Ingrese su contraseña',
                                hintStyle: TextStyle(color: Colors.white60),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(height: 67),

                          // Botón de inicio de sesión
                          Center(
                            child: cargando
                                ? CircularProgressIndicator(color: Colors.white)
                                : ElevatedButton(
                                    onPressed: login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2563EB),
                                      foregroundColor: Colors.white,
                                      minimumSize: Size(150, 45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),

                          // Mensaje de error
                          if (mensajeError.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Center(
                                child: Text(
                                  mensajeError,
                                  style: TextStyle(color: Colors.red.shade500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    // setState(() {
      mensajeError = '';
    // });
    final user = username.text;
    final pass = password.text;

    try {
      final resultado = await ApiService.solicitud(
          tabla: 'iniciarSesion',
          metodo: 'post',
          cuerpo: {'username': user, 'password': pass});

      // Nota: Parece haber un error en la lógica original
      // Si hay un error, no deberías navegar a ListaTickets
      if (resultado['error'] == null) {
        // print(resultado[]);
        Navigator.push(
          context,
          resultado['rol'] == 'admin' 
            ? MaterialPageRoute(builder: (context) => admin.ListaTickets(id: resultado['id']))
            : resultado['rol'] == 'operador' 
              ? MaterialPageRoute(builder: (context) => operador.ListaTickets(id: resultado['id']))
              : MaterialPageRoute(builder: (context) => LevantarTicket(id: resultado['id_cliente'])),
        );
      } else {
        setState(() {
          cargando = false;
          mensajeError = 'Datos incorrectos';
        });
      }
    } catch (e) {
      setState(() {
        cargando = false;
        mensajeError = 'Error: $e';
      });
    }
  }
}
