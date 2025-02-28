import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_vm.dart';

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "프로필 편집",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        previousPageTitle: "프로필",
        border: null,
      ),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 프로필 이미지 섹션
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey5,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: CupertinoColors.systemGrey4,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                CupertinoIcons.person_fill,
                                size: 50,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Text("프로필 사진 변경"),
                              onPressed: () {
                                // 프로필 사진 변경 로직
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 입력 필드 섹션
                      Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            _buildInputField(
                              label: "닉네임",
                              controller: _displayNameController,
                              placeholder: "닉네임을 입력해주세요",
                              showBorder: true,
                            ),
                            _buildInputField(
                              label: "장르",
                              controller: _genreController,
                              placeholder: "선호하는 장르를 입력해주세요",
                              showBorder: false,
                            ),
                          ],
                        ),
                      ),

                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: CupertinoColors.destructiveRed,
                            fontSize: 14,
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // 저장 버튼
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          borderRadius: BorderRadius.circular(8),
                          child: _isLoading
                              ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          )
                              : const Text(
                            "저장",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: _isLoading ? null : _saveProfile,
                        ),
                      ),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool showBorder = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey5,
            width: 1,
          ),
        )
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.black,
              ),
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              placeholder: placeholder,
              placeholderStyle: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 16,
              ),
              decoration: null,
              padding: EdgeInsets.zero,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
