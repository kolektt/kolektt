import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../components/analytics_section.dart';
import '../../components/collection_grid_item.dart';
import '../../model/local/collection_record.dart';
import '../../view_models/collection_vm.dart';
import '../auto_album_detection_view.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({Key? key}) : super(key: key);

  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  @override
  void initState() {
    super.initState();
    // Fetch collection records on initialization.
    Provider.of<CollectionViewModel>(context, listen: false)
        .fetchUserCollectionsWithRecords();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("컬렉션"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AutoAlbumDetectionScreen(),
              ),
            );
          },
          child: const Icon(
            CupertinoIcons.add_circled_solid,
            size: 32,
            color: CupertinoColors.black,
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<CollectionViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (model.collectionRecords.isEmpty) {
              return const Center(child: Text("컬렉션이 없습니다."));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnalyticsSection(records: model.collectionRecords),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: model.collectionRecords.length,
                    itemBuilder: (context, index) {
                      CollectionRecord record = model.collectionRecords[index];
                      record.record.resourceUrl = "https://api.discogs.com/releases/${record.record.id}";
                      return buildGridItem(context, record, model);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
