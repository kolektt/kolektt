import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/view/content_view.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_vm.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "새 비밀번호와 확인이 일치하지 않습니다.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthViewModel>();

    try {
      await auth.changePassword(_newPasswordController.text.trim());
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("비밀번호 변경 완료"),
            content: const Text("비밀번호가 성공적으로 변경되었습니다."),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder: (context) => ContentView(),
                    ),
                        (route) => false,
                  );
                },
                child: const Text("확인"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = "비밀번호 변경 오류: $e";
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
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "비밀번호 변경",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        previousPageTitle: "프로필",
        backgroundColor: CupertinoColors.systemBackground,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey5,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            // 키보드 외부 탭 시 키보드 닫기
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 아이콘 및 설명
                    const Center(
                      child: Icon(
                        CupertinoIcons.lock_shield,
                        size: 70,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "새로운 비밀번호 설정",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "보안을 위해 강력한 비밀번호를 사용하는 것이 좋습니다.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 새 비밀번호 입력 필드
                    const Text(
                      "새 비밀번호",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(
                            CupertinoIcons.lock,
                            color: CupertinoColors.systemGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CupertinoTextField(
                              controller: _newPasswordController,
                              placeholder: "새 비밀번호를 입력하세요",
                              obscureText: _obscureNewPassword,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              placeholderStyle: const TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 16,
                              ),
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    _obscureNewPassword
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                    color: CupertinoColors.systemGrey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 새 비밀번호 확인 필드
                    const Text(
                      "새 비밀번호 확인",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(
                            CupertinoIcons.lock_shield,
                            color: CupertinoColors.systemGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CupertinoTextField(
                              controller: _confirmPasswordController,
                              placeholder: "새 비밀번호를 다시 입력하세요",
                              obscureText: _obscureConfirmPassword,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              placeholderStyle: const TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 16,
                              ),
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    _obscureConfirmPassword
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                    color: CupertinoColors.systemGrey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 오류 메시지
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.exclamationmark_triangle_fill,
                              color: CupertinoColors.systemRed,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: CupertinoColors.systemRed,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 비밀번호 요구사항 가이드
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "비밀번호 요구사항",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 8),
                          _PasswordRequirement(
                            icon: CupertinoIcons.checkmark_circle,
                            text: "최소 8자 이상",
                          ),
                          SizedBox(height: 6),
                          _PasswordRequirement(
                            icon: CupertinoIcons.checkmark_circle,
                            text: "숫자 포함",
                          ),
                          SizedBox(height: 6),
                          _PasswordRequirement(
                            icon: CupertinoIcons.checkmark_circle,
                            text: "특수문자 포함",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 변경 버튼
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        color: CupertinoTheme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _isLoading ? null : _changePassword,
                        child: _isLoading
                            ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                        )
                            : const Text(
                          "비밀번호 변경하기",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 비밀번호 요구사항 아이템 위젯
class _PasswordRequirement extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PasswordRequirement({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: CupertinoColors.activeGreen,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }
}
