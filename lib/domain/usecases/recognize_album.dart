import 'dart:io';

import '../entities/album_recognition_result.dart';
import '../repositories/gemini_repository.dart';
import '../repositories/lens_repository.dart';
import '../repositories/storage_repository.dart';

class RecognizeAlbumUseCase {
  final IStorageRepository storageRepository;
  final ILensRepository lensRepository;
  final IGeminiRepository geminiRepository;

  RecognizeAlbumUseCase({
    required this.storageRepository,
    required this.lensRepository,
    required this.geminiRepository,
  });

  Future<AlbumRecognitionResult> execute(File image) async {
    // 1. 이미지 업로드 → URL 획득
    final imageUrl = await storageRepository.uploadImage(image);
    if (imageUrl.isEmpty) throw Exception("이미지 업로드 실패");

    // 2. Lens API 호출
    final lensData = await lensRepository.fetchLensData(imageUrl);

    // 3. Lens API 응답에서 title 목록 추출
    final titles = _extractTitlesFromLensResponse(lensData);
    if (titles.isEmpty) throw Exception("검색 결과에서 title 추출 실패");

    // 4. Gemini API 호출 → 최종 앨범 키워드 도출
    final generatedLabel = await geminiRepository.generateLabel(titles);
    if (generatedLabel.isEmpty) throw Exception("Gemini 응답 없음");

    return AlbumRecognitionResult(bestGuessLabel: generatedLabel, partialMatchingImages: [], fullDetectedText: "");
  }

  List<String> _extractTitlesFromLensResponse(Map<String, dynamic> responseJson) {
    final List<String> titles = [];
    if (responseJson.containsKey("organic") && responseJson["organic"] is List) {
      for (var item in responseJson["organic"]) {
        if (item is Map<String, dynamic> && item.containsKey("title")) {
          titles.add(item["title"].toString());
        }
      }
    }
    return titles;
  }
}
