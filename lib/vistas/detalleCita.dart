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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_cesf/controller/api.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetalleCita extends StatefulWidget {
  final Cita cita;

  DetalleCita(this.cita);

  @override
  DetalleCitaState createState() => DetalleCitaState();
}

class DetalleCitaState extends State<DetalleCita>
    with SingleTickerProviderStateMixin {
  List<Documento> documentosData;
  DateFormat formatterF;
  DateFormat formatterH;
  @override
  void initState() {
    super.initState();
    _documentosCita(widget.cita.idCitaMedica);
    initializeDateFormatting();
    formatterF = DateFormat.yMMMMd('es_ES');
    formatterH = DateFormat('jm');
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
              child: Column(
                children: [Expanded(child: _contenedorCitas())],
              )),
        ),
      ),
    );
  }

  Widget _contenedorCitas() {
    String fecha = formatterF.format(widget.cita.fechaInicio);
    String hora1 = formatterH.format(widget.cita.fechaInicio);
    String hora2 = formatterH.format(widget.cita.fechaFinal);
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child:  Container(
            padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cita " + widget.cita.nombreEspecialidad,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18,color: Colors.deepPurpleAccent)),
                    Text(fecha + " a las " + hora1 + ' - ' + hora2,
                        style: TextStyle(
                            fontSize: 16, color: Colors.black54)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Observacion",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black54),
                    ),
                    Text(widget.cita.observacion,
                        style: TextStyle(
                            fontSize: 16, color: Colors.black54)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Documentos",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black54),
                    ),
                    documentosData != null
                        ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: documentosData.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ChoiceChip(
                                label: Text(cortarCadena(documentosData[index].ruta)[3]),
                                selected: true,
                                onSelected: (bool selected) {
                                  setState(() {
                                  });
                                },
                              ),
                            ],
                          );
                        })
                        : Text("No hay documentos"),
                  ],
                ),
              ],
          ),
        ),
      ),
    );
  }

  List<String> cortarCadena(cadena){
    List<String> arr = cadena.split('/');
    return arr;
  }
  void _documentosCita(id) async {
    print(id);
    var response =
        await Network().getData('verDocumentosCita/${id.toString()}');
    if (response.statusCode == 200) {
      setState(() {
        documentosData = documentoFromJson(response.body);
        if(documentosData.length==0){
          documentosData = null;
        }

      });
    } else {
      setState(() {
        documentosData = null;
      });
    }
  }
}
