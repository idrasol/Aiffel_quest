import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'Photo.dart';

class DetailScreen extends StatefulWidget {
  final Photo photo; // Photo 객체를 받기 위한 변수

  DetailScreen({required this.photo}); // 생성자에서 Photo 객체를 받음

  @override
  _DetailScreen createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  bool _isLoading = false;
  String? _analysisResult;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _predictImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      List<int> imageBytes;

      if (widget.photo.url.startsWith('assets/')) {
        // 로컬 자산의 경우
        ByteData byteData = await rootBundle.load(widget.photo.url);
        imageBytes = byteData.buffer.asUint8List();
      } else if (widget.photo.url.startsWith('/')) {
        // 로컬 파일 시스템의 경우
        final file = File(widget.photo.url);
        if (await file.exists()) {
          imageBytes = await file.readAsBytes();
        } else {
          throw Exception('파일이 존재하지 않습니다.');
        }
      } else {
        // URL에서 이미지를 다운로드
        final response = await http.get(Uri.parse(widget.photo.url));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        } else {
          throw Exception('이미지 다운로드 실패: ${response.statusCode}');
        }
      }

      var uri = Uri.parse('https://04da-221-145-193-52.ngrok-free.app/generate_image_caption');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

      var serverResponse = await request.send();
      var responseData = await serverResponse.stream.toBytes();
      var responseString = utf8.decode(responseData); // 문자열 디코딩

      if (serverResponse.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(responseString);
        List<dynamic> captions = result['captions'] ?? [];
        setState(() {
          _analysisResult = captions.isNotEmpty ? captions.join('\n') : '분석 결과 없음';
          _errorMessage = null;
        });
      } else {
        setState(() {
          _analysisResult = null;
          _errorMessage = 'Error: ${serverResponse.statusCode} - ${serverResponse.reasonPhrase}';
          _successMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _analysisResult = null;
        _errorMessage = 'Error: $e';
        _successMessage = null;
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
        title: Text('상세 페이지'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getImageWidget(widget.photo.url, width: 300, height: 300),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _predictImage,
                icon: FaIcon(FontAwesomeIcons.robot, size: 28),
                label: Text(
                  'Google Cloud Vertex AI 분석',
                  style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_successMessage != null)
                Text(
                  _successMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              if (_analysisResult != null)
                _buildAnalysisResult(_analysisResult!),
              if (_analysisResult == null && _errorMessage == null && _successMessage == null)
                Text(
                  '분석 결과가 여기에 표시됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisResult(String result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이미지 분석 결과:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(
          result,
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ],
    );
  }

  // 사진 객체에 따라 올바른 이미지 위젯을 반환하는 함수
  Widget getImageWidget(String url, {double? width, double? height}) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      try {
        return Image.file(
          File(url),
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return Text(
          '이미지 로드 실패',
          style: TextStyle(fontSize: 16, color: Colors.red),
        );
      }
    }
  }
}