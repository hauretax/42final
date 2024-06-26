// mongodb.dart
import 'package:mongo_dart/mongo_dart.dart';
import 'package:diaryapp/constant.dart';

class MongoDatabase {
  static Db? _db;

  static Future<void> connect() async {
    _db = await Db.create(MONGO_URL);
    try {
      await _db!.open();
      print("Connected to MongoDB Atlas");

      var status = await _db!.serverStatus();
      print(status);

      var collection = _db!.collection(COLLECTION_NAME);
      var documents = await collection.find().toList();
      print(documents);
    } catch (e) {
      print('Connection error: $e');
    }
  }

  static Future<void> close() async {
    await _db?.close();
    print("Disconnected from MongoDB Atlas");
  }
}
