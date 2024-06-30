import 'package:diaryapp/common_widgets/smiley_selector.dart';
import 'package:diaryapp/models/entry.dart';
import 'package:diaryapp/services/database_service.dart';
import 'package:flutter/material.dart';

class EntryFormPage extends StatefulWidget {
  final String userUid;
  const EntryFormPage({required this.userUid, super.key, this.entry});
  final Entry? entry;

  @override
  // ignore: library_private_types_in_public_api
  _EntryFormPageState createState() => _EntryFormPageState();
}

class _EntryFormPageState extends State<EntryFormPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  var _smiley = '';
  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _textController.text = widget.entry!.text;
      _smiley = widget.entry!.icon;
    }
  }

  Future<void> _onSave() async {
    final text = _textController.text;
    final title = _titleController.text;

    widget.entry == null
        ? await _databaseService.insertEntry(
            Entry(
              date: DateTime.now(),
              userUid: widget.userUid,
              icon: _smiley,
              text: text,
              title: title,
            ),
          )
        : await _databaseService.updateEntry(
            widget.entry!.id!,
            Entry(
              id: widget.entry?.id,
              date: DateTime.now(),
              userUid: widget.userUid,
              icon: _smiley,
              text: text,
              title: title,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter name of the entry here',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _textController,
                minLines: 5,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter note of moment here',
                ),
              ),
              const SizedBox(height: 24.0),
              SmileySelector(
                onSmileySelected: (smiley) {
                  // Callback pour recevoir le smiley sélectionné

                  setState(() {
                    _smiley = smiley;
                  });
                  // Vous pouvez faire d'autres actions avec le smiley ici
                },
              ),
              SizedBox(
                height: 45.0,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: const Text(
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
      ),
    );
  }
}
