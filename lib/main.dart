import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/view_models/collection_vm.dart';
import 'package:kolektt/view_models/home_vm.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'collection_view.dart';
import 'content_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDir.path);
  // Hive.registerAdapter(RecordAdapter()); // Hive 모델 등록

  // await Hive.openBox<Record>('records');

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
      ],
      child: CupertinoApp(
        title: 'Kolektt',
        theme: const CupertinoThemeData(
          primaryColor: primaryColor,
        ),
        home: const ContentView(),
      ),
    );
  }
}
