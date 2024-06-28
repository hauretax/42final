import 'package:diaryapp/models/entry.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> test() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/12");

    await ref.set({
      "id": "t",
      "dataa": {"name": "test", "mill": "deux"}
    });
  }
}
