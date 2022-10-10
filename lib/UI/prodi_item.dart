import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Models/prodi_model.dart';

class ProdiItem extends StatelessWidget {
  ProdiItem({required this.item});

  final ProdiModel item;

  Widget build(BuildContext context) {
    var faculty = jsonEncode(item.faculty);
    var facultyName = faculty.split(',')[1].split(':')[1].replaceAll('"', '');

    return Container(
      height: 100,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.amber,
              width: 10,
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  print('testing');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo-unib.png',
                          width: 60,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item.code,
                            ),
                            Text(
                              facultyName,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
