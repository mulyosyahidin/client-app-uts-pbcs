import 'dart:convert';

class FakultasModel {
  int id;
  String name;
  String code;

  FakultasModel({required this.id, required this.name, required this.code});

  factory FakultasModel.fromJson(Map<String, dynamic> map) {
    return FakultasModel(id: map["id"], name: map["name"], code: map["code"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "code": code};
  }

  @override
  String toString() {
    return 'Fakultas{id: $id, name: $name, code: $code}';
  }
}

List<FakultasModel> fakultasFromJson(String jsonData) {
  final data = json.decode(jsonData)['data'];

  return List<FakultasModel>.from(data.map((item) => FakultasModel.fromJson(item)));
}

String fakultasToJson(FakultasModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
