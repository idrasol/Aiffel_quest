import 'package:flutter/material.dart';  // Flutter UI 구성 요소를 위한 패키지
import 'package:camera/camera.dart';  // 카메라 기능을 위한 패키지
import 'package:path_provider/path_provider.dart';  // 파일 경로를 얻기 위한 패키지
import 'dart:io';  // 파일 작업을 위한 패키지
import 'dart:async';  // 비동기 프로그래밍을 위한 패키지
import 'About.dart';
import 'Gallery.dart';
import 'main.dart';  // 전역 변수 Photos를 사용하기 위한 import

// UseCamera 클래스 정의 - 카메라를 사용하여 사진을 찍는 화면
class UseCamera extends StatefulWidget {
  @override
  _UseCameraState createState() => _UseCameraState();  // 상태를 가지는 클래스 생성
}

// _UseCameraState 클래스 정의 - UseCamera의 상태를 관리
class _UseCameraState extends State<UseCamera> {
  int _selectedIndex = 1;  // 선택된 탭의 인덱스

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

  late CameraController _controller;  // 카메라 컨트롤러 객체
  late Future<void> _initializeControllerFuture;  // 카메라 초기화 완료를 나타내는 Future 객체
  late String _newImagePath;  // 새로 찍은 사진의 경로를 저장할 변수



  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();  // 카메라 초기화 호출
  }

  // 카메라를 초기화하는 비동기 함수
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();  // 사용 가능한 카메라 목록을 가져옴
      final firstCamera = cameras.first;  // 첫 번째 카메라를 선택합니다.
      _controller = CameraController(firstCamera, ResolutionPreset.high);  // 카메라 컨트롤러 생성
      await _controller.initialize();  // 카메라를 초기화합니다.
      setState(() {});  // 상태를 업데이트하여 UI를 새로 고칩니다.
    } catch (e) {
      print('Error initializing camera: $e');  // 초기화 오류가 발생하면 콘솔에 출력
    }
  }

  @override
  void dispose() {
    _controller.dispose();  // 카메라 컨트롤러를 해제하여 리소스 누수 방지
    super.dispose();
  }

  // 사진을 찍고 저장하는 비동기 함수
  Future<String> _takePicture() async {
    try {
      await _initializeControllerFuture;  // 카메라가 초기화될 때까지 기다립니다.
      final Directory appDirectory = await getApplicationDocumentsDirectory();  // 애플리케이션의 문서 디렉토리 가져오기
      final String storageDirectory = '${appDirectory.path}/images';  // 이미지 저장 경로 설정
      await Directory(storageDirectory).create(recursive: true);  // 디렉토리가 존재하지 않으면 생성합니다.
      final String imagePath = '$storageDirectory/${DateTime.now().millisecondsSinceEpoch}.jpg';  // 새 사진 파일 경로 생성

      XFile picture = await _controller.takePicture();  // 사진 촬영
      await picture.saveTo(imagePath);  // 촬영한 사진을 저장합니다.

      setState(() {
        _newImagePath = imagePath;  // 새로 찍은 사진의 경로를 업데이트합니다.
      });

      return imagePath;  // 사진 경로를 반환합니다.
    } catch (e) {
      print('Error taking picture: $e');  // 사진 촬영 오류가 발생하면 콘솔에 출력
      return '';  // 오류가 발생하면 빈 문자열 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카메라', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),  // 화면 상단의 제목
        backgroundColor: Color(0xffefc53d),  // 앱 바의 배경색
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,  // 카메라 초기화 상태를 기다립니다.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 카메라 초기화가 완료되면 카메라 미리보기를 표시합니다.
            return CameraPreview(_controller);
          } else {
            // 초기화가 진행 중일 때 로딩 인디케이터를 표시합니다.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),  // 카메라 아이콘을 가진 버튼을 설정합니다.
        onPressed: () async {
          final newImagePath = await _takePicture();  // 사진을 찍고 경로를 가져옵니다.
          if (newImagePath.isNotEmpty) {
            setState(() {
              _newImagePath = newImagePath;

              // 새로운 사진을 Photos 리스트에 추가
              final newPhoto = Photo(
                id: Photos.length + 1,  // 새 사진의 고유 ID (기존 사진 수 + 1)
                url: newImagePath,  // 새 사진 파일 경로
                title: '새로운 사진',  // 새 사진 제목
                detail: '카메라로 촬영한 새로운 사진입니다.',  // 새 사진 설명
              );
              Photos.add(newPhoto);  // 리스트에 새 사진 추가
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('사진이 저장되었습니다: $_newImagePath')),  // 사진 저장 완료 메시지 표시
            );
            Navigator.pop(context);  // 이전 화면으로 돌아갑니다.
          }
        },
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
