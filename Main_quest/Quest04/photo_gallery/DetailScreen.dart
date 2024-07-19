import 'package:flutter/material.dart';  // Flutter UI 구성 요소를 위한 패키지
import 'main.dart';  // 'main.dart' 파일에서 정의된 'Photo' 클래스와 'getImageWidget' 함수를 가져오기 위함

// DetailScreen 클래스 정의 - 사진의 상세 정보를 표시하는 화면
class DetailScreen extends StatelessWidget {
  final Photo photos;  // 상세 정보를 표시할 사진 객체

  // 생성자 - 필수로 'photos' 객체를 요구함
  DetailScreen({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photos.title),  // 앱 바에 표시할 제목 - 사진의 제목
      ),
      body: SingleChildScrollView(
        // 스크롤 가능한 뷰로 설정 - 내용이 화면을 넘어설 수 있는 경우 스크롤 가능
        child: Padding(
          padding: const EdgeInsets.all(16.0),  // 화면 가장자리로부터의 여백 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,  // 열의 시작 위치를 중앙 정렬
            children: [
              // 'getImageWidget' 함수를 사용하여 이미지 표시
              getImageWidget(
                photos.url,  // 이미지의 URL
                width: 300,  // 이미지의 너비
                height: 300,  // 이미지의 높이
                fit: BoxFit.cover,  // 이미지 비율 유지 및 박스 크기에 맞게 잘림
              ),
              SizedBox(height: 20),  // 위젯 간의 간격 설정
              Text(
                photos.title,  // 사진의 제목 표시
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),  // 텍스트 스타일 설정
              ),
              SizedBox(height: 10),  // 위젯 간의 간격 설정
              Text(
                photos.detail,  // 사진의 상세 정보 표시
                style: TextStyle(fontSize: 16, color: Colors.grey),  // 텍스트 스타일 설정
              ),
            ],
          ),
        ),
      ),
    );
  }
}