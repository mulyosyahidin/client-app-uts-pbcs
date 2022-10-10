import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Pages/prodi.dart';
import 'package:pbcs_client_app/Services/prodi_service.dart';
import 'package:pbcs_client_app/Services/mahasiswa_service.dart';
import 'package:pbcs_client_app/main.dart';

void main(mahasiswaId) {
  runApp(EditMahasiswa(
    mahasiswaId: mahasiswaId,
  ));
}

class EditMahasiswa extends StatelessWidget {
  final int mahasiswaId;

  const EditMahasiswa({Key? key, required this.mahasiswaId}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Edit Mahasiswa',
        mahasiswaId: mahasiswaId,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int mahasiswaId;

  const MyHomePage({Key? key, required this.title, required this.mahasiswaId})
      : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(mahasiswaId: mahasiswaId);
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  final int mahasiswaId;

  _MyHomePageState({required this.mahasiswaId});

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Prodi()),
      );
    } else if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } else if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Prodi()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: NewForm(mahasiswaId: mahasiswaId),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Prodi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mahasiswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Mahasiswa',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NewForm extends StatefulWidget {
  int mahasiswaId;

  NewForm({required this.mahasiswaId});

  @override
  _AddForm createState() => _AddForm(mahasiswaId: mahasiswaId);
}

class _AddForm extends State<NewForm> {
  int mahasiswaId;

  List<dynamic> prodi = [];
  var prodiCurrentSelectedValue;

  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  final nameController = TextEditingController();
  final codeController = TextEditingController();

  String _name = '';
  String _code = '';
  String _prodiId = '';

  _AddForm({required this.mahasiswaId});

  @override
  void initState() {
    super.initState();

    ProdiService().getProdi().then((value) {
      setState(() {
        prodi = value;
      });
    });

    MahasiswaService().getMahasiswaById(mahasiswaId).then((value) {
      setState(() {
        var mahasiswa = jsonEncode(value);

        var id = jsonDecode(mahasiswa)['study_program_id'].toString();
        var nama = jsonDecode(mahasiswa)['name'];
        var npm = jsonDecode(mahasiswa)['npm'];

        nameController.text = nama;
        codeController.text = npm;

        _prodiId = id;
        prodiCurrentSelectedValue = id;
      });
    });
  }

  List<DropdownMenuItem<String>> prodiList = [];

  void loadProdiList() {
    prodiList = [];

    prodi.forEach((element) {
      var data = jsonEncode(element);

      var id = jsonDecode(data)['id'];
      var name = jsonDecode(data)['name'];

      prodiList.add(DropdownMenuItem(
        child: Text(name),
        value: id.toString(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    loadProdiList();

    return Form(
        key: _formKey,
        child: ListView(
          children: getFormWidget(),
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    formWidget.add(TextFormField(
      controller: nameController,
      decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Silahkan isi nama prodi';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _name = value.toString();
        });
      },
    ));

    formWidget.add(TextFormField(
      controller: codeController,
      decoration: const InputDecoration(labelText: 'NPM Mahasiswa'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Silahkan isi npm mahasiswa';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _code = value.toString();
        });
      },
    ));

    formWidget.add(DropdownButtonFormField<String>(
      validator: (value) => value == null ? 'Silahkan pilih prodi' : null,
      hint: Text('Pilih Program Studi'),
      items: prodiList.toList(),
      value: prodiCurrentSelectedValue,
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          _prodiId = value.toString();
          prodiCurrentSelectedValue = value;
        });
      },
    ));

    void onPressedSubmit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        print("Nama: " + nameController.text);
        print("NPM: " + codeController.text);
        print("Prodi: " + _prodiId.toString());

        MahasiswaService()
            .updateMahasiswa(mahasiswaId, _name, _code, _prodiId)
            .then((value) => {
                  if (value == true)
                    {
                      //delay 2 seconds before close keyboard
                      Future.delayed(const Duration(seconds: 5), () {
                        //close keyboard
                        FocusScope.of(context).requestFocus(FocusNode());
                      }),

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Berhasil memperbarui data'),
                        duration: const Duration(seconds: 2),
                      ))
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Gagal memperbarui data'),
                        duration: const Duration(seconds: 2),
                      ))
                    }
                });
      }
    }

    formWidget.add(ElevatedButton(
        child: const Text('Simpan'), onPressed: onPressedSubmit));

    return formWidget;
  }
}
