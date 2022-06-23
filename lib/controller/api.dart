import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://52.87.209.179/api/';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  //metodo que revisa por tokens almacenados en el dispositivo
  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
  }

  // Metodo que realiza los POST
  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl, headers: _setHeaders());
  }

  putData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    //await _getToken();
    return await http.put(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
