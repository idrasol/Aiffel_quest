import 'package:flutter/material.dart';
import 'Gallery.dart';
import 'main.dart';
import 'UseCamera.dart';  // Flutter UI 구성 요소를 위한 패키지

// AboutScreen 클래스 정의 - 앱 정보 화면
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();  // 상태 클래스 생성
}

// 상태 관리 클래스 - AboutScreen의 상태를 관리
class _AboutScreenState extends State<AboutScreen> {
  int _selectedIndex = 3;  // 선택된 탭의 인덱스

  // BottomNavigationBar의 항목이 탭되었을 때 호출되는 메소드
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // 선택된 탭의 인덱스 업데이트
    });

    // 탭 인덱스에 따라 다른 화면으로 이동
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),  // 홈 화면으로 이동
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UseCamera()),  // 카메라 화면으로 이동
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GalleryPage()),  // 갤러리 화면으로 이동
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),  // 현재 화면으로 다시 이동 (불필요할 수 있음)
        );
        break;
    // 다른 항목에 대한 동작을 추가할 수 있음
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제작', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),  // 화면 상단의 제목
        backgroundColor: Color(0xff3da6ef),  // 앱 바의 배경색
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // 화면 가장자리와 위젯 간의 여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // 열의 시작 위치 정렬
          children: [
            // 프로필 카드
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '제작자: 정권영',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '제작일자: 2024년 7월 19일',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // 버전 및 설명 카드
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '버전: 1.0.0',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '애플리케이션 설명: 이 애플리케이션은 이미지 분석을 위한 AI 기반 기능을 제공하며, Flutter로 개발되었습니다.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,  // 현재 선택된 항목 인덱스
        selectedItemColor: Colors.deepPurple,  // 선택된 항목의 색상
        unselectedItemColor: Colors.grey[700],  // 선택되지 않은 항목의 색상
        backgroundColor: Colors.white,  // 바 배경 색상
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),  // 홈 아이콘
            label: 'Home',  // 홈 레이블
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_enhance),  // 카메라 아이콘
            label: '카메라',  // 카메라 레이블
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_in_picture),  // 사진 아이콘
            label: '갤러리',  // 갤러리 레이블
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),  // 나 아이콘
            label: '나',  // 나 레이블
          ),
        ],
        onTap: _onItemTapped,  // 항목 탭 시 호출되는 메소드
      ),
    );
  }
}