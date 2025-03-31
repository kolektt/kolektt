import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/search_term_model.dart';

/// 로컬에 최근 검색어를 저장 및 관리하는 데이터 소스 클래스 (싱글톤)
class RecentSearchLocalDataSource {
  RecentSearchLocalDataSource._init();
  static final RecentSearchLocalDataSource instance = RecentSearchLocalDataSource._init();

  static Database? _database;

  /// 데이터베이스 인스턴스를 반환합니다. 없으면 초기화합니다.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('recent_searches.db');
    return _database!;
  }

  /// 데이터베이스 파일 경로를 구성하고 데이터베이스를 초기화합니다.
  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  /// 데이터베이스 생성 시 호출되며, 필요한 테이블을 생성합니다.
  Future<void> _createDatabase(Database db, int version) async {
    const createTableQuery = '''
      CREATE TABLE recent_searches(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        term TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''';
    await db.execute(createTableQuery);
  }

  /// 가장 최근의 검색어 10개를 내림차순으로 조회합니다.
  Future<List<SearchTermModel>> getRecentSearchTerms() async {
    final db = await database;
    final result = await db.query(
      'recent_searches',
      orderBy: 'timestamp DESC',
      limit: 10,
    );
    return result.map((row) => SearchTermModel.fromMap(row)).toList();
  }

  /// 검색어를 추가합니다.
  /// 중복 검색어가 있으면 삭제 후 새 검색어를 추가하고, 최대 [maxEntries]개만 유지합니다.
  Future<void> insertSearchTerm(String term) async {
    final db = await database;

    // 중복 검색어 제거
    await db.delete(
      'recent_searches',
      where: 'term = ?',
      whereArgs: [term],
    );

    // 새 검색어 삽입
    await db.insert(
      'recent_searches',
      {
        'term': term,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );

    // 최대 검색어 개수 유지
    await _enforceMaxEntries(maxEntries: 10);
  }

  /// 지정된 검색어와 일치하는 항목을 삭제합니다.
  Future<void> removeSearchTerm(String term) async {
    final db = await database;
    await db.delete(
      'recent_searches',
      where: 'term = ?',
      whereArgs: [term],
    );
  }

  /// 모든 최근 검색어를 삭제합니다.
  Future<void> clearRecentSearches() async {
    final db = await database;
    await db.delete('recent_searches');
  }

  /// [maxEntries] 개수보다 검색어가 많을 경우, 가장 오래된 항목부터 삭제하여 개수를 제한합니다.
  Future<void> _enforceMaxEntries({required int maxEntries}) async {
    final db = await database;
    final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM recent_searches');
    final count = Sqflite.firstIntValue(countResult) ?? 0;

    if (count > maxEntries) {
      // 삭제할 레코드 수 계산
      final recordsToRemove = count - maxEntries;
      final oldestRecords = await db.query(
        'recent_searches',
        orderBy: 'timestamp ASC',
        limit: recordsToRemove,
      );

      for (final record in oldestRecords) {
        await db.delete(
          'recent_searches',
          where: 'id = ?',
          whereArgs: [record['id']],
        );
      }
    }
  }
}
