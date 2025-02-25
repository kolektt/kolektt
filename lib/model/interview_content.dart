import 'package:kolektt/model/record.dart';

import 'interview_content_type.dart';

class InterviewContent {
  final String id;
  final InterviewContentType type;
  final String text;
  final List<Record> records;

  InterviewContent({
    required this.id,
    required this.type,
    required this.text,
    required this.records,
  });
}
