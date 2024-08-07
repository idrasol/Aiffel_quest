import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Photo.dart';

class DogHeadResultPage extends StatefulWidget {
  final Photo photo;

  DogHeadResultPage({required this.photo});

  @override
  _DogHeadResultPageState createState() => _DogHeadResultPageState();
}

class _DogHeadResultPageState extends State<DogHeadResultPage> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _initializeImage();
  }

  Future<void> _initializeImage() async {
    try {
      List<int> imageBytes;

      if (widget.photo.url.startsWith('/')) {
        final file = File(widget.photo.url);
        if (await file.exists()) {
          imageBytes = await file.readAsBytes();
        } else {
          throw Exception('파일이 존재하지 않습니다.');
        }
      } else {
        final response = await http.get(Uri.parse(widget.photo.url));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        } else {
          throw Exception('이미지 다운로드 실패: ${response.statusCode}');
        }
      }

      if (await _isValidImage(Uint8List.fromList(imageBytes))) {
        setState(() {
          _imageBytes = Uint8List.fromList(imageBytes);
        });
      } else {
        throw Exception('유효하지 않은 이미지 데이터');
      }
    } catch (e) {
      setState(() {
        _errorMessage = '이미지 로드 오류: $e';
      });
    }
  }

  Future<bool> _isValidImage(Uint8List data) async {
    try {
      final image = await decodeImageFromList(data);
      return image.width > 0 && image.height > 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> _performDetection() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      List<int> imageBytes = _imageBytes ?? [];
      // 이미지를 전송하기 전에 크기와 모양을 출력합니다.
      final imageBefore = await decodeImageFromList(Uint8List.fromList(imageBytes));
      print('전송 전 이미지 크기: ${imageBefore.width} x ${imageBefore.height}');

      var uri = Uri.parse('https://04da-221-145-193-52.ngrok-free.app/detect_head');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

      var serverResponse = await request.send();
      if (serverResponse.statusCode == 200) {
        var responseData = await serverResponse.stream.toBytes();
        // 이미지를 수신한 후 크기와 모양을 출력합니다.
        final imageAfter = await decodeImageFromList(Uint8List.fromList(responseData));
        print('수신 후 이미지 크기: ${imageAfter.width} x ${imageAfter.height}');

        if (await _isValidImage(responseData)) {
          setState(() {
            _imageBytes = Uint8List.fromList(responseData);
            _successMessage = '감지가 성공적으로 완료되었습니다!';
          });
        } else {
          throw Exception('유효하지 않은 이미지 데이터');
        }
      } else {
        setState(() {
          _imageBytes = null;
          _errorMessage = '서버 오류: ${serverResponse.statusCode} - ${serverResponse.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _imageBytes = null;
        _errorMessage = '오류 발생: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결과 페이지'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageBytes != null)
              Image.memory(
                _imageBytes!,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              )
            else if (_errorMessage != null)
              Text(
                '이미지를 로드할 수 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: _performDetection,
                    icon: FaIcon(
                      FontAwesomeIcons.paw,
                      size: 28,
                    ),
                    label: Text(
                      'Detection',
                      style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: _performDetection,
                    icon: FaIcon(FontAwesomeIcons.cat, size: 28),
                    label: Text(
                      'Rmark',
                      style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            if (_successMessage != null)
              Text(
                _successMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}