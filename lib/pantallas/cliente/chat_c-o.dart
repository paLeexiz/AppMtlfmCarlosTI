// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

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
  late TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  int id_usuario = 0;
  // final List<int> _remitente = [];
  // void _sendMessage() {
  //   if (_controller.text.isNotEmpty) {
  //     setState(() {
  //       _messages.add(_controller.text);
  //       _controller.clear();
  //     });
  //   }
  // }
  @override
  void initState() {
    super.initState();
    obtenerMensajesTicket();
    obtenerIDUsuario();
    actualizarLeidoMensaje();
  }

  Future<void> obtenerIDUsuario() async {
    id_usuario = await obtenerIDUsuarioPorCliente();
  }
  Future<void> actualizarLeidoMensaje() async {
    /*final resultado = */await ApiService.solicitud(
        tabla: 'actualizarLeidoMensaje',
        metodo: 'put',
        cuerpo: {
          'id_ticket' : widget.idTicket.toString(),
          'id_remitente' : id_usuario
        });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.idTicket);
    print('$_messages quiqaqui aqui');

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
                    print(id_usuario);
                    print(_messages[_messages.length - 1 - index]
                            ['id_remitente']
                        .toString());
                    var align;
                    var radio;
                    var colorsito;

                    if (_messages[_messages.length - 1 - index]
                            ['id_remitente'] ==
                        id_usuario) {
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
              top: 22,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: const Color(0xFFFFCE26),
                ),
                height: 20,
                width: 70,
              ))
        ]));
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
        tabla: 'obtenerIDUsuarioPorCliente',
        metodo: 'get',
        id: widget.idRemitente.toString());
    return resultado['usuario_id'];
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
