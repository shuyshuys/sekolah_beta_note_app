import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sekolah_beta_note_app/edit_page.dart';
import 'package:sekolah_beta_note_app/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
          title: 'Aplikasi Simpel Penyimpanan Note dengan Firestore'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _namaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 100.0), // Add padding on the right and left
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan note baru',
                  ),
                ),
                const SizedBox(
                    height:
                        16), // Add some space between the TextField and ElevatedButton
                ElevatedButton(
                  onPressed: () {
                    if (_namaController.text.isEmpty) return;

                    db.collection('noteapp').add({
                      'nama': _namaController.text,
                    });
                  },
                  child: const Text('Tambah Data'),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('noteapp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.hasData
                        ? snapshot.data!.docs.map((e) {
                            return ListTile(
                              title: Text(
                                  (e.data() as Map<String, dynamic>)['nama']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      // Navigate to the EditPage
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPage(e.id),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Delete the document from Firestore
                                      db
                                          .collection('noteapp')
                                          .doc(e.id)
                                          .delete();
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList()
                        : [],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
