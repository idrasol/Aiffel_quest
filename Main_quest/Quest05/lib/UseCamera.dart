import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';  // Provider 패키지 추가
import 'BottomNavigationBar.dart';
import 'Photo.dart';
import 'PhotoProvider.dart';

class UseCamera extends StatefulWidget {
  @override
  _UseCameraState createState() => _UseCameraState();
}

class _UseCameraState extends State<UseCamera> {
  int _selectedIndex = 1;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String _newImagePath;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      _controller = CameraController(firstCamera, ResolutionPreset.high);
      await _controller.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String storageDirectory = '${appDirectory.path}/images';
      await Directory(storageDirectory).create(recursive: true);
      final String imagePath = '$storageDirectory/${DateTime.now().millisecondsSinceEpoch}.jpg';

      XFile picture = await _controller.takePicture();
      await picture.saveTo(imagePath);

      setState(() {
        _newImagePath = imagePath;
      });

      return imagePath;
    } catch (e) {
      print('Error taking picture: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카메라', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffefc53d),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          final newImagePath = await _takePicture();
          if (newImagePath.isNotEmpty) {
            setState(() {
              _newImagePath = newImagePath;

              // Provider를 통해 PhotoProvider에 접근
              final photoProvider = Provider.of<PhotoProvider>(context, listen: false);

              // 새로운 사진을 Photos 리스트에 추가
              final newPhoto = Photo(
                id: photoProvider.photos.length + 1, // 새 사진의 고유 ID (기존 사진 수 + 1)
                url: newImagePath,
                title: '새로운 사진',
                detail: '카메라로 촬영한 새로운 사진입니다.',
                classification: 'default'
              );
              setState(() {
                photoProvider.photos.add(newPhoto);  // 리스트에 새 사진 추가
              }); // 리스트에 새 사진 추가
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('사진이 저장되었습니다: $_newImagePath')),
            );
            Navigator.pop(context);
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    NavigationHandler(context: context, selectedIndex: _selectedIndex).handleNavigation();
  }
}