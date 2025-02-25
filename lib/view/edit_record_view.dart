import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/record.dart';

class EditRecordView extends StatefulWidget {
  final Record record;

  EditRecordView({required this.record});

  @override
  _EditRecordViewState createState() => _EditRecordViewState();
}

class _EditRecordViewState extends State<EditRecordView> {
  late TextEditingController titleController;
  late TextEditingController artistController;
  late TextEditingController releaseYearController;
  late TextEditingController genreController;
  late TextEditingController notesController;
  late TextEditingController catalogNumberController;
  late TextEditingController labelController;
  late TextEditingController formatController;
  late TextEditingController countryController;
  late TextEditingController styleController;
  late TextEditingController conditionController;
  late TextEditingController conditionNotesController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.record.title);
    artistController = TextEditingController(text: widget.record.artist);
    releaseYearController = TextEditingController(
        text: widget.record.releaseYear?.toString() ?? "");
    genreController = TextEditingController(text: widget.record.genre ?? "");
    notesController = TextEditingController(text: widget.record.notes ?? "");
    catalogNumberController =
        TextEditingController(text: widget.record.catalogNumber ?? "");
    labelController = TextEditingController(text: widget.record.label ?? "");
    formatController = TextEditingController(text: widget.record.format ?? "");
    countryController =
        TextEditingController(text: widget.record.country ?? "");
    styleController = TextEditingController(text: widget.record.style ?? "");
    conditionController =
        TextEditingController(text: widget.record.condition ?? "NM");
    conditionNotesController =
        TextEditingController(text: widget.record.conditionNotes ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("레코드 수정"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.check_mark),
          onPressed: () {
            saveRecord();
            Navigator.pop(context);
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text("기본 정보",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CupertinoTextField(
                  controller: titleController, placeholder: "앨범명"),
              SizedBox(height: 8),
              CupertinoTextField(
                  controller: artistController, placeholder: "아티스트"),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: releaseYearController,
                placeholder: "발매년도",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              CupertinoTextField(
                  controller: genreController, placeholder: "장르"),
              SizedBox(height: 16),
              Text("Discogs 메타데이터",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CupertinoTextField(
                  controller: catalogNumberController, placeholder: "카탈로그 번호"),
              SizedBox(height: 8),
              CupertinoTextField(
                  controller: labelController, placeholder: "레이블"),
              SizedBox(height: 8),
              CupertinoTextField(
                  controller: formatController, placeholder: "포맷"),
              SizedBox(height: 8),
              CupertinoTextField(
                  controller: countryController, placeholder: "국가"),
              SizedBox(height: 8),
              CupertinoTextField(
                  controller: styleController, placeholder: "스타일"),
              SizedBox(height: 16),
              Text("레코드 상태",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // For a Cupertino-style segmented control, you might use CupertinoSegmentedControl
              DropdownButton<String>(
                value: conditionController.text,
                items: [
                  DropdownMenuItem(
                      child: Text("M - Mint (완벽한 상태)"), value: "M"),
                  DropdownMenuItem(
                      child: Text("NM - Near Mint (거의 새것)"), value: "NM"),
                  DropdownMenuItem(
                      child: Text("VG+ - Very Good Plus (매우 좋음)"),
                      value: "VG+"),
                  DropdownMenuItem(
                      child: Text("VG - Very Good (좋음)"), value: "VG"),
                  DropdownMenuItem(
                      child: Text("G+ - Good Plus (양호)"), value: "G+"),
                  DropdownMenuItem(child: Text("G - Good (보통)"), value: "G"),
                  DropdownMenuItem(child: Text("F - Fair (나쁨)"), value: "F"),
                ],
                onChanged: (value) {
                  setState(() {
                    conditionController.text = value ?? "NM";
                  });
                },
                // Cupertino doesn't have a built-in dropdown, so you might need a custom solution.
              ),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: conditionNotesController,
                placeholder: "상태 설명",
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Text("노트",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CupertinoTextField(
                controller: notesController,
                placeholder: "노트",
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveRecord() {
    setState(() {
      widget.record.title = titleController.text;
      widget.record.artist = artistController.text;
      widget.record.releaseYear = int.tryParse(releaseYearController.text);
      widget.record.genre = genreController.text;
      widget.record.notes = notesController.text;
      widget.record.catalogNumber = catalogNumberController.text;
      widget.record.label = labelController.text;
      widget.record.format = formatController.text;
      widget.record.country = countryController.text;
      widget.record.style = styleController.text;
      widget.record.condition = conditionController.text;
      widget.record.conditionNotes = conditionNotesController.text;
      widget.record.updatedAt = DateTime.now();
    });
  }
}
