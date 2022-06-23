import 'dart:convert';

List<HorasMedicas> horasMedicasFromJson(String str) => List<HorasMedicas>.from(
    json.decode(str).map((x) => HorasMedicas.fromJson(x)));

String horasMedicasToJson(List<HorasMedicas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HorasMedicas {
  HorasMedicas({
    this.horaInicio,
    this.horaFinal,
    this.nroEspera,
  });

  String horaInicio;
  String horaFinal;
  int nroEspera;

  factory HorasMedicas.fromJson(Map<String, dynamic> json) => HorasMedicas(
        horaInicio: json["hora_inicio"],
        horaFinal: json["hora_final"],
        nroEspera: json["nro_espera"],
      );

  Map<String, dynamic> toJson() => {
        "hora_inicio": horaInicio,
        "hora_final": horaFinal,
        "nro_espera": nroEspera,
      };
}
