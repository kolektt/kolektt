import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../components/cupertino_chip.dart';
import '../view_models/collection_vm.dart';
import 'add_collection_view.dart';

class AutoAlbumDetectionScreen extends StatefulWidget {
  const AutoAlbumDetectionScreen({Key? key}) : super(key: key);

  @override
  State<AutoAlbumDetectionScreen> createState() =>
      _AutoAlbumDetectionScreenState();
}

class _AutoAlbumDetectionScreenState extends State<AutoAlbumDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _hasLaunchedCamera = false; // 카메라를 한 번만 실행하기 위한 플래그

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLaunchedCamera) {
      _hasLaunchedCamera = true;
      Future.delayed(const Duration(milliseconds: 500), _initiatePhotoCapture);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionViewModel>(
      builder: (context, collectionVM, child) {
        if (collectionVM.isLoading) return _buildLoadingIndicator(context);

        return CupertinoPageScaffold(
          navigationBar: _buildNavigationBar(context),
          child: SafeArea(
            child: Column(
              children: [
                if (collectionVM.errorMessage != null)
                  _buildErrorMessage(collectionVM.errorMessage!),
                _buildPartialMatchingImagesRow(collectionVM),
                Expanded(child: _buildResultsList(collectionVM)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 로딩 인디케이터 위젯
  Widget _buildLoadingIndicator(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// 네비게이션 바 위젯
  CupertinoNavigationBar _buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: const Text('사진으로 앨범 찾기'),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Text("취소"),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// 에러 메시지 위젯
  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        message,
        style: const TextStyle(color: CupertinoColors.systemRed),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 부분 매칭 이미지 Chip Row 빌드
  Widget _buildPartialMatchingImagesRow(CollectionViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: vm.partialMatchingImages.map((imageName) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CupertinoChip(
                label: imageName,
                onTap: () async => await vm.searchOnDiscogs(imageName),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 검색 결과 리스트 빌드
  Widget _buildResultsList(CollectionViewModel vm) {
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
        return _buildResultItem(record);
      },
    );
  }

  /// 개별 검색 결과 아이템 빌드
  Widget _buildResultItem(record) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _navigateToAddToCollection(record),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: CupertinoColors.systemGrey4),
            ),
          ),
          child: Row(
            children: [
              _buildRecordImage(record),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  record.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(CupertinoIcons.add),
            ],
          ),
        ),
      ),
    );
  }

  /// 앨범 커버 이미지 또는 기본 아이콘 표시 위젯
  Widget _buildRecordImage(record) {
    if (record.coverImage.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: record.coverImage,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(CupertinoIcons.music_note),
      );
    }
  }

  /// AddToCollectionScreen으로 네비게이션
  void _navigateToAddToCollection(record) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => AddCollectionView(record: record),
      ),
    );
  }

  /// 카메라 실행 및 사진 촬영 후 앨범 인식 호출
  Future<void> _initiatePhotoCapture() async {
    final String filePath = await _captureImageFromScanner();
    if (filePath.isNotEmpty) {
      final collectionVM = context.read<CollectionViewModel>();
      await collectionVM.recognizeAlbum(File.fromUri(Uri.parse(filePath)));
    }
  }

  /// 문서 스캐너를 통해 사진 촬영 및 이미지 경로 반환
  Future<String> _captureImageFromScanner() async {
    try {
      final List<String>? imagesPath = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
      );
      debugPrint("Captured images path: $imagesPath");
      if (imagesPath == null) throw Exception('No image path found');
      return imagesPath.first;
    } catch (error) {
      final collectionVM = context.read<CollectionViewModel>();
      collectionVM.errorMessage = '문서 스캔 또는 인식 중 오류 발생: $error';
      return "";
    }
  }
}
