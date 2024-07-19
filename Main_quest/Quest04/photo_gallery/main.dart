import 'package:flutter/material.dart';  // Flutter UI 구성 요소를 위한 패키지
import 'package:flutter_lab/photo_gallery/About.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';  // Font Awesome 아이콘 사용을 위한 패키지
import 'dart:io';  // 파일 작업을 위한 패키지
import 'AI.dart';  // AI 분석 화면을 정의한 파일
import 'UseCamera.dart';  // 카메라 기능을 정의한 파일
import 'Gallery.dart';  // 갤러리 화면을 정의한 파일

// Photo 클래스 정의 - 사진 객체를 표현
class Photo {
  final int id; // 사진의 고유 ID
  final String url; // 사진의 파일 경로
  final String title; // 사진의 제목
  final String detail; // 사진 상세 설명

  // 생성자 - 각 속성을 필수로 요구
  Photo({required this.id, required this.url, required this.title, required this.detail});
}

// 전역 변수: 모든 사진 목록을 저장할 리스트
final List<Photo> Photos = [
  // Photo 객체를 생성하여 리스트에 추가
  Photo(id: 1, url: 'images/jellyfish.jpg', title: 'JellyFish', detail: '해파리는 대체로 투명하며, 갓 둘레에 많은 촉수를 가지고 있다. 촉수에는 자세포(쏘기세포)가 있어 동물분류학상 자포동물(刺胞動物)문에 속한다. 젤리 같은 몸을 가져서 영어로는 젤리피시(jellyfish)라 부른다. 정약전의 「자산어보」에는 해파리를 ‘해타(海鮀)’라 하고, 속명을 해팔어(海八魚)라고 하였다. 해타는 바다의 모래무지란 뜻이다. ‘타’는 뱀을 뜻하기도 하는데, 길게 늘어진 촉수가 뱀처럼 보여 붙은 이름일 듯하다. 속명 해팔어는 해파리 발음을 따온 것으로 추정된다. 일본에서는 구라게(くらげ)라고 한다.'),
  Photo(id: 2, url: 'images/cat.jpg', title: 'CAT', detail: '한자로는 묘(猫)라 하고, 수고양이를 낭묘(郎猫), 암고양이를 여묘(女猫), 얼룩고양이를 표화묘(豹花猫), 들고양이를 야묘(野猫)로 부르기도 한다. 현재 집에서 기르고 있는 모든 애완용 고양이는 아프리카·남유럽·인도에 걸쳐 분포하는 리비아고양이(Felis silvestris lybica)를 사육 순화시킨 것으로, 전세계에서 2억 마리가 넘게 사육되는 것으로 알려져 있다. 약 5,000년 전 아프리카 북부 리비아산(産)의 야생고양이가 고대 이집트인에 의해 길들여져서 점차 세계 각지에 퍼졌다고 한다. 이것은 고대 이집트의 벽화 ·조각, 고양이의 미라 등으로 미루어 명확하지만, 그것이 현재 사육되는 모든 고양이의 조상인지는 의문이다.'),
  Photo(id: 3, url: 'images/dog.jpg', title: 'DOG', detail: '야생동물 가운데 가장 먼저 가축화되었다. 한자어로는 견(犬) 이외에 구(狗)·술(戌) 등으로 표기된다. 기(猉)·교(狡) 등은 작은 개를 뜻한다.)'),
  Photo(id: 4, url: 'images/pomeranian.jpg', title: 'POMERANIAN', detail: '지금은 작은 반려견이지만 포메라니안은 북극에서 썰매를 끌던 개들의 후손으로 초창기에는 지금보다 큰 편이었다. 공처럼 둥글고 풍성하게 부풀어 오른 털이 특징이다. 여우와 비슷한 깜찍한 얼굴에 작은 눈망울이 매력적이고 보호본능이 생기는 귀여운 품종이다.'),
  Photo(id: 5, url: 'images/maltese.jpg', title: 'MALTESE', detail: '작업견이나 사냥개로 이용되던 역사가 없는 타고난 반려견. 순백에 실크 같은 광택이 있는 피모를 가졌으며 밑털이 없다. 새까맣고 동그란 눈도 특징이다.'),
  Photo(id: 6, url: 'images/persiancat.jpg', title: 'PERSIANCAT', detail: '전세계적으로 최고의 인기를 누리는 긴 털 고양이의 대표주자. 품위 있는 외모에 차분한 성격이 합쳐져 ‘고양이의 귀부인’이라는 별명이 잘 어울린다. 털과 눈의 색깔이 매우 다양하게 나타난다. 푸른 눈을 가진 흰고양이가 가장 인기가 높다.'),
];

// 앱의 진입점
void main() {
  runApp(MyApp());  // MyApp 위젯을 루트 위젯으로 실행
}

// MyApp 클래스 정의 - MaterialApp을 구성
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),  // MyHomePage를 MaterialApp의 홈으로 설정
    );
  }
}

// MyHomePage 클래스 정의 - 상태를 가지는 홈 페이지
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();  // 상태 관리 클래스 생성
}

// 상태 관리 클래스 - _MyHomePageState
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;  // 선택된 탭의 인덱스

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

  // 화면에 표시될 위젯 목록
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),  // 홈 페이지 텍스트
    Text('Camera Page'),  // 카메라 페이지 텍스트
    Text('Gallery Page'),  // 갤러리 페이지 텍스트
    Text('Profile Page'),  // 프로필 페이지 텍스트
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(10.0),  // 아이콘 주변에 여백 추가
          child: Icon(
            FontAwesomeIcons.dog,  // Font Awesome의 개 아이콘 사용
            size: 40,  // 아이콘의 크기
            color: Color(0xffFF6666),  // 아이콘의 색상
          ),
        ),
        backgroundColor: Color(0xff70ea77),  // 앱 바의 배경색
        title: Center(child: Text('Photo Gallery')),  // 앱 바의 제목 중앙 정렬
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: Photos.length,  // 사진 리스트의 항목 개수
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      getImageWidget(
                        Photos[index].url,  // 사진 URL
                        width: 200,  // 이미지 너비
                        height: 160,  // 이미지 높이
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AIScreen(photo: Photos[index]),  // AI 분석 화면으로 이동
                            ),
                          );
                        },
                        child: Text("AI 분석"),  // 버튼 텍스트
                      ),
                    ],
                  ),
                );
              },
              scrollDirection: Axis.horizontal,  // 그리드뷰가 수평으로 스크롤
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,  // 각 행에 3개의 아이템 배치
              ),
            ),
          ),
        ],
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
}

// 이미지 파일 경로로부터 이미지 위젯 반환
Widget getImageWidget(String imagePath, {double? width, double? height, BoxFit? fit}) {
  if (imagePath.startsWith('images/')) {
    // 경로가 'images/'로 시작하면 애셋 이미지로 로드
    return Image.asset(
      imagePath,
      fit: fit ?? BoxFit.cover,  // 이미지가 위젯에 맞게 조절될 수 있도록 설정
      width: width,
      height: height,
    );
  } else {
    // 경로가 파일 시스템 경로이면 파일에서 이미지 로드
    File imageFile = File(imagePath);
    if (imageFile.existsSync()) {
      return Image.file(
        imageFile,
        fit: fit ?? BoxFit.cover,  // 이미지가 위젯에 맞게 조절될 수 있도록 설정
        width: width,
        height: height,
      );
    } else {
      return Center(
        child: Text('이미지를 찾을 수 없습니다.'),  // 파일이 존재하지 않을 경우 텍스트 표시
      );
    }
  }
}