import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리를 가져옵니다.
import 'Photo.dart'; // Photo 모델을 정의한 파일을 가져옵니다.
import 'dart:convert'; // JSON 데이터를 다루기 위한 라이브러리를 가져옵니다.
import 'package:http/http.dart' as http; // HTTP 요청을 하기 위한 라이브러리를 가져옵니다.

// PhotoProvider 클래스는 ChangeNotifier를 상속받아 상태 관리를 합니다.
class PhotoProvider with ChangeNotifier {
  List<Photo> _photos = []; // Photo 객체들을 담는 리스트입니다.
  bool _isLoading = false; // 이미지 로딩 상태를 나타내는 변수입니다.
  String? _errorMessage; // 에러 메시지를 담는 변수입니다.
  bool _isInitialized = false; // 이미지를 처음 불러왔는지 확인하는 변수입니다.

  // 외부에서 _photos 리스트를 접근할 수 있게 하는 getter입니다.
  List<Photo> get photos => _photos;
  // 외부에서 _isLoading 변수를 접근할 수 있게 하는 getter입니다.
  bool get isLoading => _isLoading;
  // 외부에서 _errorMessage 변수를 접근할 수 있게 하는 getter입니다.
  String? get errorMessage => _errorMessage;

  // 서버에서 랜덤 이미지를 가져오는 메소드입니다.
  Future<void> fetchRandomImages() async {
    if (_isInitialized) return; // 이미 로드된 경우 서버 요청을 건너뜁니다.

    _isLoading = true; // 이미지를 로딩 중임을 나타냅니다.
    notifyListeners(); // 상태가 변경되었음을 알립니다.

    try {
      // 서버에 GET 요청을 보내서 랜덤 이미지를 가져옵니다.
      final response = await http.get(Uri.parse('https://04da-221-145-193-52.ngrok-free.app/random_images?num_images=10'));
      if (response.statusCode == 200) {
        // 서버가 성공적으로 응답했을 때
        final data = json.decode(response.body); // 응답 바디를 JSON으로 디코딩합니다.
        final List<String> imageUrls = List<String>.from(data['images']); // 이미지 URL 리스트를 가져옵니다.

        _photos.clear(); // 기존의 사진 리스트를 초기화합니다.
        for (int i = 0; i < imageUrls.length; i++) {
          // 가져온 이미지 URL 리스트를 Photo 객체로 변환하여 _photos 리스트에 추가합니다.
          _photos.add(Photo(id: i, url: imageUrls[i], title: 'Image $i', detail: 'Detail for image $i', classification:''));
        }
        _errorMessage = null; // 에러 메시지를 초기화합니다.
        _isInitialized = true; // 이미지를 성공적으로 불러왔음을 표시합니다.
      } else {
        // 서버가 에러를 응답했을 때
        _errorMessage = 'Failed to load images'; // 에러 메시지를 설정합니다.
      }
    } catch (e) {
      // 예외가 발생했을 때
      _errorMessage = 'Error fetching images: $e'; // 예외 메시지를 설정합니다.
    } finally {
      _isLoading = false; // 이미지를 로딩 중이 아님을 나타냅니다.
      notifyListeners(); // 상태가 변경되었음을 알립니다.
    }
  }

  // 이미지를 새로고침하는 메소드입니다.
  Future<void> refreshImages() async {
    _isInitialized = false; // 로컬 캐시를 초기화합니다.
    await fetchRandomImages(); // 새로 이미지를 불러옵니다.
  }
}