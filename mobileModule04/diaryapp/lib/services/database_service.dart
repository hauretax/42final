import 'package:diaryapp/models/entry.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'flutter_sqflite_database.db');

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 3,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE entrys(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      usermail TEXT, 
      icon TEXT, 
      text TEXT, 
      title TEXT, 
      date TEXT)''',
    );
  }

  Future<void> insertEntry(Entry entry) async {
    final db = await _databaseService.database;
    await db.insert(
      'entrys',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Entry>> entrys() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('entrys');
    return List.generate(maps.length, (index) => Entry.fromMap(maps[index]));
  }

  Future<void> updateEntry(Entry entry) async {
    final db = await _databaseService.database;
    await db.update('entrys', entry.toMap(),
        where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> deleteEntry(int id) async {
    final db = await _databaseService.database;
    await db.delete('entrys', where: 'id = ?', whereArgs: [id]);
  }
}
