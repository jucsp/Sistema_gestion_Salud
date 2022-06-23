import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_cesf/vistas/covid-background.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'nav-drawer.dart';

class Covid extends StatefulWidget {
  @override
  _CovidState createState() => _CovidState();
}

class _CovidState extends State<Covid> {
  String correo = '';
  int activos;
  int confirmados;
  int fallecidos;
  String cuarentena = '';
  var activosArray = [];

  @override
  void initState() {
    super.initState();

    _loadUserData();
    _loadCovidData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        correo = user['email'];
      });
    }
  }

  _loadCovidData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('fiwareToken'));
    print(token);

    final http.Response response = await http.get(
      'https://fw-producer.smartaraucania.org/orion-north/v2/entities/?id=covid19:Temuco',
      headers: <String, String>{
        'X-Auth-Token': token['access_token'],
        'fiware-service': 'opendata',
        'fiware-servicepath': '/covid19/chile/comunas',
      },
    );

    if (response.statusCode == 200) {
      var datos = jsonDecode(response.body);
      activos = datos[0]['activos']['value'];
      setState(() {
        confirmados = datos[0]['confirmados']['value'];
        fallecidos = datos[0]['fallecidos']['value'];

        var cuarentenaStatus = datos[0]['quarantine']['value'];
        if (cuarentenaStatus) {
          cuarentena = "EN CUARENTENA";
        } else {
          cuarentena = "SIN CUARENTENA";
        }
        activosArray = datos[0]['series']['value']['activos'].reversed.toList();
      });
    }
  }

  SliverList _getSlivers(List myList, BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return buildRow(myList[index]);
        },
        childCount: myList.length,
      ),
    );
  }

  buildRow(item) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor))
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 25, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['date'],
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      decoration: TextDecoration.none)),
              Text(item['value'].toString(),
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      decoration: TextDecoration.none))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Covid en Temuco "),
            pinned: true,
            elevation: 10,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  CovidBackground(activos, confirmados, fallecidos, cuarentena),
            ),
          ),
          SliverAppBar(
              title: Text("Datos historicos",
                  style: TextStyle(color: Colors.black87)),
              backgroundColor: Colors.grey[100],
              automaticallyImplyLeading: false),
          _getSlivers(activosArray, context),
        ],
      ),
    );
  }
}
