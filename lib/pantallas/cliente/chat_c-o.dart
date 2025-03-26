// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'dart:ffi';

import 'package:appmltpltfrm_carlos_ti/pantallas/cliente/lista_tickets.dart';
import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final int idTicket;
  final int idRemitente;
  const ChatScreen(
      {super.key, required this.idRemitente, required this.idTicket});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _reporte = TextEditingController();

  late TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  int id_usuario = 0;
  int id_rol = 0;
  int idOp = 0;
  int idCl = 0;
  String rol_usuario = '';
  var cerradom;
  int estrellas = 0;
  bool banCal = true;
  late String hin = '';

  @override
  void initState() {
    super.initState();
    obtenerEstadoTicketPorID(widget.idTicket).then((valor) {
      setState(() {
        cerradom = valor;
      });
    });
    verificaCalificacion().then((valor) {
    if (mounted) {
      setState(() {
        banCal = valor; // Aseguramos que se actualiza correctamente
      });
    }
  });
    obtenerIDSTicket(widget.idTicket).then((valor) {
      setState(() {
        idOp = valor['id_operador'];
        idCl = valor['id_cliente'];
      });
    });
    obtenerMensajesTicket();
    obtenerIDUsuario();
    actualizarLeidoMensaje();
  }

  Future<void> obtenerIDUsuario() async { // solo uso id_usuario
    int id = await obtenerIDUsuarioPorCliente();
    // int id_rolsito = await obtenerIDRolPorUsuario();
    // String rol = await obtenerRolUsuarioPorRemitente();
    setState(() {
      id_usuario =id; // Aseguramos que id_usuario tenga un valor antes de construir la UI
      // rol_usuario = rol; // Aseguramos que id_usuario tenga un valor antes de construir la UI
      // id_rol = id_rolsito; // Aseguramos que id_usuario tenga un valor antes de construir la UI
    });
  }

  Future<void> actualizarLeidoMensaje() async {
    /*final resultado = */ await ApiService.solicitud(
        tabla: 'actualizarLeidoMensaje',
        metodo: 'put',
        cuerpo: {
          'id_ticket': widget.idTicket.toString(),
          'id_remitente': id_usuario
        });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.idTicket);
    print('$banCal quiqaqui aqui');

    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          backgroundColor: Colors.teal,
        ),
        body: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    print(widget.idTicket);
                    print(idOp);
                    var align;
                    var radio;
                    var colorsito;

                    if (_messages[_messages.length - 1 - index]['id_remitente'] == id_usuario ) {
                      colorsito = Color(0xFFB2DFDB);
                      align = Alignment.centerRight;
                      radio = BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10));
                    } else {
                      colorsito = Color(0xFFFFCE26);
                      align = Alignment.centerLeft;
                      radio = BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10));
                    }
                    return ListTile(
                      title: Align(
                        alignment: align,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorsito,
                            borderRadius: radio,
                          ),
                          child: Text(_messages[_messages.length - 1 - index]
                                  ['mensaje']
                              .toString()),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (!banCal && cerradom != 'Resuelto')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send_rounded),
                        onPressed: () {
                          insertarTicket(_controller.text);
                          setState(() {
                            _controller.clear();
                            obtenerMensajesTicket();
                          });
                        },
                        color: const Color.fromARGB(255, 0, 150, 32),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Positioned(
              top: 27,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('¿Reportar operador?'),
                        content: Text('¿Estás seguro de que deseas reportar al operador?'),
                        actions: [
                          DropdownButton<String>(
                            value: hin != '' ? hin : 'null',
                            hint: Text(hin != '' ? hin : 'null',),
                            items: ['Groser@', 'Responde lento', 'Solo me dejó en visto', 'No sabe sobre el problema', 'Otros'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                hin = newValue!;
                              });
                            },
                          ),
                          TextField(
                            controller: _reporte,
                            decoration: InputDecoration(
                              hintText: 'Escribe el motivo del reporte...',
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cerrar el diálogo
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cerrar el diálogo
                              setState(() {
                                ApiService.solicitud(
                                    tabla: 'reporte_operadores',
                                    metodo: 'post',
                                    cuerpo: {
                                      'nombre_reporte': widget.idTicket,
                                      'descripcion': _reporte.text,
                                      'id_ticket': widget.idTicket,
                                      'id_cliente': idCl,
                                      'id_operador': idOp,
                                      'id_remitente': widget.idRemitente
                                    });
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListaTickets(id: widget.idRemitente)));
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: const Color(0xeeDB504A),
                  ),
                  height: 20,
                  width: 88,
                  child: Text(
                    textAlign: TextAlign.center,
                    'Reportar',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )),
          if (!banCal && cerradom.toString() != 'Resuelto')
            Positioned(
                top: 27,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('¿El operador fue de ayuda?'),
                          content: Text('Por favor selecciona una opción:'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo
                                setState(() {
                                  ApiService.solicitud(
                                      tabla: 'cerrarTicket',
                                      metodo: 'put',
                                      id: widget.idTicket.toString());
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ListaTickets(id: widget.idRemitente),
                                  ),
                                );
                              },
                              child: Text('No, ya estaba resuelto'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo
                                // Aquí puedes agregar lógica para calificar al operador
                                // Por ejemplo, abrir otro diálogo para la calificación
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Calificar Operador'),
                                      content: StatefulBuilder(
                                        builder: (context, setDialogState) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'Por favor selecciona una calificación:'),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children:
                                                    List.generate(5, (index) {
                                                  return IconButton(
                                                    icon: Icon(
                                                      estrellas > index
                                                          ? Icons.star_rate_rounded
                                                          : Icons.star_border_rounded,
                                                      color: Colors.amber,
                                                    ),
                                                    onPressed: () {
                                                      setDialogState(() {
                                                        estrellas = index + 1;
                                                      });
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Cerrar el diálogo
                                            setState(() {
                                              // Aquí puedes enviar la calificación al servidor
                                              ApiService.solicitud(
                                                tabla: 'evaluacionServicio',
                                                metodo: 'post',
                                                cuerpo: {
                                                'id_ticket': widget.idTicket,
                                                'id_cliente': idCl,
                                                'id_operador': idOp,
                                                'calificacion': estrellas,
                                                },
                                              );
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                  ListaTickets(
                                                    id: widget.idRemitente),
                                              ),
                                            );
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Sí, calificar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: const Color(0xbbFD7238),
                    ),
                    height: 20,
                    width: 89,
                    child: Text(
                      'Cerrar Ticket',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 11),
                    ),
                  ),
                ))
        ]));
  }

  Future<String> obtenerEstadoTicketPorID(int id) async {
    final resultado = await ApiService.solicitud(
        tabla: 'tickets', metodo: 'get', id: id.toString());
    return resultado['estado_ticket'];
  }
  Future<bool> verificaCalificacion() async {
    var idO = await obtenerIDSTicket(widget.idTicket);
    final resultado = await ApiService.solicitud(
        tabla: 'evaluaciones_servicio',
        metodo: 'post',
        cuerpo: {'id_ticket':widget.idTicket, 'id_operador':idO['id_operador']});
    return resultado['success'];
  }

  Future<Map<String, dynamic>> obtenerIDSTicket(int id) async {
    final resultado = await ApiService.solicitud(
        tabla: 'tickets', metodo: 'get', id: id.toString());
    return {
      'id_operador': resultado['id_operador'],
      'id_cliente': resultado['id_cliente'],
    };
  }

  Future<List<dynamic>> insertarTicket(String mensaje) async {
    final resultado = await ApiService.solicitud(
        tabla: 'insertarMensaje',
        metodo: 'post',
        cuerpo: {
          'id_ticket': widget.idTicket,
          'id_remitente': widget.idRemitente,
          'mensaje': mensaje
        });
    await obtenerMensajesTicket();

    return resultado;
  }

  Future<int> obtenerIDUsuarioPorCliente() async {
    final resultado = await ApiService.solicitud(
        tabla: 'obtenerIDUsuarioPorClient',
        metodo: 'get',
        id: widget.idRemitente.toString());
    return resultado['usuario_id'];
  }
  Future<int> obtenerIDRolPorUsuario() async {
    final resultado = await ApiService.solicitud(
        tabla: 'obtenerIDUsuarioPorCliente',
        metodo: 'get',
        id: widget.idRemitente.toString());
    return resultado['id_rol'];
  }
  Future<String> obtenerRolUsuarioPorRemitente() async {
    final resultado = await ApiService.solicitud(
        tabla: 'obtenerIDUsuarioPorCliente',
        metodo: 'get',
        id: widget.idRemitente.toString());
    return resultado['rol'];
  }

  Future<void> obtenerMensajesTicket() async {
    final resultado = await ApiService.solicitud(
        tabla: 'obtenerMensajesTicket',
        metodo: 'get',
        id: widget.idTicket.toString());
    setState(() {
      _messages.clear();
      // _remitente.clear();
      for (var mensaje in resultado) {
        _messages.add({
          "mensaje": mensaje["mensaje"],
          "id_remitente": mensaje["id_remitente"]
        });
      }
    });
  }
}
