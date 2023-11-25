import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String id; // Add id parameter to the constructor

  const EditPage(this.id, {Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _updateController = TextEditingController();
  final db = FirebaseFirestore.instance;
  String noteValue = '';

  @override
  void initState() {
    super.initState();
    fetchNoteValue();
  }

  Future<void> fetchNoteValue() async {
    try {
      DocumentSnapshot snapshot = await db
          .collection('noteapp')
          .doc(widget.id)
          .get(); // Use widget.id to access the id parameter
      final data = snapshot.data() as Map<String, dynamic>;
      final note = data['nama'];
      if (note != null) {
        setState(() {
          noteValue = note;
        });
      }
    } catch (e) {
      // print('Error fetching note value: $e');
    }
  }

  Future<void> updateNoteValue(String newValue) async {
    try {
      await db.collection('noteapp').doc(widget.id).update({'nama': newValue});
      setState(() {
        noteValue = newValue;
      });
    } catch (e) {
      // print('Error updating note value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Ubah Note'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Note berisi: \'$noteValue\'',
              style: const TextStyle(fontSize: 20), // Increase the font size to 20
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 100), // Add padding on the right and left
              child: TextField(
                controller: _updateController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan perubahan nama disini',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_updateController.text.isEmpty) return;

                updateNoteValue(_updateController.text);
              },
              // onPressed: () {
              //   // Call the updateNoteValue method with the new value
              //   updateNoteValue('New Note Value');
              // },
              child: const Text('Update isi Note'),
            ),
          ],
        ),
      ),
    );
  }
}
