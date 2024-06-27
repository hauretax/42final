import 'package:diaryapp/models/entry.dart';
import 'package:diaryapp/services/database_service.dart';
import 'package:flutter/material.dart';

class EntryFormPage extends StatefulWidget {
  const EntryFormPage({Key? key, this.entry}) : super(key: key);
  final Entry? entry;

  @override
  _EntryFormPageState createState() => _EntryFormPageState();
}

class _EntryFormPageState extends State<EntryFormPage> {
  final TextEditingController _nameController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _nameController.text = widget.entry!.title;
    }
  }

  Future<void> _onSave() async {
    final name = _nameController.text;

    // Add save code here
    widget.entry == null
        ? await _databaseService.insertEntry(
            Entry(
              date: DateTime.now(),
              usermail: 'tochqnge',
              icon: 'tochqnge',
              text: 'tochqnge',
              title: 'tochqnge',
            ),
          )
        : await _databaseService.updateEntry(
            Entry(
              id: widget.entry?.id,
              date: DateTime.now(),
              usermail: 'tochqnge',
              icon: 'tochqnge',
              text: 'tochqnge',
              title: 'tochqnge',
            ),
          );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Entry Record'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name of the entry here',
              ),
            ),
            SizedBox(height: 16.0),
            // Age Slider

            SizedBox(height: 24.0),
            // Breed Selector

            SizedBox(height: 24.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: Text(
                  'Save the Entry data',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
