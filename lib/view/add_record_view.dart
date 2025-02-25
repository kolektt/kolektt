import 'package:flutter/cupertino.dart';

class AddRecordView extends StatefulWidget {
  final Function(String, String, int?, String?, String?) onSave;

  AddRecordView({required this.onSave});

  @override
  _AddRecordViewState createState() => _AddRecordViewState();
}

class _AddRecordViewState extends State<AddRecordView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("수동 입력")),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              CupertinoTextField(
                  controller: titleController, placeholder: "앨범명"),
              SizedBox(height: 8),
              CupertinoTextField(
                  controller: artistController, placeholder: "아티스트"),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: yearController,
                placeholder: "발매년도",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              CupertinoTextField(
                  controller: genreController, placeholder: "장르"),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: notesController,
                placeholder: "노트",
                maxLines: 3,
              ),
              SizedBox(height: 16),
              CupertinoButton.filled(
                child: Text("저장"),
                onPressed: () {
                  int? year = int.tryParse(yearController.text);
                  widget.onSave(titleController.text, artistController.text,
                      year, genreController.text, notesController.text);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
