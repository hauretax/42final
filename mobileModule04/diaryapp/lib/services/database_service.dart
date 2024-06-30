import 'package:diaryapp/models/entry.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> insertEntry(Entry entry) async {
    const uuid = Uuid();
    String id = uuid.v1();

    DatabaseReference notesRef = ref.child("notes");
    var data = entry.toMap(id);
    await notesRef.child(id).set(data);
  }

  Future<Entry?> getEntryById(String id) async {
    DatabaseReference notesRef = ref.child("notes").child(id);
    DatabaseEvent event = await notesRef.once();

    if (event.snapshot.exists) {
      Map<String, dynamic> entryData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      return Entry.fromMap(entryData);
    }
    return null;
  }

  Future<List<Entry>> getEntriesByUserUid(String userUid) async {
    DatabaseReference notesRef = ref.child("notes");
    Query query = notesRef.orderByChild("userUid").equalTo(userUid);
    DatabaseEvent event = await query.once();

    if (event.snapshot.exists) {
      Map<String, dynamic> notesData =
          Map<String, dynamic>.from(event.snapshot.value as Map);

      List<Entry> userEntries = notesData.values
          .map((entryData) =>
              Entry.fromMap(Map<String, dynamic>.from(entryData)))
          .toList();
      return userEntries;
    }
    return [];
  }

  Future<void> deleteEntry(String id) async {
    DatabaseReference notesRef = ref.child("notes").child(id);
    await notesRef.remove();
  }

  Future<void> updateEntry(String id, Entry entry) async {
    DatabaseReference notesRef = ref.child("notes").child(id);
    final data = entry.toMap(id);

    await notesRef.update(data);
  }
}
