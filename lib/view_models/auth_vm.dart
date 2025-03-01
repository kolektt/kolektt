// auth_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/supabase/profile.dart';
import '../model/supabase/user_stats.dart';
import '../repository/profile_repository.dart';

class AuthViewModel with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  final ProfileRepository profileRepository = ProfileRepository();

  Profiles? _profiles = null;
  get profiles => _profiles;

  UserStats? _userStats = null;
  get userStats => _userStats;

  bool _isLoading = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  /// 현재 로그인된 User
  get currentUser async => profileRepository.getCurrentUser();

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
      final userId = currentUser!.id;
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
    } finally {
      _setLoading(false);
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
