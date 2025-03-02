import 'package:flutter/cupertino.dart';
import 'package:kolektt/repository/sale_repository.dart';
import 'package:kolektt/view/content_view.dart';
import 'package:kolektt/view_models/auth_vm.dart';
import 'package:kolektt/view_models/collection_vm.dart';
import 'package:kolektt/view_models/home_vm.dart';
import 'package:kolektt/view_models/profile_vm.dart';
import 'package:kolektt/view_models/sale_vm.dart';
import 'package:kolektt/view_models/search_vm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/datasources/recent_search_local_data_source.dart';
import 'data/repositories/recent_search_repository_impl.dart';

// 기본 색상 (Primary Blue: #0036FF)
final Color primaryColor = const Color(0xFF0036FF);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  // Hive 초기화 및 모델 등록 (필요 시 주석 해제)
  // Hive.init(appDocumentDir.path);
  // Hive.registerAdapter(RecordAdapter());
  // await Hive.openBox<Record>('records');

  await Supabase.initialize(
    url: 'https://awdnjducwqwfmbfigugq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3ZG5qZHVjd3F3Zm1iZmlndWdxIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MDQ4OTk5MywiZXhwIjoyMDU2MDY1OTkzfQ.S6u5gaLR5JeL76aJa0jRXzvTGeIYsXU4qPJ63QEEY1I',
  );

  runApp(const KolekttApp());
}

/// 텍스트 스타일 및 타이포그래피 (SF Pro Text 기반)
class AppTextStyles {
  static TextStyle display = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF Pro Text',
    color: primaryColor,
  );
  static TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF Pro Text',
    color: primaryColor,
  );
  static TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF Pro Text',
    color: primaryColor,
  );
  static TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'SF Pro Text',
    color: primaryColor,
  );
  static const TextStyle bodyL = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    fontFamily: 'SF Pro Text',
    color: Color(0xFF6B7280), // Secondary Gray
  );
  static const TextStyle bodyM = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    fontFamily: 'SF Pro Text',
    color: Color(0xFF6B7280),
  );
  static const TextStyle bodyS = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    fontFamily: 'SF Pro Text',
    color: Color(0xFF6B7280),
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: 'SF Pro Text',
    color: Color(0xFF6B7280),
  );
}

/// 앱 전체 설정 (MultiProvider, CupertinoApp)
class KolekttApp extends StatelessWidget {
  const KolekttApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CollectionViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel(
            recentSearchRepository: RecentSearchRepositoryImpl(localDataSource: RecentSearchLocalDataSource.instance)
        )),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViweModel()),
        ChangeNotifierProvider(
          create: (_) => SaleViewModel(saleRepository: SaleRepository()),
        ),
      ],
      child: CupertinoApp(
        title: 'Kolektt',
        theme: CupertinoThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: CupertinoColors.systemBackground,
          barBackgroundColor: CupertinoColors.systemGrey6,
          textTheme: CupertinoTextThemeData(
            textStyle: AppTextStyles.bodyL,
          ),
        ),
        home: const ContentView(),
      ),
    );
  }
}
