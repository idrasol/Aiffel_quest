import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'BottomNavigationBar.dart';
import 'Photo.dart';
import 'PhotoProvider.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;  // 선택된 이미지 파일

  int _selectedIndex = 3;  // 선택된 탭의 인덱스

  // BottomNavigationBar의 항목이 탭되었을 때 호출되는 메소드
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // 선택된 탭의 인덱스 업데이트
    });

    // NavigationHandler 클래스를 사용하여 화면 전환 처리
    NavigationHandler(context: context, selectedIndex: _selectedIndex).handleNavigation();
  }

  // 이미지 선택 메소드
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);  // 선택된 이미지 파일을 상태에 저장
      });
    }
  }

  // 이미지 업로드 메소드
  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지를 선택해주세요.')),
      );
      return;
    }

    final photoProvider = Provider.of<PhotoProvider>(context, listen: false);

    final newPhoto = Photo(
      id: photoProvider.photos.length + 1,  // 새 사진의 고유 ID (기존 사진 수 + 1)
      url: _image!.path,  // 새 사진 파일 경로
      title: '새로운 사진',
      detail: '새로 등록한 사진입니다.',  // 새 사진 제목
    );

    setState(() {
      photoProvider.photos.add(newPhoto);  // 리스트에 추가
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('이미지가 업로드되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '이미지 업로드',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),  // 화면 상단의 제목
        backgroundColor: Color(0xfff1e1aa),  // 앱 바의 배경색
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: _image == null
                    ? Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '선택된 이미지가 없습니다.',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image, size: 28),
              label: Text('이미지 선택', style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _uploadImage,
              icon: Icon(Icons.cloud_upload, size: 28),
              label: Text('이미지 업로드', style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.add_a_photo, size: 28),
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}