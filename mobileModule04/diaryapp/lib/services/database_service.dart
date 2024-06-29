import 'package:diaryapp/models/entry.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> insertEntry(Entry entry) async {
    const uuid = Uuid();
    String id = uuid.v1();

    DatabaseReference notesRef = ref.child("notes");
    final data = entry.toMap();

    await notesRef.child(id).set(data);
  }

  Future<Entry?> getEntry(String id) async {
    DatabaseReference notesRef = ref.child("notes").child(id);
    DatabaseEvent event = await notesRef.once();

    if (event.snapshot.exists) {
      Map<String, dynamic> entryData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      return Entry.fromMap(entryData);
    }
    return null;
  }

  Future<void> deleteEntry(String id) async {
    DatabaseReference notesRef = ref.child("notes").child(id);
    await notesRef.remove();
  }

  Future<void> updateEntry(String id, Entry entry) async {
    DatabaseReference notesRef = ref.child("notes").child(id);
    final data = entry.toMap();

    await notesRef.update(data);
  }
}
