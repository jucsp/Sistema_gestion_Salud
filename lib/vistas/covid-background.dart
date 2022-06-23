import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CovidBackground extends StatefulWidget {

  final int activos;
  final int confirmados;
  final int fallecidos;
  final String cuarentena;

  CovidBackground(this.activos, this.confirmados, this.fallecidos, this.cuarentena);

  @override
  State<StatefulWidget> createState() => CovidBackgroundState();
}

class CovidBackgroundState extends State<CovidBackground> {
  final double appBarHeight = 66.0;
  String correo = '';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight + 50),
      height: statusBarHeight + appBarHeight,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: new Image.asset(
                'assets/images/virus.png',
                height: 70,
                width: 70,
              ),
            ),
            Text(widget.cuarentena,
                style: TextStyle(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Confirmados",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(widget.confirmados.toString(), style: TextStyle(color: Colors.white))
                    ],
                  ),
                  Column(
                    children: [
                      Text("Activos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(
                        widget.activos.toString(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("Fallecidos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(widget.fallecidos.toString(), style: TextStyle(color: Colors.white))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
