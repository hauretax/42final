import 'package:diaryapp/models/dog.dart';
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
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {

    await db.execute(
      'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT)',
    );
  }

  Future<void> insertDog(Dog dog) async {
    final db = await _databaseService.database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (index) => Dog.fromMap(maps[index]));
  }

  Future<void> updateDog(Dog dog) async {
    final db = await _databaseService.database;
    await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  Future<void> deleteDog(int id) async {
    final db = await _databaseService.database;
    await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }
}