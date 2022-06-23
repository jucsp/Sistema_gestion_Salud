// To parse this JSON data, do
//
//     final cesfam = cesfamFromJson(jsonString);

import 'dart:convert';

List<Cesfam> cesfamFromJson(String str) =>
    List<Cesfam>.from(json.decode(str).map((x) => Cesfam.fromJson(x)));

String cesfamToJson(List<Cesfam> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cesfam {
  Cesfam({
    this.idCesfam,
    this.nombreCesfam,
    this.direccin,
    this.comuna,
    this.ciudad,
    this.region,
    this.telefono,
    this.createdAt,
    this.updatedAt,
  });

  int idCesfam;
  String nombreCesfam;
  String direccin;
  String comuna;
  String ciudad;
  String region;
  String telefono;
  DateTime createdAt;
  dynamic updatedAt;

  factory Cesfam.fromJson(Map<String, dynamic> json) => Cesfam(
        idCesfam: json["id_cesfam"],
        nombreCesfam: json["nombre_cesfam"],
        direccin: json["dirección"],
        comuna: json["comuna"],
        ciudad: json["ciudad"],
        region: json["region"],
        telefono: json["telefono"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id_cesfam": idCesfam,
        "nombre_cesfam": nombreCesfam,
        "dirección": direccin,
        "comuna": comuna,
        "ciudad": ciudad,
        "region": region,
        "telefono": telefono,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
