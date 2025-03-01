import 'package:flutter/cupertino.dart';
import 'package:kolektt/view_models/sale_vm.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../model/supabase/sales_listings.dart';
import '../view_models/auth_vm.dart';

class SalesView extends StatefulWidget {
  final int recordId;

  const SalesView({Key? key, required this.recordId}) : super(key: key);

  @override
  _SalesViewState createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  final TextEditingController _priceController = TextEditingController();
  final List<String> _conditionOptions = [
    'Mint',
    'Near Mint',
    'Good',
    'Fair',
    'Poor'
  ];
  String _selectedCondition = 'Mint';
  late AuthViewModel auth;

  @override
  void initState() {
    super.initState();
    auth = context.read<AuthViewModel>();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  /// 상품 상태 선택 ActionSheet
  void _showConditionPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) {
        return CupertinoActionSheet(
          title: const Text("상품 상태 선택"),
          actions: _conditionOptions.map((option) {
            return CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  _selectedCondition = option;
                });
                Navigator.pop(modalContext); // modalContext 사용
              },
              child: Text(option),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            child: const Text("취소"),
            onPressed: () => Navigator.pop(modalContext), // modalContext 사용
          ),
        );
      },
    );
  }

  /// 판매 등록 처리 (실제 API 호출 등으로 확장 가능)
  Future<void> _submitSale() async {
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    if (price <= 0) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("오류"),
            content: const Text("유효한 가격을 입력해주세요."),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text("확인"),
              )
            ],
          );
        },
      );
      return;
    }

    // 현재 사용자 ID는 실제 인증 로직을 통해 가져와야 합니다.
    String userId = auth.supabase.auth.currentUser!.id;
    // 실제 uuid 패키지 등을 이용해 생성할 수 있습니다.
    var uuid = Uuid();
    String id = uuid.v4();

    final sale = SalesListing(
      id: id,
      userId: userId,
      price: price,
      condition: _selectedCondition,
      status: "For Sale",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      recordId: widget.recordId,
    );
    debugPrint("Sale to submit: ${sale.toJson()}");

    final saleViewModel = context.read<SaleViewModel>();
    await saleViewModel.addSale(sale);

    // 아래는 성공 메시지 예시입니다.
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("판매 등록 완료"),
          content: const Text("판매가 성공적으로 등록되었습니다."),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // 이전 화면으로 돌아가기
              },
              child: const Text("확인"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleViewModel>(
      builder: (BuildContext context, SaleViewModel value, Widget? child) {
        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text("판매 등록"),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "레코드 ID: ${widget.recordId}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _priceController,
                    placeholder: "판매 가격 입력 (₩)",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    padding: const EdgeInsets.all(16),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _showConditionPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("상품 상태: $_selectedCondition"),
                          const Icon(CupertinoIcons.chevron_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  CupertinoButton.filled(
                    onPressed: _submitSale,
                    child: const Text("판매 등록"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
