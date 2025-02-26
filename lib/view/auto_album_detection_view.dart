import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// CollectionViewModel에서 recognizeAlbum() 사용 (Google Vision + Discogs)
import '../view_models/collection_vm.dart';

class AutoAlbumDetectionScreen extends StatefulWidget {
  const AutoAlbumDetectionScreen({Key? key}) : super(key: key);

  @override
  State<AutoAlbumDetectionScreen> createState() =>
      _AutoAlbumDetectionScreenState();
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
                Expanded(child: _buildResultsList(context, vm)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 검색 결과 리스트 빌드
  Widget _buildResultsList(BuildContext context, CollectionViewModel vm) {
    // 검색 결과가 없다면 안내 텍스트
    if (!vm.isLoading && vm.errorMessage == null && vm.searchResults.isEmpty) {
      return const Center(
        child: Text('인식된 앨범이 없습니다.\n사진 촬영 후 결과가 여기 표시됩니다.',
            textAlign: TextAlign.center),
      );
    }

    return ListView.builder(
      itemCount: vm.searchResults.length,
      itemBuilder: (context, index) {
        final record = vm.searchResults[index];

        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // TODO: 선택 시 컬렉션에 추가하거나 상세 화면으로 이동
            // vm.addToCollection(record);
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
                // 썸네일
                if (record.thumb.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      record.thumb,
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
                // 앨범 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(record.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (record.artists.isNotEmpty)
                        Text(record.artists[0].name),
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.add),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 카메라를 실행하고 사진을 촬영한 후 앨범 인식(= Google Vision + Discogs 검색)
  Future<void> _takePhotoAndDetect() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        Navigator.pop(context); // 사용자가 카메라 취소 시 화면 닫기
        return;
      }

      final collectionVM = context.read<CollectionViewModel>();
      await collectionVM.recognizeAlbum(File(image.path));
    } catch (e) {
      // 만약 별도의 에러 처리 메서드를 쓴다면 사용
      // collectionVM.setErrorMessage('사진 촬영 또는 인식 중 오류 발생: $e');
    }
  }
}
