import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Models/prodi_model.dart';
import 'package:pbcs_client_app/UI/prodi_item.dart';

class ProdiList extends StatelessWidget {
  final List<ProdiModel> items;

  ProdiList({Key? key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ProdiItem(item: items[index]);
      },
    );
  }
}