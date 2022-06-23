import 'dart:convert';

List<FechaKey> fechaKeyFromJson(String str) =>
    List<FechaKey>.from(json.decode(str).map((x) => FechaKey.fromJson(x)));

String fechaKeyToJson(List<FechaKey> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FechaKey {
  FechaKey({
    this.fecha,
  });

  DateTime fecha;

  factory FechaKey.fromJson(Map<String, dynamic> json) => FechaKey(
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
      };
}
