import 'dart:convert';

class ProdiModel {
  int id;
  String name;
  String code;
  int facultyId;
  Object faculty;

  ProdiModel({
    required this.id,
    required this.name,
    required this.code,
    required this.facultyId,
    required this.faculty,
  });

  factory ProdiModel.fromJson(Map<String, dynamic> map) {
    return ProdiModel(
      id: map["id"],
      name: map["name"],
      code: map["code"],
      facultyId: map["faculty_id"],
      faculty: map["faculty"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "code": code,
      "faculty_id": facultyId,
      "faculty": faculty
    };
  }

  @override
  String toString() {
    return 'Prodi{id: $id, name: $name, code: $code, faculty_id: $facultyId, faculty: $faculty}';
  }
}

List<ProdiModel> prodiFromJson(String jsonData) {
  final data = json.decode(jsonData)['data'];

  return List<ProdiModel>.from(data.map((item) => ProdiModel.fromJson(item)));
}

String prodiToJson(ProdiModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
