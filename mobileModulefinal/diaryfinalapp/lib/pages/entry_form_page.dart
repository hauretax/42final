import 'package:diaryfinalapp/common_widgets/smiley_selector.dart';
import 'package:diaryfinalapp/models/entry.dart';
import 'package:diaryfinalapp/services/database_service.dart';
import 'package:flutter/material.dart';

class EntryFormPage extends StatefulWidget {
  const EntryFormPage(
      {required this.userUid,
      required this.isEditable,
      this.onDelete,
      super.key,
      this.entry});
  final Entry? entry;
  final String userUid;
  final bool isEditable;
  final Function(Entry)? onDelete;

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
    if (widget.isEditable) {
      Navigator.of(context).pop("data");
      return;
    }

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

    Navigator.of(context).pop("data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.entry?.title != null
            ? Text(widget.entry!.title)
            : Text('New Entry Record'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.isEditable
                  ? TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter name of the entry here',
                      ),
                    )
                  : Text(widget.entry!.title),
              const SizedBox(height: 16.0),
              widget.isEditable
                  ? TextField(
                      controller: _textController,
                      minLines: 5,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter note of moment here',
                      ),
                    )
                  : Text(widget.entry!.text),
              const SizedBox(height: 24.0),
              widget.isEditable
                  ? SmileySelector(
                      smiley: _smiley,
                      onSmileySelected: (smiley) {
                        setState(() {
                          _smiley = smiley;
                        });
                      },
                    )
                  : Text(widget.entry!.icon),
              SizedBox(
                height: 45.0,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: widget.isEditable
                      ? const Text(
                          'Save the Entry data',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      : const Text(
                          'close',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24.0),
              if (widget.onDelete != null && widget.onDelete != null)
                GestureDetector(
                  onTap: () => {
                    widget.onDelete!(widget.entry!),
                    Navigator.of(context).pop()
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.delete, color: Colors.red[800]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
