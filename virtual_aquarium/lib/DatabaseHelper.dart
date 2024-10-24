import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:virtual_aquarium/fish.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'aquarium.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE fish(id INTEGER PRIMARY KEY AUTOINCREMENT, speed REAL, color INTEGER, xPos REAL, yPos REAL)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertFish(Fish fish) async {
    final db = await database;
    await db.insert(
      'fish',
      {
        'speed': fish.speed,
        'color': fish.color.value,
        'xPos': fish.xPos,
        'yPos': fish.yPos,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Fish>> getFishList() async {
    final db = await database;
    final List<Map<String, dynamic>> fishMaps = await db.query('fish');
    return List.generate(fishMaps.length, (i) {
      return Fish(
        speed: fishMaps[i]['speed'],
        color: Color(fishMaps[i]['color']),
        xPos: fishMaps[i]['xPos'],
        yPos: fishMaps[i]['yPos'],
        id: fishMaps[i]['id'],
      );
    });
  }

  Future<void> deleteFish(int id) async {
    final db = await database;
    await db.delete('fish', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllFish() async {
    final db = await database;
    await db.delete('fish');
  }
}
