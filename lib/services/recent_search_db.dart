import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecentSearchDB {
  static final RecentSearchDB instance = RecentSearchDB._init();
  static Database? _database;

  RecentSearchDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recent_searches.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE recent_searches(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      term TEXT NOT NULL,
      timestamp INTEGER NOT NULL
    )
    ''');
  }

  Future<List<String>> getRecentSearchTerms() async {
    final db = await instance.database;
    final result = await db.query(
      'recent_searches',
      orderBy: 'timestamp DESC',
      limit: 10,
    );

    return result.map((row) => row['term'] as String).toList();
  }

  Future<void> insertSearchTerm(String term) async {
    final db = await instance.database;

    // 중복 검색어가 있으면 삭제
    await db.delete(
      'recent_searches',
      where: 'term = ?',
      whereArgs: [term],
    );

    // 새 검색어 추가
    await db.insert(
      'recent_searches',
      {
        'term': term,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );

    // 최대 10개만 유지
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM recent_searches'),
    );

    if (count != null && count > 10) {
      final oldest = await db.query(
        'recent_searches',
        orderBy: 'timestamp ASC',
        limit: count - 10,
      );

      for (final item in oldest) {
        await db.delete(
          'recent_searches',
          where: 'id = ?',
          whereArgs: [item['id']],
        );
      }
    }
  }

  Future<void> removeSearchTerm(String term) async {
    final db = await instance.database;
    await db.delete(
      'recent_searches',
      where: 'term = ?',
      whereArgs: [term],
    );
  }

  Future<void> clearRecentSearches() async {
    final db = await instance.database;
    await db.delete('recent_searches');
  }
}
