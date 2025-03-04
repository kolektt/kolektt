import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupernino_bottom_sheet/flutter_cupernino_bottom_sheet.dart';
// Data sources
import 'package:kolektt/data/datasources/collection_remote_data_source.dart';
import 'package:kolektt/data/datasources/discogs_remote_data_source.dart';
import 'package:kolektt/data/datasources/google_vision_data_source.dart';
import 'package:kolektt/data/datasources/recent_search_local_data_source.dart';
import 'package:kolektt/data/repositories/album_recognition_repository_impl.dart';
// Repositories
import 'package:kolektt/data/repositories/collection_repository_impl.dart';
import 'package:kolektt/data/repositories/discogs_record_repository_impl.dart';
import 'package:kolektt/data/repositories/discogs_repository_impl.dart';
import 'package:kolektt/data/repositories/discogs_storage_repository_impl.dart';
import 'package:kolektt/data/repositories/recent_search_repository_impl.dart';
// Domain UseCases
import 'package:kolektt/domain/usecases/search_and_upsert_discogs_records.dart';
import 'package:kolektt/repository/sale_repository.dart';

// Views
import 'package:kolektt/view/content_view.dart';
import 'package:kolektt/view/login_view.dart';
import 'package:kolektt/view_models/analytics_vm.dart';
// ViewModels
import 'package:kolektt/view_models/auth_vm.dart';
import 'package:kolektt/view_models/collection_vm.dart';
import 'package:kolektt/view_models/home_vm.dart';
import 'package:kolektt/view_models/profile_vm.dart';
import 'package:kolektt/view_models/sale_vm.dart';
import 'package:kolektt/view_models/search_vm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/datasources/record_data_source.dart';

/// 기본 색상 (Primary Blue: #0036FF)
final Color primaryColor = const Color(0xFF0036FF);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 애플리케이션 문서 디렉터리 (예: Hive 초기화 시 사용)
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
    color: Color(0xFF6B7280),
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

/// 앱 전체 설정 (MultiProvider 및 CupertinoApp)
class KolekttApp extends StatelessWidget {
  const KolekttApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 홈 화면 관련 뷰모델
        ChangeNotifierProvider(create: (_) => HomeViewModel()),

        // 컬렉션 관련 뷰모델
        ChangeNotifierProvider(
          create: (_) => CollectionViewModel(
            searchAndUpsertUseCase: SearchAndUpsertDiscogsRecords(
              discogsRepository: DiscogsRepositoryImpl(
                remoteDataSource: DiscogsRemoteDataSource(),
                supabase: Supabase.instance.client,
              ),
              discogsStorageRepository: DiscogsStorageRepositoryImpl(
                supabase: Supabase.instance.client,
              ),
            ),
            discogs_repository: DiscogsRepositoryImpl(
              remoteDataSource: DiscogsRemoteDataSource(),
              supabase: Supabase.instance.client,
            ),
            collectionRepository: CollectionRepositoryImpl(
              remoteDataSource: CollectionRemoteDataSource(
                supabase: Supabase.instance.client,
              ),
            ),
            albumRecognitionRepository: AlbumRecognitionRepositoryImpl(
                dataSource: GoogleVisionDataSource(
                    apiKey: 'ya29.a0AeXRPp7EhJzihIXjaDG_3qY6XyIodza2VNoZfzRqGbhz9og4RJ7RK_fjpNQiu_uPGeWEOXiEcUqY8dj77X2uw8LYyZWg0mGKygG_iNDdRAHMvHBk5z1x4dZceCkXgnsmnRV_B5ryszspV_HE8wCKVphv124iJ2LfmSv-ZmDQq6UaFsgaCgYKAd4SARESFQHGX2Mio6NV5xvu8mS0SBaxBbg1HA0182'
                )
            ),
            discogsRecordRepository: DiscogsRecordRepositoryImpl(
                recordDataSource: RecordDataSource(
                    supabase: Supabase.instance.client
                )
            ),
          ),
        ),

        ChangeNotifierProvider(create: (_) => AnalyticsViewModel()),

        // 검색 관련 뷰모델
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            searchAndUpsertUseCase: SearchAndUpsertDiscogsRecords(
              discogsRepository: DiscogsRepositoryImpl(
                remoteDataSource: DiscogsRemoteDataSource(),
                supabase: Supabase.instance.client,
              ),
              discogsStorageRepository: DiscogsStorageRepositoryImpl(
                supabase: Supabase.instance.client,
              ),
            ),
            recentSearchRepository: RecentSearchRepositoryImpl(
              localDataSource: RecentSearchLocalDataSource.instance,
            ),
          ),
        ),

        // 인증 관련 뷰모델
        ChangeNotifierProvider(create: (_) => AuthViewModel()),

        // 프로필 관련 뷰모델
        ChangeNotifierProvider(
          create: (_) => ProfileViweModel(
            collectionRepository: CollectionRepositoryImpl(
              remoteDataSource: CollectionRemoteDataSource(
                supabase: Supabase.instance.client,
              ),
            ),
          ),
        ),

        // 판매 관련 뷰모델
        ChangeNotifierProvider(
          create: (_) => SaleViewModel(
            saleRepository: SaleRepository(),
          ),
        ),
      ],
      child: CupertinoBottomSheetRepaintBoundary(
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
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[DefaultMaterialLocalizations.delegate],
          home: const AuthenticationWrapper(),
        ),
      ),
    );
  }
}

/// 인증 상태에 따라 적절한 화면을 표시하는 래퍼 위젯
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    if (supabase.auth.currentUser != null) {
      return const ContentView();
    } else {
      return LoginView();
    }
  }
}
