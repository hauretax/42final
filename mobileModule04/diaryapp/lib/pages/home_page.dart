import 'package:diaryapp/common_widgets/entry_builder.dart';
import 'package:diaryapp/models/entry.dart';
import 'package:diaryapp/pages/entry_form_page.dart';
import 'package:diaryapp/services/database_service.dart';
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

  @override
  void initState() {
    super.initState();
    _userTag = widget.user.email != null && widget.user.email != ''
        ? widget.user.email!
        : (widget.user.providerData[0].email != null &&
                widget.user.providerData[0].email != ''
            ? widget.user.providerData[0].email!
            : widget.user.displayName!);
  }

  Future<List<Entry>> _getEntrys() async {
    List<Entry> entries = await _databaseService.getEntriesByUserTag(_userTag);
    return entries;
  }

  Future<void> _onEntryDelete(Entry entry) async {
    await _databaseService.deleteEntry(entry.id!);
    setState(() {});
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
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Entrys'),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EntryBuilder(
              future: _getEntrys(),
              onEdit: (value) {
                {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EntryFormPage(userUid: _userTag, entry: value),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                }
              },
              onDelete: _onEntryDelete,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (_) => EntryFormPage(userUid: _userTag),
                    fullscreenDialog: true,
                  ),
                )
                .then((_) => setState(() {}));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
