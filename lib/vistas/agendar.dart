import 'dart:convert';

import 'package:app_cesf/controller/api.dart';
import 'package:app_cesf/fechaKey.dart';
import 'package:app_cesf/horasM.dart';
import 'package:app_cesf/paciente.dart';
import 'package:app_cesf/vistas/nav-drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Agendar extends StatefulWidget {
  @override
  _AgendarState createState() => _AgendarState();
}

class _AgendarState extends State<Agendar> {
  bool _loading;
  String _fechasK;
  String _fechaKey;
  List<HorasMedicas> _horasM = [];
  HorasMedicas selectHora;
  Paciente _paciente;
  DateFormat formatterF = DateFormat('yyyy-MM-dd');
  DateFormat formatterF2 = DateFormat('dd-MM-yyyy');
  var now = new DateTime.now();
  String correo;
  String url;
  int id;
  Map cita;
  String id_sala;
  String especialidad_cesfam_id;

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        correo = user['email'];
        id = user['id'];
        url = 'paciente/$id';
      });
    }

    Future.wait<void>([
      getPaciente().then((paciente) {
        setState(() {
          _paciente = paciente;
        });
      })
    ]).then((value) async {
      _loading = true;
      Future.wait<void>([
        getMedicoGeneral().then((value) {
          setState(() {
            id_sala = value['id_sala'].toString();
            especialidad_cesfam_id = value['id_especialidad_cesfam'].toString();
          });
        }),
        getFechaxhora().then((fecha1) {
          setState(() {
            _fechasK = fecha1;
          });
        })
      ]).then((value) async {
        getHoras().then((horas) {
          setState(() {
            _horasM = horas;
            _loading = false;
          });
        });
      });
    });
  }

  Future<String> postCita() async {
    //Llama al api.authData, sirve para hacer el POST
    var response = await Network()
        .authData(cita, "agregarCitaMedica"); //cita es el Map con las variables
    print(response.body);
    print(response.statusCode);
  }

  Future<Paciente> getPaciente() async {
    try {
      var response = await Network().getData('$url');
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

  Future<String> getFechaxhora() async {
    String fecha = formatterF.format(now);
    try {
      var response = await Network().getData(
          'buscarFechasCitaParaPacientes/?id_especialidad_cesfam=1&fecha=${fecha}&id_paciente=${_paciente.idPaciente.toString()}');
      if (response.statusCode == 200) {
        print("Get fechaxhora");
        print(jsonDecode(response.body));
        String fecha1 = response.body;
        return fecha1;
      } else {
        return " ";
      }
    } catch (e) {
      return " ";
    }
  }

  Future<String> getNewDate(String newDate) async {
    print(newDate);
    try {
      var response = await Network().getData(
          'buscarFechasCitaParaPacientes/?id_especialidad_cesfam=1&fecha=${newDate}&id_paciente=${_paciente.idPaciente.toString()}');
      if (response.statusCode == 200) {
        print("Get fechaxhora");
        print(jsonDecode(response.body));
        String fecha1 = response.body;
        return fecha1;
      } else {
        return " ";
      }
    } catch (e) {
      return " ";
    }
  }

  Future<dynamic> getMedicoGeneral() async {
    try {
      var response = await Network()
          .getData('verMedicoGeneralCesfam/${_paciente.cesfamId.toString()}');
      if (response.statusCode == 200) {
        print("Get medico general");
        print(jsonDecode(response.body));
        var medicoGeneral = jsonDecode(response.body);
        return medicoGeneral[0];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<List<HorasMedicas>> getHoras() async {
    try {
      final formatDate = _fechasK.replaceAll('"', "");
      var response = await Network().getData(
          'buscarHorasCitaMedica/?fecha=${formatDate}&id_paciente=${_paciente.idPaciente.toString()}&id_especialidad_cesfam=1'); //Aqui va la fechaKey
      if (response.statusCode == 200) {
        print("Get horas");
        print(jsonDecode(response.body));
        List<HorasMedicas> horas = horasMedicasFromJson(response.body);

        return horas;
      } else {
        return List<HorasMedicas>();
      }
    } catch (e) {
      return List<HorasMedicas>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Solicitar hora', style: TextStyle(fontSize: 25)),
                  new Image.asset(
                    'assets/images/Logo.png',
                    height: 55,
                    width: 55,
                  )
                ],
              ),
            )),
        body: Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('assets/images/Fondo.png'),
                    fit: BoxFit.cover)),
            child: _paciente == null
                ? Center(
                    child: Text(
                      "Cargando datos...",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  )
                : Stack(
                    children: [
                      new Padding(
                          padding: EdgeInsets.all(20),
                          child: new Container(
                            decoration: BoxDecoration(color: Colors.white54,borderRadius: BorderRadius.circular(10),),
                          )),
                      new Padding(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 50, bottom: 30),
                        child: new Text(
                          "Nombre",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black54),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 80, bottom: 30),
                        child: new Text(
                          _paciente.nombres,
                          style: TextStyle(color: Colors.black45,
                              fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                      ),
                      new Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 120, bottom: 30),
                          child: new Text(
                            "RUT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black54)),
                          ),
                      new Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 150, bottom: 30),
                          child: new Text(_paciente.user.rut,
                              style: TextStyle(color: Colors.black45,
                                  fontWeight: FontWeight.bold, fontSize: 26))),
                      new Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            ButtonTheme(
                              minWidth: 170,
                              height: 60,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Text(
                                  "Solicitar",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                onPressed: () {
                                  _showMyDialog();
                                },
                              ),
                            ),
                          ]))
                    ],
                  )));
  }

  String genDate(int i) {
    try {
      if (i == 1) {
        String fecha = _fechasK;
        return fecha;
      }
      if (i == 2) {
        String fecha = _fechasK.substring(9, 11) +
            "-" +
            _fechasK.substring(6, 8) +
            "-" +
            _fechasK.substring(1, 5);
        return fecha;
      }
    } catch (e) {
      String fecha = _fechasK.substring(9, 11) +
          "-" +
          _fechasK.substring(6, 8) +
          "-" +
          _fechasK.substring(1, 5);
      return fecha;
    }
  }

  Future<void> _showMyDialog() async {
    String dropdownValue = 'Seleccione una cita';

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Agendar cita médica"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Selecciona la cita que más le acomode para el dia: " +
                      genDate(2)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<HorasMedicas>(
                        value: selectHora,
                        hint: Text("Seleccione una hora...   "),
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectHora = value;
                          });
                        },
                        items: _horasM.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.horaInicio.toString() +
                                " - " +
                                item.horaFinal.toString()),
                          );
                        }).toList(),
                      ),
                      IconButton(
                        icon: Icon(Icons.autorenew),
                        tooltip: 'Buscar otra fecha...',
                        onPressed: () {
                          getNewDate(_fechasK.replaceAll('"', ""))
                              .then((value) {
                            setState(() {
                                _fechasK = value;
                                selectHora = null;
                              });
                            getHoras().then((horas) {
                              setState(() {
                                _horasM = horas;
                              });
                            });
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            String fecha = formatterF.format(now);
                            getNewDate(fecha).then((value) {
                              _fechasK = value;
                              getHoras().then((horas) {
                                _horasM = horas;
                              });
                            });
                            Navigator.pop(context);
                          }),
                      ButtonTheme(
                          child: RaisedButton(
                              //Boton que acepta el agregar cita
                              child: Text(
                                "Aceptar",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                cita = {
                                  "nro_espera": selectHora.nroEspera,
                                  "fecha_inicio": _fechasK.replaceAll('"', "") +
                                      " " +
                                      selectHora.horaInicio,
                                  //Hora seleccionada + ":00", para darle el formato de la Api
                                  "fecha_final": _fechasK.replaceAll('"', "") +
                                      " " +
                                      selectHora.horaFinal,
                                  //Hora seleccionada + ":00", para darle el formato de la Api
                                  "especialidad_cesfam_id":
                                      especialidad_cesfam_id,
                                  "sala_id": id_sala,
                                  "paciente_id": _paciente.idPaciente,
                                };
                                print(cita);
                                postCita();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              }))
                    ],
                  )
                ],
              );
            }),
          );
        });
  }
}
