import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Pages/prodi.dart';
import 'package:pbcs_client_app/Services/prodi_service.dart';
import 'package:pbcs_client_app/Services/mahasiswa_service.dart';
import 'package:pbcs_client_app/Services/prodi_service.dart';
import 'package:pbcs_client_app/main.dart';

void main() {
  runApp(const NewMahasiswa());
}

class NewMahasiswa extends StatelessWidget {
  const NewMahasiswa({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tambah Mahasiswa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

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
        child: NewForm(),
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
  @override
  _AddForm createState() => _AddForm();
}

class _AddForm extends State<NewForm> {
  List<dynamic> prodi = [];
  var prodiCurrentSelectedValue;

  @override
  void initState() {
    super.initState();

    ProdiService().getProdi().then((value) {
      setState(() {
        prodi = value;
      });
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  final nameController = TextEditingController();
  final codeController = TextEditingController();

  String _name = '';
  String _code = '';
  int _prodiId = 0;

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

    formWidget.add(DropdownButton<String>(
      hint: Text('Pilih Program Studi'),
      items: prodiList.toList(),
      value: prodiCurrentSelectedValue,
      isExpanded: true,
      onChanged: (value) {
        print("add - prodi data");
        print(value);
        print(value.runtimeType);

        setState(() {
          _prodiId = int.parse(value.toString());
          prodiCurrentSelectedValue = value;
        });
      },
    ));

    void onPressedSubmit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        print("submitted data");
        print("Name " + _name);
        print("Code " + _code);
        print("Prodi " + _prodiId.toString());

        MahasiswaService()
            .addMahasiswa(_name, _code, _prodiId)
            .then((value) => {
                  if (value == true)
                    {
                      //delay 2 seconds before close keyboard
                      Future.delayed(const Duration(seconds: 5), () {
                        //close keyboard
                        FocusScope.of(context).requestFocus(FocusNode());
                      }),

                      nameController.clear(),
                      codeController.clear(),
                      setState(() {
                        prodiCurrentSelectedValue = null;
                      }),
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Berhasil menambahkan data'),
                        duration: const Duration(seconds: 2),
                      ))
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Gagal menambahkan data'),
                        duration: const Duration(seconds: 2),
                      ))
                    }
                });
      }
    }

    formWidget.add(ElevatedButton(
        child: const Text('Tambah'), onPressed: onPressedSubmit));

    return formWidget;
  }
}
