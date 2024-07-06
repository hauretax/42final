import 'package:diaryfinalapp/models/entry.dart';
import 'package:diaryfinalapp/pages/entry_form_page.dart';
import 'package:diaryfinalapp/services/database_service.dart';
import 'package:diaryfinalapp/widget/feeling_view.dart';
import 'package:diaryfinalapp/widget/last_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  late final String _userTag;
  int _nbrOfEntries = 0;
  List<Entry> _entries = [];

  @override
  void initState() {
    super.initState();
    _userTag = widget.user.email != null && widget.user.email != ''
        ? widget.user.email!
        : (widget.user.providerData[0].email != null &&
                widget.user.providerData[0].email != ''
            ? widget.user.providerData[0].email!
            : widget.user.displayName!);
    _updateAll();
  }

  Future<List<Entry>> _getEntrys() async {
    List<Entry> entries = await _databaseService.getEntriesByUserTag(_userTag);
    return entries;
  }

  void _updateAll() async {
    var entries = await _getEntrys();
    setState(() {
      _entries = entries;
      _nbrOfEntries = entries.length;
    });
  }

  Future<void> _onEntryDelete(Entry entry) async {
    await _databaseService.deleteEntry(entry.id!);
    _updateAll();
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: _signOut, child: Text("logout")),
          ],
          title: Row(
            children: [Text('Welcom ${widget.user.displayName}')],
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Entrys (${_nbrOfEntries.toString()})'),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: LastEntry(
                userTag: _userTag,
                onDelete: _onEntryDelete,
              ),
            ),
            Expanded(
              child: feelingView(_entries),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            List<Entry> entries;
            final updatedEntries = await Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (_) => EntryFormPage(
                      userUid: _userTag,
                    ),
                    fullscreenDialog: true,
                  ),
                )
                .then((_) => _updateAll());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
