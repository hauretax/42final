import 'package:diaryapp/models/entry.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _entrysRef =
      FirebaseDatabase.instance.ref().child('entrys');

  Future<void> insertEntry(Entry entry) async {
    await _entrysRef.push().set(entry.toMap());
  }

  Future<List<Entry>> entrys() async {
    final DataSnapshot snapshot = (await _entrysRef.once()).snapshot;
    List<Entry> entries = [];
    if (snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        entries.add(Entry.fromMap(value));
      });
    }
    return entries;
  }

  Future<void> updateEntry(Entry entry) async {
    await _entrysRef.child(entry.id.toString()).set(entry.toMap());
  }

  Future<void> deleteEntry(int id) async {
    await _entrysRef.child(id.toString()).remove();
  }
}
