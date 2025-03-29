// 외부 패키지
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kolektt/data/repositories/lens_repository_impl.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cupernino_bottom_sheet/flutter_cupernino_bottom_sheet.dart';

// 내부 모듈 (DataSources, Repositories, UseCases, Views, ViewModels)
import 'package:kolektt/data/datasources/collection_remote_data_source.dart';
import 'package:kolektt/data/datasources/discogs_remote_data_source.dart';
import 'package:kolektt/data/datasources/google_vision_data_source.dart';
import 'package:kolektt/data/datasources/recent_search_local_data_source.dart';
import 'package:kolektt/data/datasources/record_data_source.dart';

import 'package:kolektt/data/repositories/album_recognition_repository_impl.dart';
import 'package:kolektt/data/repositories/collection_repository_impl.dart';
import 'package:kolektt/data/repositories/discogs_record_repository_impl.dart';
import 'package:kolektt/data/repositories/discogs_repository_impl.dart';
import 'package:kolektt/data/repositories/discogs_storage_repository_impl.dart';
import 'package:kolektt/data/repositories/recent_search_repository_impl.dart';

import 'package:kolektt/domain/usecases/search_and_upsert_discogs_records.dart';
import 'package:kolektt/domain/usecases/search_artist.dart';
import 'package:kolektt/domain/usecases/search_by_id_data.dart';

import 'package:kolektt/repository/sale_repository.dart';

import 'package:kolektt/view/content_view.dart';
import 'package:kolektt/view/login_view.dart';

import 'package:kolektt/view_models/analytics_vm.dart';
import 'package:kolektt/view_models/artist_detail_vm.dart';
import 'package:kolektt/view_models/auth_vm.dart';
import 'package:kolektt/view_models/collection_vm.dart';
import 'package:kolektt/view_models/home_vm.dart';
import 'package:kolektt/view_models/profile_vm.dart';
import 'package:kolektt/view_models/record_details_vm.dart';
import 'package:kolektt/view_models/sale_vm.dart';
import 'package:kolektt/view_models/search_vm.dart';

import 'data/repositories/gemini_repository_impl.dart';
import 'data/repositories/supabase_storage_repository_impl.dart';
import 'domain/usecases/recognize_album.dart';

/// 기본 색상 (Primary Blue: #0036FF)
const Color primaryColor = Color(0xFF0036FF);

/// 애플리케이션 초기화 함수
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경변수 로드 (프로덕션/개발 환경에 따라 분기 가능)
  await dotenv.load();

  // Supabase 및 Firebase 초기화
  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"] ?? '',
    anonKey: dotenv.env["SUPABASE_API_KEY"] ?? '',
  );
  await Firebase.initializeApp();

  // TODO: Hive 초기화 등 추가 초기화 작업이 필요하다면 이곳에 추가
}

Future<void> main() async {
  await initializeApp();
  runApp(const KolekttApp());
}

/// Provider 등록을 관리하는 클래스
class AppProviders {
  final SupabaseClient supabase;
  final DiscogsRemoteDataSource discogsRemote = DiscogsRemoteDataSource();
  final CollectionRemoteDataSource collectionRemote;

  AppProviders({required this.supabase})
      : collectionRemote = CollectionRemoteDataSource(supabase: supabase);

  List<SingleChildWidget> get providers {
    // DiscogsRepository 인스턴스는 여러 곳에서 재사용합니다.
    final discogsRepository = DiscogsRepositoryImpl(
      remoteDataSource: discogsRemote,
      supabase: supabase,
    );

    return [
      // 홈 화면 관련 뷰모델
      ChangeNotifierProvider(create: (_) => HomeViewModel()),

      // 컬렉션 관련 뷰모델
      ChangeNotifierProvider(
        create: (_) => CollectionViewModel(
          recognizeAlbumUseCase: RecognizeAlbumUseCase(
            storageRepository: SupabaseStorageRepository(),
            lensRepository: LensApiRepository(),
            geminiRepository: GeminiApiRepository(),
          ),
          searchAndUpsertUseCase: SearchAndUpsertDiscogsRecords(
            discogsRepository: discogsRepository,
            discogsStorageRepository:
                DiscogsStorageRepositoryImpl(supabase: supabase),
          ),
          discogs_repository: discogsRepository,
          collectionRepository:
              CollectionRepositoryImpl(remoteDataSource: collectionRemote),
          albumRecognitionRepository: AlbumRecognitionRepositoryImpl(
            dataSource: GoogleVisionDataSource(
              apiKey: dotenv.env["GOOGLE_CLOUD_API_KEY"] ?? '',
              project: dotenv.env["GOOGLE_CLOUD_PROJECT_ID"] ?? '',
            ),
          ),
          discogsRecordRepository: DiscogsRecordRepositoryImpl(
            recordDataSource: RecordDataSource(supabase: supabase),
          ),
        ),
      ),

      // 애널리틱스 뷰모델
      ChangeNotifierProvider(create: (_) => AnalyticsViewModel()),

      // 레코드 상세 정보 관련 뷰모델
      ChangeNotifierProvider(
        create: (_) => RecordDetailsViewModel(
          CollectionRepositoryImpl(remoteDataSource: collectionRemote),
          SearchArtist(discogsRepository),
          SearchByIdData(discogsRepository),
        ),
      ),

      // 아티스트 상세 뷰모델
      ChangeNotifierProvider(
        create: (_) => ArtistDetailViewModel(remoteDataSource: discogsRemote),
      ),

      // 검색 관련 뷰모델
      ChangeNotifierProvider(
        create: (_) => SearchViewModel(
          searchAndUpsertUseCase: SearchAndUpsertDiscogsRecords(
            discogsRepository: discogsRepository,
            discogsStorageRepository:
                DiscogsStorageRepositoryImpl(supabase: supabase),
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
        create: (_) => ProfileViewModel(
          collectionRepository:
              CollectionRepositoryImpl(remoteDataSource: collectionRemote),
        ),
      ),

      // 판매 관련 뷰모델
      ChangeNotifierProvider(
        create: (_) => SaleViewModel(
          saleRepository: SaleRepository(),
        ),
      ),
    ];
  }
}

/// 앱의 루트 위젯
class KolekttApp extends StatelessWidget {
  const KolekttApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;

    return MultiProvider(
      providers: AppProviders(supabase: supabaseClient).providers,
      child: CupertinoBottomSheetRepaintBoundary(
        child: CupertinoApp(
          title: 'Kolektt',
          theme: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: CupertinoColors.systemBackground,
            barBackgroundColor: CupertinoColors.systemGrey6,
            textTheme: const CupertinoTextThemeData(
              textStyle: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 17.0,
                color: CupertinoColors.label,
              ),
            ),
          ),
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
          ],
          home: const AuthenticationWrapper(),
        ),
      ),
    );
  }
}

/// 인증 상태에 따라 적절한 화면을 표시하는 위젯
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final isLoggedIn = supabase.auth.currentUser != null;

    return isLoggedIn ? const ContentView() : LoginView();
  }
}
