import 'package:diaryfinalapp/models/entry.dart';
import 'package:diaryfinalapp/pages/calendar_landscape_page.dart';
import 'package:diaryfinalapp/pages/calendar_page.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseService _databaseService = DatabaseService();
  late final String _userTag;
  int _nbrOfEntries = 0;
  List<Entry> _entries = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _userTag = widget.user.email != null && widget.user.email != ''
        ? widget.user.email!
        : (widget.user.providerData[0].email != null &&
                widget.user.providerData[0].email != ''
            ? widget.user.providerData[0].email!
            : widget.user.displayName!);
    _updateAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Future<void> _navigateAndDisplaySelected(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryFormPage(
          isEditable: true,
          userUid: _userTag,
        ),
      ),
    );

    _updateAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: _signOut, child: const Text("logout")),
          ],
          title: Row(
            children: [Text('Welcom ${widget.user.displayName}')],
          ),
          centerTitle: true,
        ),
        body: TabBarView(controller: _tabController, children: [
          Column(
            children: [
              Expanded(
                child: LastEntry(
                  userTag: _userTag,
                  onDelete: _onEntryDelete,
                  updateAll: _updateAll,
                ),
              ),
              Expanded(
                child: feelingView(_entries),
              ),
            ],
          ),
          OrientationBuilder(builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;
            return Scaffold(
              body: isLandscape
                  ? CalendarLandscapePage(
                      entries: _entries,
                      updateAll: _updateAll,
                      userTag: _userTag,
                      onDelete: _onEntryDelete,
                    )
                  : CalendarPage(
                      entries: _entries,
                      updateAll: _updateAll,
                      userTag: _userTag,
                      onDelete: _onEntryDelete,
                    ),
            );
          })
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateAndDisplaySelected(context);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          tabs: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.note_alt_outlined),
              Text('$_nbrOfEntries'),
            ]),
            const Icon(Icons.date_range),
          ],
        ),
      ),
    );
  }
}
