import 'package:flutter/material.dart';

/// 각 컨디션(Condition) 옵션을 표현하는 클래스입니다.
/// 해당 클래스는 불변 인스턴스로, 애플리케이션 전반에서 재사용할 수 있습니다.
class RecordCondition {
  final String name;
  final Color color;

  const RecordCondition._(this.name, this.color);

  // 각 옵션을 상수 인스턴스로 정의합니다.
  static const RecordCondition mint = RecordCondition._('Mint (M)', Color(0xFF4CAF50));
  static const RecordCondition nearMint = RecordCondition._('Near Mint (NM)', Color(0xFF8BC34A));
  static const RecordCondition veryGoodPlus = RecordCondition._('Very Good Plus (VG+)', Color(0xFFCDDC39));
  static const RecordCondition veryGood = RecordCondition._('Very Good (VG)', Color(0xFFFFEB3B));
  static const RecordCondition goodPlus = RecordCondition._('Good Plus (G+)', Color(0xFFFFC107));
  static const RecordCondition good = RecordCondition._('Good (G)', Color(0xFFFF9800));
  static const RecordCondition fair = RecordCondition._('Fair (F)', Color(0xFFFF5722));
  static const RecordCondition poor = RecordCondition._('Poor (P)', Color(0xFFE53935));

  /// 모든 조건 옵션의 목록을 반환합니다.
  static List<RecordCondition> get values => [
    mint,
    nearMint,
    veryGoodPlus,
    veryGood,
    goodPlus,
    good,
    fair,
    poor,
  ];

  /// [name]을 기반으로 해당하는 [RecordCondition] 인스턴스를 반환합니다.
  /// 존재하지 않을 경우 null을 반환합니다.
  static RecordCondition? fromName(String name) {
    try {
      return values.firstWhere((condition) => condition.name == name);
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() => name;
}
