
import 'package:diaryapp/pages/entry_form_page.dart';
import 'package:diaryapp/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  // Future<List<Entry>> _getEntrys() async {
  //   return await _databaseService.entrys();
  // }

  // Future<void> _onEntryDelete(Entry entry) async {
  //   await _databaseService.deleteEntry(entry.id!);
  //   setState(() {});
  // }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var data = DatabaseService();
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entry Database'),
          centerTitle: true,
          bottom: TabBar(
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
            TextButton(onPressed: _signOut, child: Text("logout")),
            // EntryBuilder(
            //   future: _getEntrys(),
            //   onEdit: (value) {
            //     {
            //       Navigator.of(context)
            //           .push(
            //             MaterialPageRoute(
            //               builder: (_) => EntryFormPage(entry: value),
            //               fullscreenDialog: true,
            //             ),
            //           )
            //           .then((_) => setState(() {}));
            //     }
            //   },
            //   onDelete: _onEntryDelete,
            // ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => EntryFormPage(),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              heroTag: 'addBreed',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
