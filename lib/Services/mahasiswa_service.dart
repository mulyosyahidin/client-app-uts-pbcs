import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:pbcs_client_app/Models/mahasiswa_model.dart';
import 'package:pbcs_client_app/config.dart';

class MahasiswaService {
  final String baseUrl = Config.apiUrl;
  Client client = Client();

  Future<List<MahasiswaModel>> getMahasiswa() async {
    final response = await client.get(Uri.parse("$baseUrl/api/students"));

    if (response.statusCode == 200) {
      return mahasiswaFromJson(response.body);
    } else {
      return [];
    }
  }

  Future<bool> addMahasiswa(String name, String npm, int prodiId) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/students"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'npm': npm,
        'study_program_id': prodiId
      }),
    );

    print(response.body);

    if (jsonDecode(response.body)['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  //delete mahasiswa
  Future<bool> deleteMahasiswa(int id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/api/students/$id"),
    );

    print(response.body);

    if (jsonDecode(response.body)['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  //get mahasiswa by id
  Future<MahasiswaModel> getMahasiswaById(int id) async {
    final response = await client.get(Uri.parse("$baseUrl/api/students/$id"));

    if (response.statusCode == 200) {
      return MahasiswaModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      return MahasiswaModel(
        id: 0,
        name: '',
        npm: '',
        studyProgramId: 0,
        studyProgram: {},
      );
    }
  }

  //update mahasiswa
  Future<bool> updateMahasiswa(
      int id, String name, String npm, String prodiId) async {
    final response = await client.patch(
      Uri.parse("$baseUrl/api/students/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'npm': npm,
        'study_program_id': prodiId
      }),
    );

    print(response.body);

    if (jsonDecode(response.body)['success'] == true) {
      return true;
    } else {
      return false;
    }
  }
}
