import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  final ValueNotifier<List<Product>> productsNotifier = ValueNotifier([]);
  static String? _imagesDir;

  DatabaseHelper._internal();

  Future<String> get imagesDir async {
    if (_imagesDir != null) return _imagesDir!;
    final appDir = await getApplicationDocumentsDirectory();
    _imagesDir = join(appDir.path, 'product_images');
    await Directory(_imagesDir!).create(recursive: true);
    return _imagesDir!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'products.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            price REAL NOT NULL,
            image TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    try {
      final db = await database;
      final id = await db.insert('products', product);
      await loadProducts();
      return id;
    } catch (e) {
      print("Insert Product Error: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final db = await database;
      return await db.query('products', orderBy: 'id DESC');
    } catch (e) {
      print("Get Products Error: $e");
      return [];
    }
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    try {
      final db = await database;
      final id = await db.update('products', product, where: 'id = ?', whereArgs: [product['id']]);
      await loadProducts();
      return id;
    } catch (e) {
      print("Update Product Error: $e");
      return -1;
    }
  }

  Future<int> deleteProduct(int id) async {
    try {
      final db = await database;
      final product = (await db.query('products', where: 'id = ?', whereArgs: [id])).firstOrNull;
      if (product != null && product['image'] != null) {
        final imagePath = product['image'] as String;
        final imageFile = File(imagePath);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }
      final result = await db.delete('products', where: 'id = ?', whereArgs: [id]);
      await loadProducts();
      return result;
    } catch (e) {
      print("Delete Product Error: $e");
      return -1;
    }
  }

  Future<void> loadProducts() async {
    final products = await getProducts();
    productsNotifier.value = products.map((product) => Product.fromMap(product)).toList();
  }
}