import 'interview_content.dart';
import 'interview_content_type.dart';
import 'record.dart';

class DJ {
  final String id;
  final String name;
  final String title;
  final Uri imageURL;
  final int yearsActive;
  final int recordCount;
  final List<InterviewContent> interviewContents;

  DJ({
    required this.id,
    required this.name,
    required this.title,
    required this.imageURL,
    required this.yearsActive,
    required this.recordCount,
    required this.interviewContents,
  });

  static List<DJ> sampleData = [
    DJ(
      id: "1",
      name: "DJ Huey",
      title: "House / Techno",
      imageURL: Uri.parse("https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain"),
      yearsActive: 5,
      recordCount: 248,
      interviewContents: [
        InterviewContent(
          id: "1",
          type: InterviewContentType.text,
          text: "DJ Huey is a DJ and producer based in Seoul, South Korea.",
          records: [],
        ),
        InterviewContent(
          id: "2",
          type: InterviewContentType.recordHighlight,
          text: "DJ Huey's Top 3 Records",
          records: Record.sampleData.take(3).toList(),
        ),
      ],
    ),
    DJ(
      id: "2",
      name: "DJ Sarah",
      title: "Techno / Electro",
      imageURL: Uri.parse("https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain"),
      yearsActive: 3,
      recordCount: 120,
      interviewContents: [
        InterviewContent(
          id: "1",
          type: InterviewContentType.text,
          text: "DJ Sarah is a DJ and producer based in Berlin, Germany.",
          records: [],
        ),
        InterviewContent(
          id: "2",
          type: InterviewContentType.recordHighlight,
          text: "DJ Sarah's Top 3 Records",
          records: Record.sampleData.take(3).toList(),
        ),
      ],
    ),
  ];
}
