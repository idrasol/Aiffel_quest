import 'dart:io';
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리를 가져옵니다.
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // FontAwesome 아이콘을 사용하기 위한 라이브러리를 가져옵니다.
import 'package:provider/provider.dart'; // 상태 관리를 위한 Provider 패키지를 가져옵니다.
import 'PhotoProvider.dart'; // PhotoProvider 클래스가 있는 파일을 가져옵니다.
import 'Photo.dart'; // Photo 모델이 정의된 파일을 가져옵니다.
import 'AI.dart'; // AI 화면을 정의한 파일을 가져옵니다.
import 'BottomNavigationBar.dart'; // 사용자 정의 하단 네비게이션 바를 정의한 파일을 가져옵니다.

void main() {
  runApp(
    // PhotoProvider를 전역적으로 사용하기 위해 ChangeNotifierProvider를 사용합니다.
    ChangeNotifierProvider(
      create: (context) => PhotoProvider(),
      child: MyApp(), // MyApp 위젯을 최상위 위젯으로 설정합니다.
    ),
  );
}

// MyApp 클래스는 StatelessWidget을 상속받아 앱의 기본 설정을 정의합니다.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 기본 테마 색상을 설정합니다.
        visualDensity: VisualDensity.adaptivePlatformDensity, // 플랫폼에 따라 시각 밀도를 자동으로 조정합니다.
      ),
      home: MyHomePage(), // MyHomePage 위젯을 홈 화면으로 설정합니다.
    );
  }
}

// MyHomePage 클래스는 StatefulWidget을 상속받아 상태를 가지는 위젯을 정의합니다.
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// _MyHomePageState 클래스는 MyHomePage의 상태를 관리합니다.
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // 현재 선택된 하단 네비게이션 바의 인덱스를 저장합니다.
  Set<int> _selectedPhotoIds = {}; // 선택된 사진의 ID를 저장하는 집합입니다.

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 이미지 목록을 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotoProvider>(context, listen: false).fetchRandomImages();
    });
  }

  // 이미지를 새로고침하는 메소드입니다.
  Future<void> _handleRefresh() async {
    await Provider.of<PhotoProvider>(context, listen: false).refreshImages();
  }

  // 하단 네비게이션 바 아이템이 선택되었을 때 호출되는 메소드입니다.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    NavigationHandler(context: context, selectedIndex: _selectedIndex).handleNavigation();
  }

  // 사진을 선택하거나 선택 해제하는 메소드입니다.
  void _toggleSelection(int photoId) {
    setState(() {
      if (_selectedPhotoIds.contains(photoId)) {
        _selectedPhotoIds.remove(photoId);
      } else {
        _selectedPhotoIds.add(photoId);
      }
    });
  }

  // 선택된 사진을 삭제하는 메소드입니다.
  void _deleteSelectedPhotos() {
    setState(() {
      final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      photoProvider.photos.removeWhere((photo) => _selectedPhotoIds.contains(photo.id));
      _selectedPhotoIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context); // PhotoProvider를 가져옵니다.

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          FontAwesomeIcons.dog, // 앱 아이콘을 설정합니다.
          size: 35,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal, // 앱바 배경색을 설정합니다.
        title: Center(
          child: Text(
            'AI 기반 Flutter 이미지 분석 APP', // 앱 타이틀을 설정합니다.
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh), // 새로고침 버튼을 설정합니다.
            onPressed: _handleRefresh,
            tooltip: '새로 고침',
            color: Colors.white,
            iconSize: 30,
          ),
          IconButton(
            icon: Icon(Icons.delete), // 삭제 버튼을 설정합니다.
            onPressed: _deleteSelectedPhotos,
            tooltip: '삭제',
            color: Colors.yellow,
            iconSize: 30,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // 새로고침 시 호출되는 메소드를 설정합니다.
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: photoProvider.photos.length, // 사진의 개수를 설정합니다.
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 한 줄에 두 개의 사진을 배치합니다.
              crossAxisSpacing: 8.0, // 사진 간의 가로 간격을 설정합니다.
              mainAxisSpacing: 8.0, // 사진 간의 세로 간격을 설정합니다.
              childAspectRatio: 0.75, // 사진의 가로 세로 비율을 설정합니다.
            ),
            itemBuilder: (context, index) {
              final photo = photoProvider.photos[index]; // 현재 인덱스의 사진을 가져옵니다.
              final isSelected = _selectedPhotoIds.contains(photo.id); // 사진이 선택되었는지 확인합니다.

              return Stack(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AIScreen(photo: photo), // 사진을 클릭했을 때 AI 화면으로 이동합니다.
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: getImageWidget(
                          photo.url, // 사진의 URL을 가져옵니다.
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Checkbox(
                          value: isSelected, // 체크박스의 선택 상태를 설정합니다.
                          onChanged: (bool? value) {
                            if (value != null) {
                              _toggleSelection(photo.id); // 체크박스를 클릭했을 때 사진을 선택/해제합니다.
                            }
                          },
                          activeColor: Colors.transparent,
                          checkColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex, // 현재 선택된 인덱스를 설정합니다.
        onItemTapped: _onItemTapped, // 네비게이션 아이템이 클릭되었을 때 호출되는 메소드를 설정합니다.
      ),
    );
  }
}

// 이미지 위젯을 반환하는 헬퍼 함수입니다.
Widget getImageWidget(String imagePath, {double? width, double? height, BoxFit? fit}) {
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    // 네트워크 URL일 경우 Image.network 사용
    return Image.network(
      imagePath,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
    );
  } else if (imagePath.startsWith('/')) {
    // 로컬 파일 경로일 경우 Image.file 사용
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
      );
    } else {
      return Center(child: Text('파일을 찾을 수 없습니다.'));
    }
  } else {
    // 자산 파일일 경우 Image.asset 사용
    return Image.asset(
      imagePath,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
    );
  }
}