import 'package:flutter/material.dart';

class ListaTickets extends StatelessWidget {
  const ListaTickets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de tickets'),
      ),
      body: const Center(
        child: Text('Aquí se mostrará la lista de tickets'),
      ),
    );
  }
}
//comentario