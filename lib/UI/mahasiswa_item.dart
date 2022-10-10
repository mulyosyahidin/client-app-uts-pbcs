import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Models/mahasiswa_model.dart';
import 'package:pbcs_client_app/Pages/edit_mahasiswa.dart';
import 'package:pbcs_client_app/Services/mahasiswa_service.dart';
import 'package:pbcs_client_app/main.dart';

class MahasiswaItem extends StatefulWidget {
  MahasiswaItem({required this.item});

  final MahasiswaModel item;

  @override
  State<MahasiswaItem> createState() => _MahasiswaItemState();
}

class _MahasiswaItemState extends State<MahasiswaItem> {
  var width = 110;
  var visible = false;

  //set widh state
  void setWidth(w) {
    setState(() {
      width = w;
    });
  }

  //set visible state
  void setVisible(v) {
    setState(() {
      visible = v;
    });
  }

  Widget build(BuildContext context) {
    var studyProgram = jsonEncode(widget.item.studyProgram);
    var studyProgramName = jsonDecode(studyProgram)['name'];

    return Container(
      height: width.toDouble(),
      child: GestureDetector(
        onTap: () {
          setState(() {
            setWidth(width == 110 ? 160 : 110);
            setVisible(visible == false ? true : false);
          });
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(50), // Image radius
                            child: Image.asset(
                              'assets/images/doraemon.png',
                              width: 30,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.item.npm,
                            ),
                            Text(
                              studyProgramName,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: visible,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                var id = widget.item.id;

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditMahasiswa(mahasiswaId: id),
                                    ));
                              },
                              child: Text('Edit'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                var id = widget.item.id;

                                // popup dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text('Hapus Mahasiswa?'),
                                    content: Text(
                                        'Yakin ingin menghapus mahasiswa? Tindakan ini tidak dapat dibatalkan.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          MahasiswaService()
                                              .deleteMahasiswa(id);

                                          Navigator.of(context).pop();

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyApp()));
                                        },
                                        child: Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('Hapus'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
