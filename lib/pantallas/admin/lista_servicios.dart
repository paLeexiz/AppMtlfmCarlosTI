import 'package:appmltpltfrm_carlos_ti/services/api_services.dart';
import 'package:flutter/material.dart';

class ListaServicios extends StatefulWidget {
  @override
  _ListaServiciosState createState() => _ListaServiciosState();
}

class _ListaServiciosState extends State<ListaServicios> {
  late Future<List<dynamic>> _serviciosFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Servicios'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<dynamic>>(
            future: obtieneServicios(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay servicios disponibles'));
              } else {
                final servicios = snapshot.data!;
                return Stack(children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 1100) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 3,
                          ),
                          itemCount: servicios.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(servicios[index]),
                              ),
                            );
                          },
                        );
                      } else if (constraints.maxWidth > 750) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 3,
                          ),
                          itemCount: servicios.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(servicios[index]),
                              ),
                            );
                          },
                        );
                      } else if (constraints.maxWidth > 500) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 3,
                          ),
                          itemCount: servicios.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(servicios[index]),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 79,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 14, right: 14, left: 14, bottom: 3),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 156, 156, 156)),
                                      helperText: '(Presione Enter para crear)',
                                      helperStyle: TextStyle(
                                          color: const Color(0xFF3C91E6)),
                                      constraints:
                                          BoxConstraints.expand(width: 200),
                                      hintText: 'Crea un nuevo servicio',
                                    ),
                                    textInputAction:
                                        TextInputAction.unspecified,
                                    onSubmitted: (value) {
                                      print('entro');
                                      setState(() {
                                        creaServicio(value);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: servicios.length,
                                itemBuilder: (context, index) {
                                  print(servicios[index]['nombre_service']);
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      title: Text(
                                          servicios[index]['nombre_service']),
                                      trailing: IconButton(
                                          icon: Icon(Icons.more_vert),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading:
                                                              Icon(Icons.edit),
                                                          title: Text('Editar'),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            String nuevoNombre =
                                                                '';

                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    actions: [
                                                                      SizedBox(
                                                                        height:
                                                                            19,
                                                                      ),
                                                                      TextField(
                                                                        decoration: InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            labelText:
                                                                                'Nuevo nombre',
                                                                            hintText:
                                                                                'Ingrese el nuevo nombre del servicio',
                                                                            hintStyle:
                                                                                TextStyle(fontSize: 11)),
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            nuevoNombre =
                                                                                value;
                                                                          });
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                          child: Text(
                                                                              'Aceptar'),
                                                                          onPressed:
                                                                              () {
                                                                                print(servicios[index]['id']);
                                                                              Navigator.of(context).pop();
                                                                            setState(() {
                                                                              editaServicio(servicios[index]['id'], nuevoNombre);
                                                                            });
                                                                           })
                                                                    ],
                                                                  );
                                                                });

                                                            // Lógica para editar el servicio
                                                          },
                                                        ),
                                                        ListTile(
                                                            leading: Icon(
                                                                Icons.delete),
                                                            title: Text(
                                                                'Eliminar'),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                        title: Text(
                                                                            'Confirmar eliminación'),
                                                                        content:
                                                                            Text('¿Está seguro de que desea eliminar este servicio?'),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            child:
                                                                                Text('Cancelar'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                              child: Text('Eliminar'),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  Navigator.of(context).pop();

                                                                                  eliminaServicio(servicios[index]['id']);
                                                                                });
                                                                              })
                                                                        ]);
                                                                  });
                                                            })
                                                      ]);
                                                });
                                          }),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ]);
              }
            },
          ),
        ));
  }

  Future<List<dynamic>> obtieneServicios() async {
    final resultado = await ApiService.solicitud(
      tabla: 'servicios',
      metodo: 'get',
    );
    return resultado;
  }

  Future<void> creaServicio(value) async {
    final resultado = await ApiService.solicitud(
        tabla: 'crearServicio', metodo: 'post', cuerpo: {'nombre': value});
    // return resultado;
  }

  Future<void> eliminaServicio(id) async {
    final resultado = await ApiService.solicitud(
        tabla: 'eliminarServicio', metodo: 'delete', id: id.toString());
    // return resultado;
  }

  Future<void> editaServicio(id, nombre) async {
    final resultado = await ApiService.solicitud(
        tabla: 'editarServicio',
        metodo: 'put',
        id: id.toString(),
        cuerpo: {'nombre': nombre});
    // return resultado;
  }
}
