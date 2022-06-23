import 'dart:convert';

import 'package:app_cesf/cita.dart';
import 'package:app_cesf/controller/api.dart';
import 'package:app_cesf/vistas/nav-drawer.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_cesf/modelo/user.dart';
import 'package:http/http.dart' as http;
import '../paciente.dart';
import 'agendar.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter demo',
      theme: ThemeData(primaryColor: new Color(0xFF64B5F6)),
      home: Home(),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Cita>> getCitas() async {
    try {
      var response =
          await Network().getData('citasPaciente/${_paciente.idPaciente}');
      print(response.toString());
      if (200 == response.statusCode) {
        List<Cita> citas = citaFromJson(response.body);

        print(citas[0].pacienteId);
        return citas;
      } else {
        return List<Cita>();
      }
    } catch (e) {
      return List<Cita>();
    }
  }

  void _loginFiware() async {
    String username = 'f8af8d78-a588-4e47-80ae-840f38e1c600';
    String password = '6ce68922-2b1e-4895-ad31-409dfcc79262';
    print("logeando fiware");
    final http.Response response = await http.post(
      'https://fw-idm.smartaraucania.org/oauth2/token',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password'))
      },
      body: {
        'username': 'f.vogt01@ufromail.cl',
        'password': '!acetaminofeno123',
        'grant_type': 'password',
      },
    );
    var body = json.decode(response.body);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('fiwareToken', json.encode(body));
    print(body);
  }

  List<Cita> _citas;
  bool _loading;
  String correo;
  String url;
  User userData;
  int id;
  DateFormat formatterF;
  DateFormat formatterH;
  Paciente _paciente;

  @override
  void initState() {
    initializeDateFormatting();
    formatterF = DateFormat.yMMMMd('es_ES');
    formatterH = DateFormat('jm');
    _loadUserData();
    _loginFiware();
    super.initState();
    _loading = true;
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    print(user.toString());
    if (user != null) {
      setState(() {
        //nombre variable de vase de datos
        correo = user['email'];
        id = user['id'];
        url = 'citasPaciente/$id';
        userData = User.fromJson(user);
        print(userData.toString());
        Future.wait<void>([
          getPaciente(id).then((paciente) {
            setState(() {
              _paciente = paciente;
              print(_paciente);
            });
          })
        ]).then((value) async {
          getCitas().then((citas) {
            setState(() {
              _citas = citas;
              _loading = false;
            });
          });
        });
      });
    }
  }

  Future<Paciente> getPaciente(idPaciente) async {
    try {
      var response = await Network().getData('paciente/$idPaciente');
      if (response.statusCode == 200) {
        Paciente paciente = pacienteFromJson(response.body);
        print("Get paciente");
        print(jsonDecode(response.body));
        return paciente;
      } else {
        return Paciente();
      }
    } catch (e) {
      return Paciente();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: userData != null ? NavDrawer(correo) : Container(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mis citas', style: TextStyle(fontSize: 25)),
                new Image.asset(
                  'assets/images/Logo.png',
                  height: 55,
                  width: 55,
                )
              ],
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Fondo.png"),
                fit: BoxFit.cover)),
        child: _citas == null
            ? Center(
                child: Text(
                  "Cargando datos...",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              )
            : ListView.builder(
                itemCount: null == _citas ? 0 : _citas.length,
                itemBuilder: (context, index) {
                  Cita cita = _citas[index];
                  String fecha = formatterF.format(cita.fechaInicio);
                  String hora1 = formatterH.format(cita.fechaInicio);
                  String hora2 = formatterH.format(cita.fechaFinal);
                  String fechaS = formatterF.format(cita.fechaInicio);
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(10),
                    child: Card(
                        elevation: 5,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                EdgeInsets.only(right: 16.0, top: 16),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(""),
                                    Text(fecha,
                                        style: TextStyle(fontSize: 15))
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(Icons.assignment_ind),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(cita.nombreEspecialidad),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(Icons.assignment),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                            "A las " + hora1 + " - " + hora2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(Icons.local_hospital),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(cita.sala.nombrePabellon),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(Icons.info_outline),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                            "Sala " + cita.sala.nombreSala),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      children: <Widget>[

                                        SizedBox(height: 7.0),
                                        FlatButton(
                                          color: Colors.deepPurpleAccent,
                                          textColor: Colors.white,
                                          padding: EdgeInsets.all(8.0),
                                          onPressed: () {
                                            _showMyDialog(cita.idCitaMedica);
                                          },
                                          child: Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Icon(Icons.close,
                                                          size: 16),
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text: " Cancelar hora",
                                                        style: TextStyle(
                                                            fontSize: 15, fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Agendar()));
        },
        backgroundColor: Colors.deepPurpleAccent[200],
        icon: Icon(Icons.add,color: Colors.white,),
        label: Text('Solicitar Cita',style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Future<void> _showMyDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancelacion de cita médica'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Seguro que quieres cancelar la cita medica id ' +
                    id.toString() +
                    '?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.red,
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                cancelarCita(id);
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void cancelarCita(int id) async {
    debugPrint("Se va a eliminar cita " + id.toString());
    var res = await Network().putData('cancelarCita/' + id.toString());
    debugPrint(res.body);
  }
}
