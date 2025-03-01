import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddRecordView extends StatefulWidget {
  final Function(String title, String artist, int? year, String genre, String notes) onSave;

  const AddRecordView({Key? key, required this.onSave}) : super(key: key);

  @override
  _AddRecordViewState createState() => _AddRecordViewState();
}

class _AddRecordViewState extends State<AddRecordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _artistController;
  late TextEditingController _yearController;
  late TextEditingController _genreController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _artistController = TextEditingController();
    _yearController = TextEditingController();
    _genreController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    if (!_formKey.currentState!.validate()) return;
    int? year = int.tryParse(_yearController.text.trim());
    widget.onSave(
      _titleController.text.trim(),
      _artistController.text.trim(),
      year,
      _genreController.text.trim(),
      _notesController.text.trim(),
    );
    Navigator.pop(context);
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool showBorder = true,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    const Color textColor = Color(0xFF2D3748);
    const Color lightGrey = Color(0xFFEDF2F7);
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
          bottom: BorderSide(
            color: lightGrey,
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
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: const TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF7FAFC);
    const Color textColor = Color(0xFF2D3748);
    const Color lightGrey = Color(0xFFEDF2F7);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "수동 입력",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        previousPageTitle: "기록",
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
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
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
                      label: "앨범명",
                      controller: _titleController,
                      placeholder: "앨범명을 입력해주세요",
                      icon: CupertinoIcons.music_note,
                    ),
                    _buildInputField(
                      label: "아티스트",
                      controller: _artistController,
                      placeholder: "아티스트를 입력해주세요",
                      icon: CupertinoIcons.person,
                    ),
                    _buildInputField(
                      label: "발매년도",
                      controller: _yearController,
                      placeholder: "발매년도를 입력해주세요",
                      keyboardType: TextInputType.number,
                      icon: CupertinoIcons.calendar,
                    ),
                    _buildInputField(
                      label: "장르",
                      controller: _genreController,
                      placeholder: "장르를 입력해주세요",
                      icon: CupertinoIcons.music_note_2,
                    ),
                    _buildInputField(
                      label: "노트",
                      controller: _notesController,
                      placeholder: "노트를 입력해주세요",
                      maxLines: 3,
                      icon: CupertinoIcons.text_badge_checkmark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CupertinoButton.filled(
                child: const Text(
                  "저장",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
                onPressed: _saveRecord,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}