// auth_view_model.dart

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/supabase/profile.dart';
import '../model/supabase/user_stats.dart';
import '../repository/profile_repository.dart';

class AuthViewModel with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ProfileRepository profileRepository = ProfileRepository();

  Profiles? _profiles = null;
  Profiles? get profiles => _profiles;

  UserStats? _userStats = null;
  get userStats => _userStats;

  bool _isLoading = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  /// 현재 로그인된 User
  get currentUser => profileRepository.getCurrentUser();

  // Modified to avoid notifyListeners during build
  Future<void> fetchCurrentUser() async {
    // Set loading state without notifying listeners immediately
    _isLoading = true;
    _errorMessage = null;
    
    try {
      // Fetch data without notifying during each operation
      final profileFuture = fetchProfileSilently();
      final statsFuture = fetchUserStatsSilently();
      
      await Future.wait([profileFuture, statsFuture]);
      
      // Notify listeners only once at the end
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error fetching user data: $e';
      notifyListeners();
    }
  }

  // Silent version that doesn't call notifyListeners
  Future<void> fetchProfileSilently() async {
    try {
      _profiles = await profileRepository.getCurrentProfile();
      if (_profiles == null) {
        throw Exception('프로필 조회 실패: 사용자 정보를 찾을 수 없습니다.');
      }
    } catch (e) {
      _errorMessage = '프로필 조회 오류: $e';
      debugPrint('프로필 조회 오류: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // Silent version that doesn't call notifyListeners
  Future<void> fetchUserStatsSilently() async {
    try {
      _userStats = await profileRepository.getCurrentUserStats();
    } catch (e) {
      _errorMessage = '사용자 통계 조회 오류: $e';
      rethrow;
    }
  }

  /// 이메일/비밀번호 로그인
  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // signInWithPassword가 실패 시 error 발생
      if (response.session == null || response.user == null) {
        throw Exception('로그인 실패: 사용자 정보를 찾을 수 없습니다.');
      }
      // 로그인 성공
    } catch (e) {
      _errorMessage = '로그인 오류: $e';
    } finally {
      _setLoading(false);
    }
  }

  // 구글 로그인
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      /// Web Client ID that you registered with Google Cloud.
      final webClientId = dotenv.env['GOOGLE_SIGNIN_SERVICE_CLIENT_ID'] ?? '';

      /// iOS Client ID that you registered with Google Cloud.
      final iosClientId = dotenv.env['GOOGLE_SIGNIN_IOS_CLIENT_ID'] ?? '';
      final androidClientId = dotenv.env['GOOGLE_SIGNIN_ANDROID_DEBUG_CLIENT_ID'] ?? '';

      final clientId = kIsWeb ? webClientId : Platform.isAndroid ? androidClientId : iosClientId;
      debugPrint('clientId: $clientId');

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: clientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      debugPrint('accessToken: $accessToken, idToken: $idToken');

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      var res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      debugPrint('res: $res');
    } catch (e) {
      _errorMessage = '로그인 오류: ${e.toString()}';
      debugPrint('로그인 오류: ${e}');
    } finally {
      _setLoading(false);
    }
  }

  // Apple 로그인
  Future<void> signInWithApple() async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      final rawNonce = supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
        // Android에서는 webAuthenticationOptions가 필수입니다.
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.kolektt.android', // Apple Developer에서 생성한 서비스 ID 입력
          redirectUri: Uri.parse('https://awdnjducwqwfmbfigugq.supabase.co/auth/v1/callback'),
        ),
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException('Could not find ID Token from generated credential.');
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      // await supabase.auth.signInWithOAuth(
      //   OAuthProvider.apple,
      //   redirectTo: kIsWeb ? null : 'https://awdnjducwqwfmbfigugq.supabase.co/auth/v1/callback', // Optionally set the redirect link to bring back the user via deeplink.
      //   authScreenLaunchMode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
      // );
    } catch (error) {
      _errorMessage = 'Sign in failed: $error';
      debugPrint('Sign in failed: $error');
    } finally {
      _setLoading(false);
    }
  }

  /// 회원가입
  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('회원가입 실패: 사용자 정보를 찾을 수 없습니다.');
      }
      // 회원가입 성공 (이메일 확인 메일 전송 등)
    } catch (e) {
      _errorMessage = '회원가입 오류: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      await supabase.auth.signOut();
    } catch (e) {
      _errorMessage = '로그아웃 오류: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 비밀번호 변경
  Future<void> changePassword(String newPassword) async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      // Supabase Flutter 버전에 따라 아래 구문이 달라질 수 있습니다.
      final response = await supabase.auth.updateUser(
        // 예시: 최신 버전에서는 UserAttributes 사용
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      _errorMessage = "비밀번호 변경 오류: $e";
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = supabase.auth.currentUser!.id;
      // 프로필 데이터 삭제
      final response = await supabase
          .from('profiles')
          .delete()
          .eq('user_id', userId);

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      // 주의: 클라이언트에서 auth user를 삭제하는 것은 보안상 불가합니다.
      // 실제 계정 삭제는 서버 사이드에서 별도의 로직을 구현하거나,
      // 사용자를 휴면 상태로 만드는 등의 방식으로 처리해야 합니다.
      // 여기서는 간단하게 로그아웃 처리합니다.
      await supabase.auth.signOut();
    } catch (e) {
      _errorMessage = '계정 삭제 오류: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 프로필 조회
  Future<void> fetchProfile() async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      // user_id로 프로필 조회
      _profiles = await profileRepository.getCurrentProfile();

      if (_profiles == null) {
        throw Exception('프로필 조회 실패: 사용자 정보를 찾을 수 없습니다.');
      }
      notifyListeners();

      // 프로필 조회 성공
    } catch (e) {
      _errorMessage = '프로필 조회 오류: $e';
      debugPrint('프로필 조회 오류: $e');
    } finally {
      debugPrint('프로필 조회 완료');
      _setLoading(false);
    }
  }

  /// 프로필 업데이트 메서드 추가
  Future<void> updateProfile({String? displayName, String? genre}) async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = profileRepository.getCurrentUserId();
      final updates = {
        'display_name': displayName,
        'genre': genre,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await supabase
          .from('profiles')
          .update(updates)
          .eq('user_id', userId);

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      // 업데이트 후 최신 프로필 정보 다시 불러오기
      await fetchProfile();
    } catch (e) {
      _errorMessage = '프로필 업데이트 오류: $e';
      debugPrint('프로필 업데이트 오류: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 프로필 사진 업데이트 메서드 추가
  Future<void> updateProfilePicture(File imageFile) async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = profileRepository.getCurrentUserId();
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.png';

      // Supabase storage에 이미지 업로드 (버킷 이름은 'avatars'로 가정)
      final String fullPath = await supabase.storage.from('avatars').upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      debugPrint('Uploaded file: $fullPath');

      // 업로드한 파일의 공개 URL 가져오기
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(fileName);
      debugPrint('Public URL: $publicUrl');

      // 프로필 업데이트 (avatar_url 필드를 업데이트한다고 가정)
      final updates = {
        'profile_image': publicUrl,
      };

      final updateResponse = await supabase
          .from('profiles')
          .update(updates)
          .eq('user_id', userId);
      if (updateResponse.error != null) {
        throw Exception(updateResponse.error!.message);
      }

      // 최신 프로필 정보 다시 불러오기
      await fetchProfile();
    } catch (e) {
      _errorMessage = '프로필 사진 업데이트 오류: $e';
      debugPrint(_errorMessage);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> fetchUserStats() async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      // 사용자 통계 조회 성공
      _userStats = await profileRepository.getCurrentUserStats();
      notifyListeners();
    } catch (e) {
      _errorMessage = '사용자 통계 조회 오류: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// private method
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
