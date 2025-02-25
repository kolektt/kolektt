import 'package:flutter/cupertino.dart';

import '../components/sales_analysis_card.dart';
import '../components/sales_list_row.dart';
import '../main.dart';
import '../model/sale_record.dart';
import '../model/sales_history_period.dart';

class SalesHistoryView extends StatefulWidget {
  const SalesHistoryView({Key? key}) : super(key: key);

  @override
  _SalesHistoryViewState createState() => _SalesHistoryViewState();
}

class _SalesHistoryViewState extends State<SalesHistoryView> {
  SalesHistoryPeriod selectedPeriod = SalesHistoryPeriod.all;
  final List<SaleRecord> salesData = SaleRecord.sampleData;

  List<SaleRecord> get filteredSales {
    final now = DateTime.now();
    return salesData.where((sale) {
      final diff = now.difference(sale.saleDate);
      switch (selectedPeriod) {
        case SalesHistoryPeriod.week:
          return diff.inDays <= 7;
        case SalesHistoryPeriod.month:
          return diff.inDays <= 30;
        case SalesHistoryPeriod.threeMonths:
          return diff.inDays <= 90;
        case SalesHistoryPeriod.sixMonths:
          return diff.inDays <= 180;
        case SalesHistoryPeriod.year:
          return diff.inDays <= 365;
        case SalesHistoryPeriod.all:
          return true;
      }
    }).toList();
  }

  int get totalRevenue =>
      filteredSales.fold(0, (sum, sale) => sum + sale.price);

  int get averagePrice =>
      filteredSales.isEmpty ? 0 : totalRevenue ~/ filteredSales.length;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("판매 내역")),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // 기간 필터
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: SalesHistoryPeriod.values.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final period = SalesHistoryPeriod.values[index];
                    return CupertinoButton(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: selectedPeriod == period
                          ? primaryColor
                          : CupertinoColors.systemGrey4,
                      borderRadius: BorderRadius.circular(20),
                      onPressed: () {
                        setState(() {
                          selectedPeriod = period;
                        });
                      },
                      child: Text(
                        period.rawValue,
                        style: TextStyle(
                            color: selectedPeriod == period
                                ? CupertinoColors.white
                                : CupertinoColors.black),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              // 판매 분석 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SalesAnalysisCard(
                        title: "총 판매액",
                        value: "$totalRevenue원",
                        icon: CupertinoIcons.money_dollar_circle,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SalesAnalysisCard(
                        title: "평균 판매가",
                        value: "$averagePrice원",
                        icon: CupertinoIcons.chart_bar,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // 판매 내역 리스트
              Column(
                children: filteredSales
                    .map((sale) => SalesListRow(sale: sale))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}