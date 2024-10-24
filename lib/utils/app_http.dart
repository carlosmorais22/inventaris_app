import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

const host = "api-inventaris.uerr.edu.br";
// const host = "192.168.1.9:5000";
// const host = "192.168.94.188:5000";

// retorna bens para o tipo e texto do filtro
Future<Map<String, dynamic>> get(String endPoint) async {
  var url = Uri.https(host, endPoint);

  var response = await http.get(url);
  if (response.statusCode == 201) {
    return convert.jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return {};
  }
}

// retorna bens para o tipo e texto do filtro
Future<List<dynamic>> list(String endPoint) async {
  var url = Uri.https(host, endPoint, {'q': ''});

  var response = await http.get(url);
  print(response.statusCode);
  if (response.statusCode == 201) {
    print(response.body);
    return convert.jsonDecode(response.body) as List<dynamic>;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return [];
  }
}

// retorna bens para o tipo e texto do filtro
Future<http.Response> post(String endPoint, Object object) async {
  var body = convert.json.encode(object);
  var headers = {
    "Content-Type": "application/json",
    "accept": "application/json"
  };
  var url = Uri.https(host, endPoint, {'q': ''});

  return http.post(url, headers: headers, body: body);
}

// retorna bens para o tipo e texto do filtro
Future<http.Response> put(String endPoint, Object object) async {
  var body = convert.json.encode(object);
  var headers = {
    "Content-Type": "application/json",
    "accept": "application/json"
  };
  var url = Uri.https(host, endPoint);

  return http.put(url, headers: headers, body: body);
}
