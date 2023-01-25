import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initialiseDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database> _initialiseDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "kayitlar.db");

    var exists = await databaseExists(path);

    if (!exists) {
      debugPrint("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "kayitlar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      debugPrint("Opening existing database");
    }
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> kullanicilariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query('kullanicilar');
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> etkinlikleriGetir(String tcno) async {
    var db = await _getDatabase();
    var sonuc = await db.query('etkinlikler');
    List<Map<String, dynamic>> tcyeGoreAyrilanlar = [];
    for (var element in sonuc) {
      if (element['tcno'] == tcno) {
        tcyeGoreAyrilanlar.add(element);
      }
    }
    return tcyeGoreAyrilanlar;
  }

  Future<int> kullaniciEkle(Map<String, dynamic> value) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('kullanicilar', value);
    return sonuc;
  }

  Future<int> kullaniciDuzenle(Map<String, dynamic> value) async {
    var db = await _getDatabase();
    var sonuc = await db.update('kullanicilar', value,
        where: 'tcno = ?', whereArgs: [value['tcno']]);
    return sonuc;
  }

  Future<int> etkinlikEkle(Map<String, dynamic> value) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('etkinlikler', value);
    return sonuc;
  }

  Future<int> etkinlikSil(Map<String, dynamic> value) async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete('etkinlikler', where: 'id = ?', whereArgs: [value['id']]);
    return sonuc;
  }
}
