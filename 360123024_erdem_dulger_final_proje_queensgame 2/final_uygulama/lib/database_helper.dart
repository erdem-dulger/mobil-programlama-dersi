import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static const String TABLE_USERS = 'users';
  static const String TABLE_SCORES = 'scores';

  // Kullanıcı tablosu
  static const String CREATE_USER_TABLE = '''
    CREATE TABLE $TABLE_USERS (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userName TEXT UNIQUE,
      score INTEGER
          );
  ''';

  // Puan tablosu
  static const String CREATE_SCORE_TABLE = '''
    CREATE TABLE $TABLE_SCORES (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userName TEXT,
      score INTEGER,
      templateId INTEGER,
      timestamp INTEGER
    );
  ''';
  Future<List<Map<String, dynamic>>> getAllScores() async {
    final db = await database;
    return await db.query('scores',
        orderBy: 'score DESC' // en yüksekten en düşüğe
        );
  }

  // Veritabanını başlatma
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  // Veritabanını oluşturma
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'game.db');
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(CREATE_USER_TABLE);
      await db.execute(CREATE_SCORE_TABLE);
    });
  }

  // Kullanıcıyı ekle veya güncelle (varsa günceller)
  Future<void> insertUser(String userName) async {
    final db = await database;
    await db.insert(
      TABLE_USERS,
      {
        'userName': userName,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Kullanıcının skorunu ekle
  Future<void> insertScore(String userName, int score, int templateId) async {
    final db = await database;
    await db.insert(TABLE_SCORES, {
      'userName': userName,
      'score': score,
      'templateId': templateId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Belirli bir kullanıcının skorlarını getir
  Future<List<Map<String, dynamic>>> getUserScores(String userName) async {
    final db = await database;
    return await db.query(
      TABLE_SCORES,
      where: 'userName = ?',
      whereArgs: [userName],
      orderBy: 'timestamp DESC',
    );
  }

  // Tüm kullanıcıların toplam skorlarını getir
  Future<List<Map<String, dynamic>>> getTopScores() async {
    final db = await database;
    return await db.query(
      'users',
      columns: ['userName', 'score AS totalScore'],
      orderBy: 'score DESC',
      limit: 10,
    );
  }
}
