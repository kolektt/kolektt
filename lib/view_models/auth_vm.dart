// auth_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  /// 현재 로그인된 User
  User? get currentUser => supabase.auth.currentUser;

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

  /// private method
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
