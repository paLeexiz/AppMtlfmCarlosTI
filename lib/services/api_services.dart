// import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String tabla;
  final String id;
  final String metodo;
  final String cuerpo;

  ApiService({
    required this.tabla,
    this.id = '',
    required this.metodo,
    this.cuerpo = ''
  });

  static Future<List<dynamic>> solicitud({required String tabla, String id = '', required String metodo, String cuerpo = ''}) async {
    final url = Uri.parse('urlapi$tabla/$id');
    dynamic response='';
    switch (metodo) {
      case 'get':
        response = await http.get(url);
        break;
      case 'post':
        // final headers = {'Content-type':'application/json'};
        // final body = jsonEncode(
        //   {
        //     'usuario': 'carlos.juarez',
        //     'password': '1234'
        //   }
        // );
        response = await http.post(url);
        break;
      case 'put':
        // final headers = {'Content-type':'application/json'};
        // final body = jsonEncode(
        //   {
        //     'usuario': 'carlos.juarez',
        //     'password': '1234'
        //   }
        // );
        response = await http.put(url);
        break;
      case 'delete':
        response = await http.delete(url);
        break;
      default:
        // print('como lo hiciste? :o');
        break;
    }
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'error: ${response.statusCode}: ${response.reasonPhrase}'
      );
    }
    // }else {
    //   return ;
    // }
    // final a = Future<Map<String, dynamic>>;
    // return [{'message': 'Credenciales incorrectas'}];
  }
}
