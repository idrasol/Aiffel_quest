import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 패키지 import
import 'BottomNavigationBar.dart';
import 'DetailScreen.dart'; // DetailScreen import 추가
import 'PhotoProvider.dart';
import 'UseCamera.dart';
import 'dart:io'; // 파일 관련 라이브러리 import

// GalleryPage 클래스 정의
class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int _selectedIndex = 2; // 선택된 탭의 인덱스
  Set<int> _selectedPhotoIds = {}; // 선택된 사진의 ID를 저장할 집합

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드 등을 수행할 수 있는 곳
  }

  // BottomNavigationBar의 항목이 탭되었을 때 호출되는 메소드
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 탭의 인덱스 업데이트
    });

    // NavigationHandler 클래스를 사용하여 화면 전환 처리
    NavigationHandler(context: context, selectedIndex: _selectedIndex).handleNavigation();
  }

  // 사진 선택 상태 토글
  void _toggleSelection(int photoId) {
    setState(() {
      if (_selectedPhotoIds.contains(photoId)) {
        _selectedPhotoIds.remove(photoId);
      } else {
        _selectedPhotoIds.add(photoId);
      }
    });
  }

  // 선택된 사진 삭제
  void _deleteSelectedPhotos() {
    setState(() {
      final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      photoProvider.photos.removeWhere((photo) => _selectedPhotoIds.contains(photo.id));
      _selectedPhotoIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('갤러리', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), // 화면 상단의 제목
        backgroundColor: Colors.redAccent, // 앱 바 배경 색상
        actions: [
          // 삭제 버튼을 추가하고 선택된 항목이 있을 때만 활성화
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _selectedPhotoIds.isEmpty ? null : _deleteSelectedPhotos, // 선택된 항목이 없으면 비활성화
            tooltip: '삭제',
            color: Colors.yellow, // 삭제 아이콘 색상 변경
            iconSize: 30, // 아이콘 크기 변경
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: photoProvider.photos.length, // Photos 리스트의 아이템 개수 설정
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 그리드뷰에서 가로로 보여질 항목 개수
            mainAxisSpacing: 8.0, // 주축(세로) 간격
            crossAxisSpacing: 8.0, // 교차축(가로) 간격
            childAspectRatio: 0.75, // 각 카드의 가로:세로 비율 조정
          ),
          itemBuilder: (context, index) {
            final photo = photoProvider.photos[index];
            final isSelected = _selectedPhotoIds.contains(photo.id);

            return GestureDetector(
              onTap: () async {
                // 사진 클릭 시 DetailScreen으로 이동
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(photo: photo), // photo를 사진으로 변경
                  ),
                );
                // DetailScreen에서 돌아오면 갤러리 업데이트
                setState(() {});
              },
              child: Stack(
                children: [
                  Card(
                    elevation: 4, // 카드 그림자 효과
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // 카드 모서리 둥글게 만들기
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                            child: getImageWidget(photo.url), // 이미지 위젯 표시
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            photo.title, // 사진 제목 텍스트 표시
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
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent, // 체크박스 배경을 투명하게 설정
                        ),
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value != null) {
                              _toggleSelection(photo.id);
                            }
                          },
                          activeColor: Colors.transparent, // 체크박스 배경색을 투명하게 설정
                          checkColor: Colors.white, // 체크 표시 색상 설정
                        ),
                      ),
                    ),
                  ),
                ],
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
          // UseCamera에서 돌아오면 갤러리 업데이트
          setState(() {});
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // 이미지 파일 경로로부터 이미지 위젯 반환
  Widget getImageWidget(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // 이미지 경로가 URL일 경우 네트워크에서 이미지 가져오기
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        height: double.infinity, // 이미지 높이를 가능한 최대값으로 설정
        width: double.infinity, // 이미지 너비를 가능한 최대값으로 설정
      );
    } else if (File(imagePath).existsSync()) {
      // 파일 시스템에서 이미지 가져오기
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        height: double.infinity, // 이미지 높이를 가능한 최대값으로 설정
        width: double.infinity, // 이미지 너비를 가능한 최대값으로 설정
      );
    } else {
      // 이미지 파일을 찾을 수 없는 경우 텍스트 표시
      return Center(
        child: Text('이미지를 찾을 수 없습니다.'),
      );
    }
  }
}