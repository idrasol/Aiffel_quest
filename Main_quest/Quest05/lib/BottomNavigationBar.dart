import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'UseCamera.dart';
import 'Gallery.dart';
import 'About.dart';
import 'ImageUploadPage.dart';
import 'main.dart';  // 이미지 업로드 페이지의 import 추가

class NavigationHandler {
  final BuildContext context;
  final int selectedIndex;

  NavigationHandler({
    required this.context,
    required this.selectedIndex,
  });

  void handleNavigation() {
    switch (selectedIndex) {
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
          MaterialPageRoute(builder: (context) => ImageUploadPage()),  // 이미지 업로드 화면으로 이동
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),  // About 화면으로 이동
        );
        break;
    // 다른 항목에 대한 동작을 추가할 수 있음
      default:
        break;
    }
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: '카메라',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_library),
          label: '갤러리',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.upload_file),
          label: '업로드',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '프로필',
        ),
      ],
      onTap: onItemTapped,
    );
  }
}