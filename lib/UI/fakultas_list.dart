import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Models/fakultas_model.dart';
import 'package:pbcs_client_app/UI/fakultas_item.dart';

class FakultasList extends StatelessWidget {
  final List<FakultasModel> items;

  FakultasList({Key? key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return FakultasItem(item: items[index]);
      },
    );
  }
}
