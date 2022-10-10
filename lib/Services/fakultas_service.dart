import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:pbcs_client_app/Models/fakultas_model.dart';
import 'package:pbcs_client_app/config.dart';

class FakultasService {
  final String baseUrl = Config.apiUrl;
  Client client = Client();

  Future<List<FakultasModel>> getFakultas() async {
    final response = await client.get(Uri.parse("$baseUrl/api/faculties"));

    if (response.statusCode == 200) {
      return fakultasFromJson(response.body);
    } else {
      return [];
    }
  }

  Future<bool> addFakultas(String name, String code) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/faculties"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name, 'code': code}),
    );

    if (jsonDecode(response.body)['success'] == true) {
      return true;
    } else {
      return false;
    }
  }
}
