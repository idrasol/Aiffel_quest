import 'package:flutter/material.dart';
import 'package:flutter_lab/photo_gallery/main.dart'; // 전역 변수 Photos를 사용하기 위한 import
import 'DetailScreen.dart'; // DetailScreen import 추가
import 'UseCamera.dart';
import 'dart:io'; // 파일 관련 라이브러리 import
import 'About.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int _selectedIndex = 2;  // 선택된 탭의 인덱스
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
          MaterialPageRoute(builder: (context) => MyHomePage()),  // 카메라 화면으로 이동
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
          MaterialPageRoute(builder: (context) => AboutScreen()),  // 갤러리 화면으로 이동
        );
        break;
    // 다른 항목에 대한 동작을 추가할 수 있음
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('갤러리', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),  // 화면 상단의 제목
        backgroundColor: Colors.redAccent,  // 앱 바 배경 색상
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: Photos.length, // Photos 리스트의 아이템 개수 설정
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 그리드뷰에서 가로로 보여질 항목 개수
            mainAxisSpacing: 8.0, // 주축(세로) 간격
            crossAxisSpacing: 8.0, // 교차축(가로) 간격
            childAspectRatio: 0.75, // 각 카드의 가로:세로 비율 조정
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(photos: Photos[index]),
                  ),
                );
              },
              child: Card(
                elevation: 4, // 카드 그림자 효과
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // 카드 모서리 둥글게 만들기
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                      child: getImageWidget(Photos[index].url), // 이미지 위젯 표시
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Photos[index].title, // 사진 제목 텍스트 표시
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1, // 최대 라인 수 설정
                        overflow: TextOverflow.ellipsis, // 넘치는 경우 처리 방법
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt), // 카메라 아이콘
        onPressed: () async {
          // 카메라 페이지로 이동하여 새 사진 촬영
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UseCamera()),
          );
          setState(() {}); // 카메라에서 돌아오면 갤러리 업데이트
        },
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,  // 현재 선택된 항목 인덱스
          selectedItemColor: Colors.blue,  // 선택된 항목의 색상
          unselectedItemColor: Colors.black,  // 선택되지 않은 항목의 색상
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
      ),
    );
  }

  // 이미지 파일 경로로부터 이미지 위젯 반환
  Widget getImageWidget(String imagePath) {
    if (imagePath.startsWith('images/')) {
      // 경로가 'images/'로 시작하면 애셋 이미지로 로드
      return Image.asset(
        imagePath,
        fit: BoxFit.cover, // 이미지가 위젯에 맞게 조절될 수 있도록 설정
        height: 150, // 이미지 높이 고정
      );
    } else {
      // 경로가 파일 시스템 경로이면 파일에서 이미지 로드
      File imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          fit: BoxFit.cover, // 이미지가 위젯에 맞게 조절될 수 있도록 설정
          height: 150, // 이미지 높이 고정
        );
      } else {
        return Center(
          child: Text('이미지를 찾을 수 없습니다.'), // 파일이 존재하지 않을 경우 텍스트 표시
        );
      }
    }
  }
}