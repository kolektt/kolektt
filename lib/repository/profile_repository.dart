import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/supabase/profile.dart';
import '../model/supabase/user_stats.dart';

class ProfileRepository {
  static const String tableName = 'profiles';
  final supabase = Supabase.instance.client;

  User getCurrentUser() {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in');
    }
    return supabase.auth.currentUser!;
  }

  String getCurrentUserId() {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in');
    }
    return supabase.auth.currentUser!.id;
  }

  Future<Profiles?> getCurrentProfile() async {
    final response = await supabase
        .from(tableName)
        .select()
        .eq('user_id', getCurrentUserId())
        .single();
    return Profiles.fromJson(response);
  }

  Future<UserStats> getCurrentUserStats() async {
    final response = await supabase
        .from('user_stats')
        .select()
        .eq('user_id', getCurrentUserId())
        .single();
    return UserStats.fromJson(response);
  }

  Future<Profiles> getProfileById(String userId) async {
    final response = await supabase
        .from(tableName)
        .select()
        .eq('user_id', userId)
        .single();
    return Profiles.fromJson(response);
  }

  Future<List<Profiles>> getProfilesByUserIds(List<String> sellersList) async {
    // 한 번의 쿼리로 중복 없이 필요한 모든 프로필을 가져옵니다.
    final response = await supabase
        .from(tableName)
        .select()
        .inFilter('user_id', sellersList);

    debugPrint('getProfilesByUserIds response: $response');

    // Supabase의 응답(response)이 List<dynamic>라고 가정
    final profilesList = (response as List)
        .map((e) => Profiles.fromJson(e))
        .toList();

    // 사용자 ID를 key로 하는 Map을 구성합니다.
    final profilesMap = {for (var profile in profilesList) profile.user_id: profile};

    // 입력 리스트의 순서와 중복을 유지하여 결과 리스트 구성
    final result = <Profiles>[];
    for (final id in sellersList) {
      if (profilesMap.containsKey(id)) {
        result.add(profilesMap[id]!);
      }
    }

    debugPrint('getProfilesByUserIds result: $result');
    return result;
  }
}
