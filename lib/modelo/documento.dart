import 'dart:convert';

List<Documento> documentoFromJson(String str) =>
    List<Documento>.from(json.decode(str).map((x) => Documento.fromJson(x)));

String documentoToJson(List<Documento> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Documento {
  Documento({
    this.idDocumento,
    this.ruta,
    this.citaMedicaId,
  });

  int idDocumento;
  String ruta;
  int citaMedicaId;

  factory Documento.fromJson(Map<String, dynamic> json) => Documento(
    idDocumento: json["id_documento"],
    ruta: json["ruta"],
    citaMedicaId: json["cita_medica_id"],
  );

  Map<String, dynamic> toJson() => {
    "id_cesfam": idDocumento,
    "ruta": ruta,
    "cita_medica_id": citaMedicaId,
  };
}