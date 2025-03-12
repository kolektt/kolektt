import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cupernino_bottom_sheet/flutter_cupernino_bottom_sheet.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

// CollectionViewModel에서 recognizeAlbum() 사용 (Google Vision + Discogs)
import '../components/cupertino_chip.dart';
import '../view_models/collection_vm.dart';
import 'SearchView.dart';
import 'add_to_collection_view.dart';

class AutoAlbumDetectionScreen extends StatefulWidget {
  const AutoAlbumDetectionScreen({Key? key}) : super(key: key);

  @override
  State<AutoAlbumDetectionScreen> createState() => _AutoAlbumDetectionScreenState();
}

class _AutoAlbumDetectionScreenState extends State<AutoAlbumDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  bool hasRunCamera = false; // 카메라 한 번만 실행하기 위한 플래그

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasRunCamera) {
      hasRunCamera = true;
      // 약간의 지연 후 카메라 실행 (UI가 완전히 빌드된 후)
      Future.delayed(const Duration(milliseconds: 500), _takePhotoAndDetect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading)
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CupertinoActivityIndicator()));

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('사진으로 앨범 찾기'),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // 에러 메시지
                if (vm.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: CupertinoColors.systemRed),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // 검색 결과
                _buildPartialMatchingImagesRow(vm),
                Expanded(child: _buildResultsList(context, vm)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 예상 이미지 이름 Chip Row
  Widget _buildPartialMatchingImagesRow(CollectionViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: vm.partialMatchingImages.map((e) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CupertinoChip(label: e, onTap: () async {
                await vm.searchOnDiscogs(e);
              },),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 검색 결과 리스트 빌드
  Widget _buildResultsList(BuildContext context, CollectionViewModel vm) {
    if (!vm.isLoading && vm.errorMessage == null && vm.searchResults.isEmpty) {
      return const Center(
        child: Text(
          '인식된 앨범이 없습니다.\n사진 촬영 후 결과가 여기 표시됩니다.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: vm.searchResults.length,
      itemBuilder: (context, index) {
        final record = vm.searchResults[index];

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)), // 슬라이드 업 효과
                child: child,
              ),
            );
          },
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // AddToCollectionScreen으로 이동
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => AddToCollectionScreen(record: record),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: CupertinoColors.systemGrey4),
                ),
              ),
              child: Row(
                children: [
                  if (record.coverImage.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: record.coverImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(CupertinoIcons.music_note),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Icon(CupertinoIcons.add),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 카메라를 실행하고 사진을 촬영한 후 앨범 인식(= Google Vision + Discogs 검색)
  /// 문서 스캐너를 실행하고 스캔된 이미지로 앨범 인식
  Future<void> _takePhotoAndDetect() async {
    try {
      final dynamic scannedDocs =
          await FlutterDocScanner().getScannedDocumentAsImages(page: 1);
      if (scannedDocs == null || scannedDocs.isEmpty) {
        Navigator.pop(context); // 사용자가 스캔 취소 시 화면 닫기
        return;
      }

      String uriString = scannedDocs['Uri'];

      // 정규 표현식을 사용해 imageUri 값을 추출합니다.
      final RegExp regex = RegExp(r'imageUri=([^}]+)');
      final Match? match = regex.firstMatch(uriString);

      debugPrint('scannedDocs: ${match?.group(1)}');

      final collectionVM = context.read<CollectionViewModel>();
      await collectionVM
          .recognizeAlbum(File.fromUri(Uri.parse(match!.group(1).toString())));
    } catch (e) {
      final collectionVM = context.read<CollectionViewModel>();
      collectionVM.errorMessage = '문서 스캔 또는 인식 중 오류 발생: ${e.toString()}';
    }
  }
}
