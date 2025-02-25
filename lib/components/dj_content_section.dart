import 'package:flutter/cupertino.dart';

import '../model/interview_content.dart';
import '../model/interview_content_type.dart';
import 'dj_record_sectino.dart';

class DJContentSection extends StatelessWidget {
  final InterviewContent content;

  const DJContentSection({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case InterviewContentType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            content.text,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        );
      case InterviewContentType.quote:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: CupertinoColors.systemGrey6,
            child: Text(
              content.text,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        );
      case InterviewContentType.recordHighlight:
        return DJRecordSection(content: content);
      default:
        return const SizedBox();
    }
  }
}
