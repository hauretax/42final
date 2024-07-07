import 'package:diaryfinalapp/common_widgets/entry_builder.dart';
import 'package:diaryfinalapp/models/entry.dart';
import 'package:diaryfinalapp/pages/entry_form_page.dart';
import 'package:diaryfinalapp/services/database_service.dart';
import 'package:flutter/material.dart';

class LastEntry extends StatefulWidget {
  final String userTag;
  final Function() updateAll;
  final Function(Entry) onDelete;
  const LastEntry(
      {required this.userTag,
      required this.onDelete,
      required this.updateAll,
      Key? key})
      : super(key: key);

  @override
  _LastEntryState createState() => _LastEntryState();
}

class _LastEntryState extends State<LastEntry> {
  final DatabaseService _databaseService = DatabaseService();
  late final String _userTag = widget.userTag;

  Future<List<Entry>> _getLastEntrys() async {
    List<Entry> fullEntries =
        await _databaseService.getEntriesByUserTag(_userTag);
    return fullEntries;
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        EntryBuilder(
          future: _getLastEntrys(),
          onEdit: (value) {
            {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => EntryFormPage(
                        isEditable: true,
                        userUid: _userTag,
                        entry: value,
                        onDelete: widget.onDelete,
                      ),
                      fullscreenDialog: true,
                    ),
                  )
                  .then((_) => {setState(() {}), widget.updateAll()});
            }
          },
        ),
      ],
    );
  }
}
