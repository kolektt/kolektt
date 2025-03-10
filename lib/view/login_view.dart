import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../view_models/auth_vm.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final size = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('로그인', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: CupertinoColors.systemBackground,
        border: Border.all(color: Colors.transparent),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.05),

                // 로고 또는 앱 이름 영역
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      size: 50,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // 환영 메시지
                Center(
                  child: Text(
                    '환영합니다',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                ),

                Center(
                  child: Text(
                    '계정에 로그인하세요',
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),

                SizedBox(height: 36),

                // 에러 메시지
                if (authVM.errorMessage != null) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      authVM.errorMessage!,
                      style: TextStyle(color: CupertinoColors.systemRed),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24),
                ],

                // 이메일 입력 필드
                Text(
                  '이메일',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: CupertinoColors.darkBackgroundGray,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CupertinoTextField(
                    controller: _emailController,
                    placeholder: '이메일을 입력하세요',
                    padding: EdgeInsets.all(16),
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Icon(
                        CupertinoIcons.mail,
                        color: CupertinoColors.activeBlue,
                        size: 20,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                SizedBox(height: 24),

                // 비밀번호 입력 필드
                Text(
                  '비밀번호',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: CupertinoColors.darkBackgroundGray,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CupertinoTextField(
                    controller: _pwController,
                    placeholder: '비밀번호를 입력하세요',
                    padding: EdgeInsets.all(16),
                    obscureText: !_isPasswordVisible,
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Icon(
                        CupertinoIcons.lock,
                        color: CupertinoColors.activeBlue,
                        size: 20,
                      ),
                    ),
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // 비밀번호 찾기 링크
                Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      '비밀번호를 잊으셨나요?',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    onPressed: () {
                      // 비밀번호 찾기 기능 구현
                    },
                  ),
                ),

                SizedBox(height: 32),

                // 로그인 버튼
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CupertinoColors.activeBlue,
                        CupertinoColors.systemBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.activeBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(12),
                    onPressed: authVM.isLoading
                        ? null
                        : () async {
                      await authVM.signIn(
                        _emailController.text.trim(),
                        _pwController.text.trim(),
                      );
                      if (authVM.currentUser != null) {
                        Navigator.pushAndRemoveUntil(
                            context, CupertinoPageRoute(builder: (context) => AuthenticationWrapper()), (route) => false);
                      }
                    },
                    child: authVM.isLoading
                        ? CupertinoActivityIndicator(color: CupertinoColors.white)
                        : Text(
                      '로그인',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // 회원가입 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요?',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      onPressed: () async {
                        await authVM.signUp(
                          _emailController.text.trim(),
                          _pwController.text.trim(),
                        );
                        if (authVM.currentUser != null) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // 소셜 로그인 옵션
                Center(
                  child: Text(
                    '또는 다음으로 계속하기',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 14,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // 소셜 로그인 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      Icons.g_mobiledata,
                      Colors.blue,
                      () async {
                        await context.read<AuthViewModel>().signInWithGoogle();
                        if (authVM.currentUser != null) {
                          Navigator.pushAndRemoveUntil(
                              context, CupertinoPageRoute(builder: (context) => AuthenticationWrapper()), (route) => false);
                        }
                    },
                    ),
                    SizedBox(width: 16),
                    _buildSocialButton(
                      CupertinoIcons.app,
                      Colors.black,
                      () => context.read<AuthViewModel>().signInWithApple(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
