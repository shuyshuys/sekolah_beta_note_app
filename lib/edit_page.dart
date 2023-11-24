import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditPage extends StatefulWidget {
  final String id; // Add id parameter to the constructor

  const EditPage(this.id, {Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

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
      DocumentSnapshot snapshot = await db
          .collection('noteapp')
          .doc(widget.id)
          .get(); // Use widget.id to access the id parameter
      if (snapshot.exists) {
        setState(() {
          noteValue = (snapshot.data() as Map<String, dynamic>)['note'];
        });
      }
    } catch (e) {
      print('Error fetching note value: $e');
    }
  }

  Future<void> updateNoteValue(String newValue) async {
    try {
      await db.collection('noteapp').doc(widget.id).update({'note': newValue});
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
