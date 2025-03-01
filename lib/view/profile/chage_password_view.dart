import 'package:flutter/cupertino.dart';
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text("비밀번호 변경"),
        previousPageTitle: "프로필",
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CupertinoTextField(
                  controller: _newPasswordController,
                  placeholder: "새 비밀번호",
                  obscureText: true,
                  padding: const EdgeInsets.all(16),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _confirmPasswordController,
                  placeholder: "새 비밀번호 확인",
                  obscureText: true,
                  padding: const EdgeInsets.all(16),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: _isLoading ? null : _changePassword,
                    child: _isLoading
                        ? const CupertinoActivityIndicator(
                      color: CupertinoColors.white,
                    )
                        : const Text("비밀번호 변경"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
