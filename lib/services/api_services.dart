// import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {

  static Future<dynamic> solicitud({required String tabla, required String metodo, String id = '', String cuerpo = ''}) async {
    // final url = Uri.parse('http://127.0.0.1:8000/api/$tabla/$id');
    final url = Uri.parse('http://192.168.1.134:8000/api/$tabla/$id');
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
        print('como lo hiciste? :o no hay metodo');
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
