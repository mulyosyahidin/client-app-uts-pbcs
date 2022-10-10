import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Pages/fakultas.dart';
import 'package:pbcs_client_app/Pages/prodi.dart';
import 'package:pbcs_client_app/Services/fakultas_service.dart';
import 'package:pbcs_client_app/main.dart';

void main() {
  runApp(const NewFakultas());
}

class NewFakultas extends StatelessWidget {
  const NewFakultas({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tambah Fakultas'),
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Fakultas()),
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
              MaterialPageRoute(builder: (context) => const Fakultas()),
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
            label: 'Fakultas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mahasiswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Prodi',
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
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  final nameController = TextEditingController();
  final codeController = TextEditingController();

  String _name = '';
  String _code = '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
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
      decoration: const InputDecoration(labelText: 'Nama Fakultas'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Silahkan isi nama fakultas';
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
      decoration: const InputDecoration(labelText: 'Kode Fakultas'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Silahkan isi kode fakultas';
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

    void onPressedSubmit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        print("Name " + _name);
        print("Code " + _code);

        FakultasService().addFakultas(_name, _code).then((value) => {
              if (value == true)
                {
                  FocusManager.instance.primaryFocus?.unfocus(),
                  nameController.clear(),
                  codeController.clear(),
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
