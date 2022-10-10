import 'dart:convert';

class MahasiswaModel {
  int id;
  String name;
  String npm;
  int studyProgramId;
  Object studyProgram;

  MahasiswaModel({
    required this.id,
    required this.name,
    required this.npm,
    required this.studyProgramId,
    required this.studyProgram,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> map) {
    return MahasiswaModel(
      id: map["id"],
      name: map["name"],
      npm: map["npm"],
      studyProgramId: map["study_program_id"],
      studyProgram: map["study_program"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "npm": npm,
      "study_program_id": studyProgramId,
      "study_program": studyProgram,
    };
  }

  @override
  String toString() {
    return 'Mahasiswa{id: $id, name: $name, npm: $npm, study_program_id: $studyProgramId, study_program: $studyProgram}';
  }
}

List<MahasiswaModel> mahasiswaFromJson(String jsonData) {
  final data = json.decode(jsonData)['data'];

  return List<MahasiswaModel>.from(
      data.map((item) => MahasiswaModel.fromJson(item)));
}

String mahasiswaToJson(MahasiswaModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
