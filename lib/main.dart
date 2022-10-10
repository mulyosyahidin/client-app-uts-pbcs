import 'package:flutter/material.dart';
import 'package:pbcs_client_app/Models/mahasiswa_model.dart';
import 'package:pbcs_client_app/Pages/fakultas.dart';
import 'package:pbcs_client_app/Pages/new_mahasiswa.dart';
import 'package:pbcs_client_app/Pages/prodi.dart';
import 'package:pbcs_client_app/Services/mahasiswa_service.dart';
import 'package:pbcs_client_app/UI/mahasiswa_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mahasiswa'),
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
  late Future<List<MahasiswaModel>> mahasiswa =
      MahasiswaService().getMahasiswa();

  void _NewMahasiswa() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewMahasiswa()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Fakultas()),
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
      ),
      body: Center(
        child: FutureBuilder<List<MahasiswaModel>>(
          future: mahasiswa,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return RefreshIndicator(
              child: snapshot.hasData
                  ? MahasiswaList(items: snapshot.data!)
                  : Center(child: CircularProgressIndicator()),
              onRefresh: _pullRefresh,
            );
          },
        ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _NewMahasiswa,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      mahasiswa = MahasiswaService().getMahasiswa();
    });
  }
}
