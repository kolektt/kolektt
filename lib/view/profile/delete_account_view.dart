import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/auth_vm.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({Key? key}) : super(key: key);

  @override
  _DeleteAccountViewState createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  bool _isLoading = false;
  String? _errorMessage;

  Future _deleteAccount() async {
    // 삭제 전 재확인 다이얼로그
    final confirm = await showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text("계정 삭제 확인"),
          content: const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.",
              style: TextStyle(fontSize: 15),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("취소"),
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                "삭제",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthViewModel>();

    try {
      await auth.deleteAccount();
      // 계정 삭제 후 로그인 화면 등으로 이동
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      setState(() {
        _errorMessage = "계정 삭제 오류: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "계정 삭제",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        previousPageTitle: "설정",
        backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey4,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey5.withOpacity(0.8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(
                      CupertinoIcons.exclamationmark_triangle_fill,
                      color: CupertinoColors.systemYellow,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "계정 삭제 시 주의사항",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "• 모든 개인 데이터가 영구적으로 삭제됩니다\n"
                          "• 진행 중인 활동이 모두 중단됩니다\n"
                          "• 구독이 있는 경우 별도로 취소해야 합니다",
                      style: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.systemGrey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.destructiveRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: CupertinoColors.destructiveRed.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_circle_fill,
                        color: CupertinoColors.destructiveRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: CupertinoColors.destructiveRed,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _isLoading ? null : _deleteAccount,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        CupertinoColors.systemRed,
                        Color(0xFFCF2B3F),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemRed.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CupertinoActivityIndicator(
                      color: CupertinoColors.white,
                    )
                        : const Text(
                      "계정 삭제",
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: CupertinoButton(
                  child: const Text(
                    "돌아가기",
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Text(
                    "계정 관련 도움이 필요하신가요?",
                    style: TextStyle(
                      color: CupertinoColors.systemGrey.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      "고객센터에 문의하기",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      // 고객센터 연결 로직
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
