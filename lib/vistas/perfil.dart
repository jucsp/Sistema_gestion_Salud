import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:app_cesf/modelo/user.dart';
import 'package:app_cesf/modelo/paciente.dart';
import 'package:app_cesf/modelo/cesfam.dart';
import 'package:app_cesf/modelo/medicamento.dart';
import 'package:app_cesf/modelo/enfermedad.dart';
import 'package:app_cesf/modelo/documento.dart';
import 'package:app_cesf/modelo/cita.dart';
import 'package:app_cesf/vistas/detalleCita.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_cesf/controller/api.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> with SingleTickerProviderStateMixin {
  User userData;
  Paciente pacienteData;
  Cesfam cesfamData;
  List<Cita> citaData;
  List<Medicamento> medicamentosData;
  List<Enfermedad> enfermedadesData;
  TabController _controller;
  int _selectedIndex = 0;
  DateFormat formatterF;
  DateFormat formatterH;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    formatterF = DateFormat.yMMMMd('es_ES');
    formatterH = DateFormat('jm');
    getUserData();
    _controller = new TabController(length: 3, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: userData != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _contenedorImangen(),
                      PreferredSize(
                        preferredSize: Size.fromHeight(50.0),
                        child: tabsPerfil(),
                      ),
                      pacienteData != null && cesfamData != null
                          ? Expanded(
                              child: TabBarView(
                                controller: _controller,
                                children: [
                                  _contenedorFicha(),
                                  _antecedentesMedicos(),
                                  _contenedorCitas() // class name
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text("Cargando datos de paciente"),
                                )
                              ],
                            ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text("Cargando datos"),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget tabsPerfil() {
    return TabBar(
      controller: _controller,
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: true,
      indicatorWeight: 4.0,
      indicatorColor: Colors.deepPurpleAccent,
      labelColor: Colors.deepPurpleAccent,
      unselectedLabelColor: Color(0xff837E7E),
      tabs: [
        Tab(
            icon: FaIcon(FontAwesomeIcons.idCard),
            child: Text('Datos Personales')),
        Tab(
          icon: FaIcon(FontAwesomeIcons.bookMedical),
          child: Text(
            'Antecedentes Medicos',
          ),
        ),
        Tab(
          icon: FaIcon(FontAwesomeIcons.clinicMedical),
          child: Text(
            'Citas Médicas',
          ),
        ),
      ],
    );
  }

  Widget _contenedorFicha() {
    var screenSize = MediaQuery.of(context).size;
    return Row(children: [
      Container(
        margin: EdgeInsets.only(bottom: 50),
        padding: EdgeInsets.all(10.0),
        width: screenSize.width,
        height: 500,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.userAlt,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xff9b5de5),
                    ),
                    title: Text(
                      "Nombres",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    subtitle: Text(
                        pacienteData.nombres + " " + pacienteData.apellidos),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.solidEnvelope,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.purple[300],
                    ),
                    title: Text("Correo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(userData.email),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.solidAddressCard,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xffdd389d),
                    ),
                    title: Text("Rut",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(userData.rut),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.calendarDay,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.pinkAccent[400],
                    ),
                    title: Text("Fecha de nacimiento",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(formatterF
                        .format(pacienteData.fechaNacimiento)
                        .toString()),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.birthdayCake,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    title: Text("Edad",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.edad.toString()),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.venusMars,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xffff6d00),
                    ),
                    title: Text("Sexo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.sexo),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.solidFlag,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.amberAccent[400],
                    ),
                    title: Text("Nacionalidad",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.nacionalidad),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.globeAmericas,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xffA0E426),
                    ),
                    title: Text("Lugar de nacimiento",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.lugarNacimiento),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xff52E3E1),
                    ),
                    title: Text("Dirección",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.direccion),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xff33A8C7),
                    ),
                    title: Text("Telefono Celular",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.telefonoCelular),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.mobileAlt,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    title: Text("Telefono Casa",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.telefonoCasa),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _antecedentesMedicos() {
    var screenSize = MediaQuery.of(context).size;
    return Row(children: [
      Container(
        margin: EdgeInsets.only(bottom: 50),
        padding: EdgeInsets.all(10.0),
        width: screenSize.width,
        height: 500,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.solidPlusSquare,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xff9b5de5),
                    ),
                    title: Text("Sistema de Salud",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.sistemaSalud),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.solidHospital,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.pinkAccent[400],
                    ),
                    title: Text("Cesfam",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(cesfamData.nombreCesfam),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.tint,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xffff6d00),
                    ),
                    title: Text("Grupo Sanguíneo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Text(pacienteData.grupoSanguineo),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.capsules,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.amberAccent[400],
                    ),
                    title: Text("Medicamentos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        medicamentosData == null
                            ? Text("No toma medicamentos")
                            : Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i in medicamentosData)
                                      Column(
                                        children: [
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                                accentColor: Colors.black87,
                                                dividerColor:
                                                    Colors.transparent),
                                            child: ListTileTheme(
                                              contentPadding: EdgeInsets.all(0),
                                              child: ExpansionTile(
                                                title: Text(
                                                  i.nombreMedicamento,
                                                ),
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                      i.indicacion,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey),
                                        ],
                                      )
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: FaIcon(
                        FontAwesomeIcons.virus,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    title: Text("Enfermedades Crónicas",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        enfermedadesData == null
                            ? Text("No tiene enfermedades")
                            : Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i in enfermedadesData)
                                      Column(
                                        children: [
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                                accentColor: Colors.black87,
                                                dividerColor:
                                                    Colors.transparent),
                                            child: ListTileTheme(
                                              contentPadding: EdgeInsets.all(0),
                                              child: ExpansionTile(
                                                title: Text(i.nombreEnfermedad),
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                        "Fecha declarada:"),
                                                    subtitle: Text(
                                                        formatterF
                                                            .format(
                                                                i.fechaInicio)
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black54)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey)
                                        ],
                                      )
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _contenedorImangen() {
    return Container(
        height: 200,
        padding: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://i.ibb.co/6gkFGJQ/coronavirus-covid-2019-sobre-fondo-morado-181623-43.jpg"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 130,
              height: 130,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Color(0xffF67272),
                  image: DecorationImage(
                    image: NetworkImage("https://i.ibb.co/3Y7Hm0B/abuela.png"),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4)),
            ),
            Text(
              userData.email,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget _contenedorCitas() {
    return citaData == null
        ? Container(
            child: Center(
              child: Text("No tiene citas medicas"),
            ),
          )
        : Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: citaData.length,
                      itemBuilder: (context, index) {
                        String fecha =
                            formatterF.format(citaData[index].fechaInicio);
                        String hora1 =
                            formatterH.format(citaData[index].fechaInicio);
                        String hora2 =
                            formatterH.format(citaData[index].fechaFinal);
                        return GestureDetector(
                          onTap: () => {
                          Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => DetalleCita(citaData[index])),)
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            height: 280,
                            width: double.maxFinite,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                fecha,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.0),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Icon(
                                                      Icons.assignment_ind),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    citaData[index]
                                                        .nombreEspecialidad,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Icon(Icons.alarm),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    hora1 + '-' + hora2,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Icon(
                                                      Icons.local_hospital),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    cesfamData.nombreCesfam,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Icon(Icons.home),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    citaData[index]
                                                            .sala
                                                            .nombrePabellon +
                                                        " - Sala " +
                                                        citaData[index]
                                                            .sala
                                                            .nombreSala,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 90.0,
                )
              ],
            ),
          );
  }

  void getUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        userData = User.fromJson(user);
        print(userData.id);
        _getPaciente(userData.id);
      });
    }
  }

  Future<void> _getPaciente(id) async {
    var response = await Network().getData('paciente/${id.toString()}');
    var jsonPaciente = null;
    if (response.statusCode == 200) {
      jsonPaciente = json.decode(response.body);
      setState(() {
        pacienteData = Paciente.fromJson(jsonPaciente);
        _cesfamPaciente(pacienteData.cesfamId);
        _enfermedadesPaciente(pacienteData.idPaciente);
        _medicamentoPaciente(pacienteData.idPaciente);
        _citasPaciente(pacienteData.idPaciente);
      });
    } else {
      setState(() {
        pacienteData = null;
      });
    }
  }

  void _cesfamPaciente(id) async {
    var response = await Network().getData('verCesfam/${id.toString()}');
    var jsonCesfam = null;
    if (response.statusCode == 200) {
      jsonCesfam = json.decode(response.body);
      setState(() {
        cesfamData = Cesfam.fromJson(jsonCesfam);
      });
    } else {
      setState(() {
        cesfamData = null;
      });
    }
  }

  void _enfermedadesPaciente(id) async {
    var response =
        await Network().getData('paciente/enfermedades/${id.toString()}');
    if (response.statusCode == 200) {
      setState(() {
        enfermedadesData = enfermedadFromJson(response.body);
      });
    } else {
      setState(() {
        enfermedadesData = null;
      });
    }
  }

  void _medicamentoPaciente(id) async {
    var response =
        await Network().getData('paciente/medicamentos/${id.toString()}');
    if (response.statusCode == 200) {
      setState(() {
        medicamentosData = medicamentoFromJson(response.body);
      });
    } else {
      setState(() {
        medicamentosData = null;
      });
    }
  }

  void _citasPaciente(id) async {
    var response =
        await Network().getData('citasFinalizadasPaciente/${id.toString()}');
    if (response.statusCode == 200) {
      setState(() {
        citaData = citaFromJson(response.body);
      });
    } else {
      setState(() {
        citaData = null;
      });
    }
  }

  Future<List<Documento>> _documentosCita(id) async {
    print(id);
    List<Documento> documentosData;
    var response = await Network().getData('verDocumentosCita/${id.toString()}');
    if (response.statusCode == 200) {
        print(response.body);
        documentosData = documentoFromJson(response.body);
        if(documentosData.length==0){
          return documentosData=[];
        }else{
          print("hay");
        }

        return documentosData;
    } else {
        documentosData = [];
        return documentosData;
    }
  }
}
