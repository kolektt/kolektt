import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/view/content_view.dart';
import 'package:kolektt/view_models/collection_vm.dart';
import 'package:kolektt/view_models/home_vm.dart';
import 'package:kolektt/view_models/search_vm.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// 기본 색상 (hex 코드 0036FF)
final Color primaryColor = Color(0xFF0036FF);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDir.path);
  // Hive.registerAdapter(RecordAdapter()); // Hive 모델 등록

  // await Hive.openBox<Record>('records');

  await Supabase.initialize(
    url: 'https://awdnjducwqwfmbfigugq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3ZG5qZHVjd3F3Zm1iZmlndWdxIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MDQ4OTk5MywiZXhwIjoyMDU2MDY1OTkzfQ.S6u5gaLR5JeL76aJa0jRXzvTGeIYsXU4qPJ63QEEY1I',
  );

  runApp(const KolekttApp());
}

class KolekttApp extends StatelessWidget {
  const KolekttApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CollectionViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: CupertinoApp(
        title: 'Kolektt',
        theme: CupertinoThemeData(
          primaryColor: primaryColor,
        ),
        home: const ContentView(),
      ),
    );
  }
}
