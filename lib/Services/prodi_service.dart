import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:pbcs_client_app/Models/prodi_model.dart';
import 'package:pbcs_client_app/config.dart';

class ProdiService {
  final String baseUrl = Config.apiUrl;
  Client client = Client();

  Future<List<ProdiModel>> getProdi() async {
    final response = await client.get(Uri.parse("$baseUrl/api/study-programs"));

    if (response.statusCode == 200) {
      return prodiFromJson(response.body);
    } else {
      return [];
    }
  }

  Future<bool> addProdi(String name, String code, int facultyId) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/study-programs"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'code': code,
        'faculty_id': facultyId
      }),
    );

    if (jsonDecode(response.body)['success'] == true) {
      return true;
    } else {
      return false;
    }
  }
}
