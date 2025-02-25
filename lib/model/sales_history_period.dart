enum SalesHistoryPeriod { week, month, threeMonths, sixMonths, year, all }

extension SalesHistoryPeriodExtension on SalesHistoryPeriod {
  String get rawValue {
    switch (this) {
      case SalesHistoryPeriod.week:
        return "1주일";
      case SalesHistoryPeriod.month:
        return "1개월";
      case SalesHistoryPeriod.threeMonths:
        return "3개월";
      case SalesHistoryPeriod.sixMonths:
        return "6개월";
      case SalesHistoryPeriod.year:
        return "1년";
      case SalesHistoryPeriod.all:
        return "전체";
    }
  }
}
