import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditPage extends StatefulWidget {
  const EditPage(String id, {super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

// class _EditPageState extends State<EditPage> {
//   final db = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Page'),
//       ),
//       body: Center(
//         child: Text('Edit Page'),

//       ),
class _EditPageState extends State<EditPage> {
  final db = FirebaseFirestore.instance;
  String noteValue = '';

  @override
  void initState() {
    super.initState();
    fetchNoteValue();
  }

  Future<void> fetchNoteValue() async {
    try {
      DocumentSnapshot snapshot =
          await db.collection('noteapp').doc('your_document_id').get();
      if (snapshot.exists) {
        setState(() {
          noteValue = snapshot.data()?['note'] ?? [];
        });
      }
    } catch (e) {
      print('Error fetching note value: $e');
    }
  }

  Future<void> updateNoteValue(String newValue) async {
    try {
      await db
          .collection('noteapp')
          .doc('your_document_id')
          .update({'note': newValue});
      setState(() {
        noteValue = newValue;
      });
    } catch (e) {
      print('Error updating note value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Note Value: $noteValue'),
            ElevatedButton(
              onPressed: () {
                // Call the updateNoteValue method with the new value
                updateNoteValue('New Note Value');
              },
              child: Text('Update Note Value'),
            ),
          ],
        ),
      ),
    );
  }
}
//     );
//   }
// }
