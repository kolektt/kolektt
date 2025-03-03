import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../view_models/auth_vm.dart';
import 'chage_password_view.dart';
import 'delete_account_view.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _genreController;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthViewModel>();
    _displayNameController =
        TextEditingController(text: auth.profiles?.display_name ?? '');
    _genreController = TextEditingController(text: auth.profiles?.genre ?? '');
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthViewModel>();
    try {
      await auth.updateProfile(
        displayName: _displayNameController.text.trim(),
        genre: _genreController.text.trim(),
      );
      await auth.fetchProfile();
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = '프로필 업데이트 실패: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 프로필 사진 선택 및 업데이트 로직
  Future<void> _pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      // 갤러리에서 이미지 선택
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File imageFile = File(image.path);
        final auth = context.read<AuthViewModel>();
        await auth.updateProfilePicture(imageFile);
      }
    } catch (e) {
      setState(() {
        _errorMessage = '프로필 사진 업데이트 실패: $e';
      });

      // Show alert dialog with error message
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("프로필 사진 업데이트 오류"),
            content: const Text("프로필 사진을 업데이트하는 중 오류가 발생했습니다. 다시 시도해주세요."),
            actions: [
              CupertinoDialogAction(
                child: const Text("확인"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 앱의 주요 테마 컬러 정의
    const Color primaryColor = Color(0xFF5E72E4);
    const Color secondaryColor = Color(0xFF11CDEF);
    const Color backgroundColor = Color(0xFFF7FAFC);
    const Color textColor = Color(0xFF2D3748);
    const Color lightGrey = Color(0xFFEDF2F7);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "프로필 편집",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        previousPageTitle: "프로필",
        backgroundColor: CupertinoColors.white,
        border: const Border(
          bottom: BorderSide(
            color: lightGrey,
            width: 1,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 프로필 이미지 섹션 - 개선된 디자인
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: lightGrey,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: CupertinoColors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.person_fill,
                                    size: 60,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.camera_fill,
                                    size: 18,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Text(
                                "프로필 사진 변경",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: _pickProfileImage, // 이미지 선택 및 업데이트 호출
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 섹션 타이틀
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 15),
                        child: Text(
                          "기본 정보",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),

                      // 입력 필드 섹션 - 개선된 디자인
                      Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInputField(
                              label: "닉네임",
                              controller: _displayNameController,
                              placeholder: "닉네임을 입력해주세요",
                              showBorder: true,
                              icon: CupertinoIcons.person,
                            ),
                            _buildInputField(
                              label: "장르",
                              controller: _genreController,
                              placeholder: "선호하는 장르를 입력해주세요",
                              showBorder: false,
                              icon: CupertinoIcons.music_note,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 계정 관리 섹션 타이틀
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 15),
                        child: Text(
                          "계정 관리",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),

                      // 계정 관리 버튼들 - 개선된 디자인
                      Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildActionButton(
                              icon: CupertinoIcons.lock,
                              label: "비밀번호 변경",
                              showBorder: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (_) => const ChangePasswordView()),
                                );
                              },
                            ),
                            _buildActionButton(
                              icon: CupertinoIcons.delete,
                              label: "계정 삭제",
                              isDestructive: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (_) => const DeleteAccountView()),
                                );
                              },
                            ),
                            _buildActionButton(
                              icon: CupertinoIcons.arrow_left_right,
                              label: "로그아웃",
                              onPressed: () async {
                                final auth = context.read<AuthViewModel>();
                                await auth.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => KolekttApp(),
                                    maintainState: false,
                                  ),
                                  (route) => true,
                                );
                              },
                            )
                          ],
                        ),
                      ),

                      if (_errorMessage != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.destructiveRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.exclamationmark_triangle_fill,
                                color: CupertinoColors.destructiveRed,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: CupertinoColors.destructiveRed,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      // 저장 버튼 - 개선된 디자인
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          borderRadius: BorderRadius.circular(12),
                          color: primaryColor,
                          child: _isLoading
                              ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          )
                              : const Text(
                            "변경사항 저장",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.white,
                            ),
                          ),
                          onPressed: _isLoading ? null : _saveProfile,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 개선된 입력 필드 위젯
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool showBorder = true,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
          bottom: BorderSide(
            color: Color(0xFFEDF2F7),
            width: 1,
          ),
        )
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 22,
              color: const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 12),
          ],
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              placeholder: placeholder,
              placeholderStyle: const TextStyle(
                color: Color(0xFFA0AEC0),
                fontSize: 16,
              ),
              decoration: null,
              padding: EdgeInsets.zero,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 새로운 액션 버튼 위젯
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool showBorder = false,
    bool isDestructive = false,
  }) {
    final Color textColor = isDestructive
        ? CupertinoColors.destructiveRed
        : const Color(0xFF2D3748);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(
            bottom: BorderSide(
              color: Color(0xFFEDF2F7),
              width: 1,
            ),
          )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDestructive
                  ? CupertinoColors.destructiveRed
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const Spacer(),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: Color(0xFFA0AEC0),
            ),
          ],
        ),
      ),
    );
  }
}
