import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Models/fakultas_model.dart';

class FakultasItem extends StatelessWidget {
  FakultasItem({required this.item});

  final FakultasModel item;

  Widget build(BuildContext context) {
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
                            new Text(
                              "${item.name}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new Text(
                              "${item.code}",
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
