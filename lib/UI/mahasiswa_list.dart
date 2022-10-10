import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Models/mahasiswa_model.dart';
import 'package:pbcs_client_app/UI/mahasiswa_item.dart';

class MahasiswaList extends StatelessWidget {
  final List<MahasiswaModel> items;

  MahasiswaList({Key? key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MahasiswaItem(item: items[index]);
      },
    );
  }
}